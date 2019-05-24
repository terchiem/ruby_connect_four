require './lib/ruby_connect_four'

describe Board do
  before { @board = Board.new }

  describe '#rows' do
    it "correct number of rows" do
      expect(@board.cells.length).to eq(6)
    end

    it "correct number of columns" do
      expect(@board.cells[0].length).to eq(7)
    end
  end

  describe '#insert' do
    context "insert into empty column" do
      it "works" do
        expect(@board.insert(0, "x")).to eq(5)
      end

      it "in the correct position" do
        @board.insert(0, "x")
        expect(@board.cells[-1][0]).to_not be_nil
      end
    end

    context "insert into partially filled column" do
      it "works" do
        @board.insert(1, "x")
        @board.insert(1, "x")
        expect(@board.insert(1, "x")).to eq(3)
      end

      it "in the correct position" do
        3.times { @board.insert(1, "x") }
        expect(@board.cells[-3][1]).to_not be_nil
      end
    end

    it "does not insert into full column" do
      6.times { @board.insert(1, "x") }
      expect(@board.insert(1, "x")).to eq(-1)
    end
  end

  describe "#tie?" do
    it "works when board is full" do
      7.times do |i|
        6.times { @board.insert(i, "x") }
      end
      expect(@board.tie?).to be true
    end
  end
end

describe Player do
  before { @player = Player.new }

  describe '#winner?' do
    it "win by row" do
      @player.insert(3, "x")
      @player.insert(4, "x")
      @player.insert(5, "x")
      @player.insert(6, "x")
      expect(@player.winner?).to be true
    end

    it "win by column" do
      4.times { @player.insert(0, "x") }
      expect(@player.winner?).to be true
    end

    it "win by diagonal(right)" do
      @player.insert(2, "x", 5)
      @player.insert(3, "x", 4)
      @player.insert(4, "x", 3)
      @player.insert(5, "x", 2)
      expect(@player.winner?).to be true
    end

    it "win by diagonal(left)" do
      @player.insert(3, "x", 5)
      @player.insert(2, "x", 4)
      @player.insert(1, "x", 3)
      @player.insert(0, "x", 2)
      expect(@player.winner?).to be true
    end

    it "does not trigger with near wins" do
      @player.insert(3, "x", 5)
      @player.insert(2, "x", 4)
      @player.insert(1, "x", 3)
      @player.insert(4, "x", 4)
      @player.insert(5, "x", 3)
      @player.insert(3, "x", 4)
      @player.insert(3, "x", 3)
      @player.insert(2, "x", 5)
      @player.insert(4, "x", 5)
      expect(@player.winner?).to be false
    end
  end
end