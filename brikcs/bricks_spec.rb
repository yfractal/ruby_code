$: << File.dirname(__FILE__)
require "rspec"
require "bricks"

describe "Board" do
  let(:board1) { Board.new(3, 2)}
  let(:board2) { Board.new(2, 2)}

  it "init board by width and height" do
    expect(board1).to be_a Board
    expect(board1.width).to eq 3
    expect(board1.height).to eq 2
  end

  it "should show the boad friendly" do
    expect(board2.to_s).to eq "**\n" + "**\n"
    expect(board1.to_s).to eq "***\n" + "***\n"
  end

  it "can fill in unites" do
    board2.fill_in([[0,0], [1,1]])
    expect(board2.cells).to eq [[true, false],
                                [false, true]]

    board1.fill_in([[0,0], [1,1]])
    expect(board1.cells).to eq [[true, false, false],
                                [false, true, false]]
  end
end

