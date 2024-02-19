class Game
  def initialize
    welcome
    instructions
    choose_mode(validate_mode_input(gets.chomp))
  end

  def play
  end
  
  def welcome
    puts "Welcome to Mastermind!"
  end

  def instructions
  end

  def choose_mode(mode)
  end

  def validate_mode_input(str)
    unless str.downcase === "creator" || str.downcase === 'guesser'
      puts "The mode you've chosen isn't valid. Choose again."
      str = gets.chomp
    end
    str
  end

  def creator_mode
  end

  def guesser_mode
  end
end