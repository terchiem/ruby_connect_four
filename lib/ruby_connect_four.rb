class Array
  def reverse_each_with_index &block
    (0...length).reverse_each do |i|
      block.call self[i], i
    end
  end
end

module CellControl
  def insert(col, player, row = nil)
    if row.nil?
      @cells.reverse_each_with_index do |r, i|
        if r[col].nil?
          r[col] = player
          return i
        end
      end
      return -1
    else
      if @cells[row][col].nil?
        @cells[row][col] = player
        return row
      else
        return -1
      end
    end
  end

  def clear
    @cells = Array.new(6) { Array.new(7) }
  end
end

class Board
  include CellControl

  attr_reader :cells
  
  def initialize
    @cells = Array.new(6) { Array.new(7) }
  end

  def display
    col = @cells[0].length
    empty = " . "
    print "\n"
    col.times { print "===" }
    print "\n"
    @cells.each do |row|
      row.each do |cell|
        print cell.nil? ? empty : cell
      end
      print "\n"
    end
    col.times { print "---" }
    print "\n"
    col.times { |i| print " #{i} " }
    print "\n"
    col.times { print "===" }
    print "\n"
  end

  def tie?
    @cells.each do |row|
      return false if row.compact.length != row.length
    end
    true
  end
end

class Player
  include CellControl

  def initialize
    @cells = Array.new(6) { Array.new(7) }
  end

  def winner?
    check_row || check_col || check_diag
  end

  def check_row
    @cells.each do |row|
      if row.compact.length >= 4
        row.each_with_index do |cell, i|
          return true if cell && row[i+1] && row[i+2] && row[i+3]
        end
      end
    end
    false
  end

  def check_col
    height = @cells.length - 4
    @cells.each_with_index do |row, i|
      next if i < height
      row.each_with_index do |cell, j|
        return true if cell && @cells[i-1][j] && @cells[i-2][j] && @cells[i-3][j]
      end
    end
    false
  end

  def check_diag
    height = @cells.length - 4
    left_boundary = 2

    @cells.each_with_index do |row, i|
      next if i < height

      row.each_with_index do |cell, j|
        right = cell && @cells[i-1][j+1] && @cells[i-2][j+2] && @cells[i-3][j+3]
        left = cell && @cells[i-1][j-1] && @cells[i-2][j-2] && @cells[i-3][j-3]

        left = false if j < left_boundary

        return true if left || right
      end
    end
    false
  end
end

class Game
  def initialize
      @players = [ Player.new, Player.new ]
      @pieces = [ " \u26AA", " \u26AB" ]
      @board = Board.new
  end

  def start_game
      current_player = 0

      until game_over?
          @board.display

          inserted = false
          until inserted
            move = prompt_move(current_player)
            inserted = make_move(current_player, move)
            puts "Invalid move" unless inserted
          end

          current_player = current_player == 0 ? 1 : 0
      end

      @board.display
      display_result
      new_game if new_game?
  end

  def prompt_move(player)
    puts "Player #{player+1}'s Turn'"
    while true
      print "Enter a column: "
      input = gets.chomp
      if input.match?(/^\d$/)
        if input.to_i.between?(0,7)
          return input.to_i
        else
          puts "Input out of range"
        end
      else
        puts "Invalid entry"
      end
    end
  end

  def make_move(player, col)
      insert_row = @board.insert(col, @pieces[player])
      if insert_row < 0
        return false
      else
        @players[player].insert(col, @pieces[player], insert_row)
      end
      true
  end

  def game_over?
    @board.tie? || @players[0].winner? || @players[1].winner?
  end

  def display_result
    if @players[0].winner?
      puts "Player 1 wins!"
    elsif @players[1].winner?
      puts "Player 2 wins!"
    else
      puts "Tie game!"
    end
  end

  def new_game?
    while true
      print "Play again? (y/n): "
      input = gets.chomp.downcase
      puts ""
      if input.match?(/^[yn]$/)
        return input == "y" ? true : false
      else
        puts "Invalid choice."
      end
    end
  end

  def new_game
    @board.clear
    @players[0].clear
    @players[1].clear
    start_game
  end
end

game = Game.new
game.start_game