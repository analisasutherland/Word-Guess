# Class to print out owl ASCII art for the game.
# Could potentially be used to change difficulty level of game by limiting initial number of guesses
class Owl
  def initialize(initial_zz)
    @initial_zz = initial_zz
  end

  attr_reader :initial_zz

  def sleepy_owl
    puts " {~;~}"
    puts " /)__)"
    puts "/  ;;"
  end

  def zzzz(wrong_guesses)
    string = "\n     "
    (@initial_zz - wrong_guesses).times do
      string += "Z "
    end
    puts string
  end

  def awake_owl
    puts " {O;O}"
    puts " /)__)"
    puts "/  ;;"
  end

  def winning
    puts "\n     HOOOOO-RAY!"
    puts " {^;^}"
    puts " /)__)"
    puts "/  ;;"
  end
end
# Allows user to guess letters, validates their input and prompts again if not valid,
# stores letters already guessed, and increments the number of wrong guesses,
# generates blank letter spaces, and fills in the blanks as game progresses.
class Game
  def initialize (word)
    @finished_word = word
    @letters = word.upcase.chars
    @wrong_guesses = 0
    @guessed_letters = []
    @word_array =@letters.length.times.collect {|x| "_"}
  end

  attr_reader :letters, :finished_word, :guessed_letters, :wrong_guesses, :word_array

  def guess_letter
    print "Please guess a letter: "
    guess = gets.chomp.upcase
    while @guessed_letters.include?(guess)
      print "You already guessed that letter. Guess again: "
      guess = gets.chomp.upcase
    end
    # only lets the user guess A through Z
    guess_req = /[A-Z]/
    # this is making sure that the user guess does not meet our regex requirements or more then one was put in
    while !guess_req.match(guess) || guess.length > 1
      print "That is not a correct input. Please guess a letter: "
      guess = gets.chomp.upcase
    end

    if @letters.include?(guess)
      @guessed_letters << guess
      fill_in(guess)
      return "That is a correct guess."
    else
      @guessed_letters << guess
      @wrong_guesses += 1
      return "That is a wrong guess."
    end
  end

  def fill_in(guess)
    @letters.each_with_index do |letter, i|
      if letter == guess
        @word_array[i] = guess
      end
    end
    return @word_array
  end

  def print_word_array
    printing_word = ""
    @word_array.each do |letter|
      printing_word += "#{letter} "
    end
    return printing_word
  end

  def what_was_guessed
    user_guesses = ""
    @guessed_letters.each do |letter|
      user_guesses += letter + " "
    end
    return user_guesses
  end
end

# generates random word for user to guess
def word_generator
  word_options = ["BAZAAR", "BROOD", "EYRIE", "HOOTING", "LOOMING", "NEST", "STOOPING", "BROOD", "DISS", "PAIR", "PARLIAMENT", "SAGACIOUSNESS", "STARE", "WISDOM", "STABLE", "PROHIBITION", "VOLERY", "BLIZZARD"]
  return word_options.sample
end

# prompts user at completion of game if they would like to intiate a new game
def new_game
  print "\nDo you want to guess another word? Y/N: "
  answer = gets.chomp.upcase
  if answer == "Y"
    replay = true
  else
    puts "Thanks for playing with us."
    exit
  end
end

# user interface:
# continues to prompt user to guess letters until the game is won or lost
# game is won if guessed letters complete the randomly selected word
# game is lost if number of guesses exceeds the number of intial zz's
# prints ASCII art to represent the number of wrong guesses
# changes ASCII art if user wins or loses
replay = true
while replay
  otis = Owl.new(5)
  our_word = Game.new(word_generator)

  puts "Lets play a guessing game, but shhhh Otis is sleeping.\nHe doesn't like to be woken, and wrong guesses tend to disturb him."

  until our_word.wrong_guesses == otis.initial_zz || our_word.word_array.join == our_word.finished_word
    otis.zzzz(our_word.wrong_guesses)
    otis.sleepy_owl
    puts our_word.print_word_array
    if !our_word.guessed_letters.empty?
      puts "\nYou have guessed these letters: #{our_word.what_was_guessed}"
    end
    puts our_word.guess_letter
  end
  if our_word.wrong_guesses == otis.initial_zz
    puts "\nOH NO! The word was #{our_word.finished_word}."
    otis.awake_owl
    puts "You woke up Otis!\nHe is nocturnal damnit.\nHe needs sleep.\n"
    new_game
  else
    puts "\nYou won! You must truly understand how important Owls are to our ecosystems."
    otis.winning
    new_game
  end
end
