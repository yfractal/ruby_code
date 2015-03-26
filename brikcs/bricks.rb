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
    @cells = Array.new(height){ |_| Array.new(width){|_| false} }
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
end
