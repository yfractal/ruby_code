$: << File.dirname(__FILE__)
require "rspec"
require "bricks"
require "pry"

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

describe "Brick" do
  let(:brick1) {Brick.new([[0, 0],
                           [1, 0], [1, 1], [1, 2]])}

  let(:brick2) { Brick.new([[1, 0],
                            [2, 0], [2, 1], [2, 2]]) }

  it "init" do
    expect(brick2).to be_an Brick
    expect(brick2.count).to eq 4
  end

  it "relative unites" do
    expect(brick2.relative_unites).to eq [[0, 0],
                                          [1, 0], [1, 1], [1, 2]]
    brick3 = Brick.new([[1, 0], [0, 0]])
    expect(brick3.relative_unites).to eq [[0, 0], [1, 0]]
  end

  it "show brick well" do
    expect(brick1.to_s).to eq "X**\n" +
                              "XXX\n"
  end

  it "same brick" do
    brick3 = Brick.new([[0, 0], [0, 1],
                        [1, 1], [1, 2]])

    expect(brick1).to eq brick2
    expect(brick1).not_to eq brick3
  end

  it "all_uniq_bricks" do
    bricks = Brick.all_uniq_bricks(2)
    relative_unites = bricks.map {|brick| brick.relative_unites }
    expect(relative_unites).
      to eq [[[0,0],[1, 0]],
             # X
             # X
             [[0,0], [0, 1]]# XX
            ]

    three_unites_bricks = Brick.all_uniq_bricks(3)

    relative_unites = three_unites_bricks.map {|brick| brick.relative_unites }

    expect(relative_unites).
      to eq [[[0, 0], [1, 0], [2, 0]],
             [[0, 0], [1, 0], [1, 1]],
             [[0, 1], [1, 0], [1, 1]],
             [[0, 0], [0, 1], [1, 1]],
             [[0, 0], [0, 1], [0, 2]],
             [[0, 0], [0, 1], [1, 0]]]
  end
end

describe BoardWithBricks do
  it "init with aviliable_bricks" do
    board = BoardWithBricks.new(3, 3, [[1,2]])

    expect(board).to be_a BoardWithBricks
    expect(board.aviliable_bricks).to eq [[1,2]]
    expect(board.brick_unites_count).to eq 2
  end

  it "can find solution"
  it "can find all solutions(optional)"
end
