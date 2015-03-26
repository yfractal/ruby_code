# coding: utf-8
# question describion:
# https://ruby-china.org/topics/22166
#
# 拼图的单位为[积木块]
# [积木条]由5个[积木块]组成，每个[积木块]面与面相贴(二维界面)，可组合成任何可以组成的[积木形状]
# [积木条]放在[拼盘]中无间隙放满([积木条]形状类型不同重复)即成功,[拼盘]长宽为3x20(单位[积木块])

# an old and uncomplete solution: https://gist.github.com/yfractal/9fd567789ec0ef1534d0


class Board
  attr_reader :height, :width, :cells
  def initialize(width, height)
    @width  = width
    @height = height
    @cells  = Array.new(height){ |_| Array.new(width){|_| false} }
  end

  def fill_in(unites)
    unites.each do |unite|
      row, column = unite
      cells[row][column] = true
    end

    self
  end

  def to_s
    cells.map do |row|
      row.map do |cell|
        cell ? "X" : "*"
      end.join + "\n"
    end.join
  end
end

class Brick
  ROW    = 0
  COLUMN = 1

  attr_reader :count, :unites

  def initialize(unites = [])
    @unites = unites
    @count  = unites.length
  end

  def relative_unites
    @relative_unites ||= unites.map do |unite|
      [unite[ROW] - min_row, unite[COLUMN] -  min_column]
    end.sort
  end

  def min_column
    @min_column ||= unites.map {|unite| unite[COLUMN]}.min
  end

  def max_column
    @mac_column ||= unites.map {|unite| unite[COLUMN]}.max
  end

  def min_row
    @min_row ||= unites.map {|unite| unite[ROW]}.min
  end

  def max_row
    @max_row ||= unites.map {|unite| unite[ROW]}.max
  end

  def width
    @width ||= max_column - min_column + 1
  end

  def height
    @height ||= max_row - min_row + 1
  end

  def to_s
    board = Board.new(width, height)
    board.fill_in(relative_unites).to_s
  end

  def == (other_brick)
    relative_unites == other_brick.relative_unites
  end

  class << self
    # todo: refactor
    def all_uniq_bricks(brick_unites_count)
      all_bricks = []

      all_next_unites = lambda {|current_unites|
        last_unite = current_unites[-1]
        possible_next_unites = [[last_unite[ROW] + 1, last_unite[COLUMN]    ],
                                [last_unite[ROW]    , last_unite[COLUMN] + 1],
                                [last_unite[ROW] - 1, last_unite[COLUMN]    ],
                                [last_unite[ROW]    , last_unite[COLUMN] - 1]]

        possible_next_unites.select{ |unite| not current_unites.include?(unite) }
      }

      generate_brick = lambda {|current_unites, remain_unites_count|
        if remain_unites_count == 0
          all_bricks.push(Brick.new(current_unites))
        else
          last_unite = current_unites[-1]
          next_unites = all_next_unites.call(current_unites)

          next_unites.each do |next_unite|
            generate_brick.call([].concat(current_unites).concat([next_unite]), remain_unites_count - 1)
          end
        end
      }

      generate_brick.call([[0,0]], brick_unites_count - 1)

      all_bricks.uniq {|brick| brick.relative_unites }
    end
  end
end

class BoardWithBricks < Board
  attr_reader :brick_unites_count, :aviliable_bricks
  attr_accessor :cells

  def initialize(width, height, aviliable_bricks)
    super(width, height)
    @aviliable_bricks   = aviliable_bricks
    @brick_unites_count = aviliable_bricks.first.count
  end

  def fill_in(brick)
    # brick is unites
    if brick.class == Array
      super(brick)
    else
      super(brick.unites)
      aviliable_bricks.delete(brick)
    end
  end

  def dup
    new_board = BoardWithBricks.new(width, height, aviliable_bricks)

    new_cells = cells.map {|row| row.dup }
    new_board.cells = new_cells

    new_board
  end

  def fisrt_empty_cell
    cells.each_with_index do |row, row_index|
      row.each_with_index do |cell, column_index|
        return [row_index, column_index] unless cell
      end
    end
  end

  def has_empty_cell?
    cells.any? do |row|
      row.any? {|cell| cell == false}
    end
  end

  def full?
    not has_empty_cell?
  end

  class << self
    def next_posible_unites(board, row, column)
      unites = []
      (-1..1).each do |row_diff|
        (-1..1).each do |column_diff|
          next_row, next_column = row + row_diff, column + column_diff
          if (next_row >= 0 and next_column >= 0) and next_row < board.height and next_column < board.width and ! board.cells[next_row][next_column]
            unites.push([next_row, next_column])
          end
        end
      end

      unites
    end

    def possible_full_unites(board)
      full_unites_arr = []

      get_posible_bricks = lambda {|board, row, column, unites|
        if unites.length == board.brick_unites_count
          full_unites_arr.push(unites)
        else
          next_posible_unites(board, row, column).each do |next_unite|
            new_board = board.dup

            new_unites = [].concat(unites).push(next_unite)

            new_board.fill_in(new_unites)
            next_row, next_column = next_unite
            get_posible_bricks.call(new_board, next_row, next_column, new_unites)
          end
        end
      }

      row, column = board.fisrt_empty_cell

      get_posible_bricks.call(board, row, column, [[row, column]])

      full_unites_arr
    end

    def has_solution_helper?(board)
      if board.full?
        return true
      else
        possible_full_unites(board).each do |full_unites|
          next_brick = Brick.new(full_unites)

          if board.aviliable_bricks.include? next_brick
            new_board = board.dup

            new_board.fill_in(next_brick)

            return true if has_solution_helper?(new_board)
          end
        end
      end

      false
    end

    def init_board(width, height, brick_unites_count)
      self.new(width, height, Brick.all_uniq_bricks(brick_unites_count))
    end

    def has_solution?(width, height, brick_unites_count)
      board = init_board(width, height, brick_unites_count)

      has_solution_helper?(board)
    end
  end
end
