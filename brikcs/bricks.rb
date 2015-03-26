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

