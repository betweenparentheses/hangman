require "yaml"

module Hangman
class Game

def initialize
  @word = ""
  @display_word = ""
  @guessed_wrong = []
  @num_wrong = 0
end

def play

  load = check_load
  load_game if load == "Y"

  set_word
  take_turns

  ending
end

def set_word
  word_list = File.open("5desk.txt").readlines
  until @word.length >= 5 && @word.length <= 12
    @word = word_list.sample.chomp.upcase
  end
  @display_word = "_" * @word.length
end

def display_turn
  puts "\n*************************************"
  show_hangman(@num_wrong)
  show_letters
end
def take_turns
  until lost? || victorious?
    display_turn

    print "Guess a letter, or enter the & character to save your game: "
    guess = gets[0].upcase

    check_guess(guess)
  end
end

def check_load
  print "Do you want to load a game (Y/N): "
  load = gets.chomp.upcase
end

def ending
  if lost?
    puts "\nThe hangman has been hung. You lose."
    puts "\nThe word was #{@word}, by the way."
  elsif victorious?
    puts "\nVictory! It WAS the word '#{@word}.'"
  end
  exit
end


def save_game
  File.open("game.sv", 'w') {|file| file.write(YAML::dump(self))}
end

def load_game
  loaded = YAML::load(File.read("game.sv"))
  puts "Savegame loaded!"
  loaded.take_turns
  loaded.ending
end


def lost?
  @num_wrong >= 10
end

def victorious?
  @display_word == @word
end


def show_letters
  puts "The #{@word.length}\-letter word is below:"
  (0..@display_word.length-1).each do |index|
    print "#{@display_word[index]} "
  end
  puts "\n"

  print "\nINCORRECT GUESSES: "
  puts @guessed_wrong.join(", ").upcase
end

def check_guess(guess)
  if guess == "&"
    save_game
    puts "Game saved. Exiting..."
    exit
  elsif @word.include?(guess)
    make_visible(guess)
  else
    @num_wrong += 1
    @guessed_wrong << guess unless @guessed_wrong.include?(guess)
    @guessed_wrong.uniq!
    @guessed_wrong.sort!
  end
end

def make_visible(guess)
  (0..@word.length-1).each do |index|
    if @word[index] == guess
      @display_word[index] = guess
    end
  end
end

def show_hangman(num_wrong)
  puts "(Hangman is shown below. Use your imagination!)\n"
  case num_wrong
  when 0
    puts "*EMPTY GALLOWS PIC*"
  when 1
    puts "*A HEAD*"
  when 2
    puts "*A HEAD AND BODY"
  when 3
    puts "*A HEAD AND BODY AND LEFT ARM*"
  when 4
    puts "*A HEAD AND BODY WITH TWO ARMS*"
  when 5
    puts "*A HEAD AND BODY, TWO ARMS, ONE LEG*"
  when 6
    puts "*A HEAD AND BODY, TWO ARMS, TWO LEGS*"
  when 7
    puts "*A HEAD AND BODY, TWO ARMS, TWO LEGS, A HAND*"
  when 8
    puts "*A HEAD AND BODY, TWO ARMS, TWO LEGS, TWO HANDS*"
  when 9
    puts "*A HEAD, A BODY, TWO ARMS WITH HANDS, TWO LEGS, A FOOT*"
  when 10
    puts "*AN ENTIRE BODY HANGING, FEET AND ALL*"
  else
    puts "Something clearly went wrong in this display method."
  end
end

end #class
end #module
include Hangman

g = Game.new
g.play
