require "yaml"

module Hangman
class Game

def initialize
  @word = ""
  @display_word = ""
  @guessed_wrong = []
  @num_wrong = 0
end

def set_word
  word_list = File.open("5desk.txt").readlines
  until @word.length >= 5 && @word.length <= 12
    @word = word_list.sample.chomp.upcase
  end
  @display_word = "_" * @word.length
end


def play
  print "Do you want to load a game (Y/N): "
  load = gets.chomp.upcase
  load_game if load == "Y"

  set_word

  until lost? || victorious?
    puts "\n*************************************"
    show_hangman(@num_wrong)
    show_letters
    print "Guess a letter, or enter the & character to save game: "
    guess = gets[0].upcase
    if guess == "&"
      save_game
      exit
    end
    check_guess(guess)
  end

  if lost?
    puts "The hangman has been hung. You lose."
    puts "The word was #{@word}, by the way."
  elsif victorious?
    puts "Victory! It WAS the word '#{@word}.'"
  end

end

def save_game
  save_object("game.sv", self)
end

def save_object (filename, object)
  File.open(filename, 'w') {|f| f.write(YAML::dump(object))}
end

def load_game
  YAML::load(File.read("game.sv"))
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
  if @word.include?(guess)
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
  puts "(Hangman is shown below)\n"
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
