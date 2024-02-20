require_relative 'color'

class Game
  def initialize
    welcome
    instructions
    @mode = choose_mode
    set_game_variables
    play
  end

  def play
    puts
    if @mode === 'creator'
      creator_mode
    else
      guesser_mode
    end

    initialize if @game_over
  end

  def welcome
    puts 'Welcome to Mastermind!'
    puts 'This is a game about code-breaking for two players, in this case: you and the computer'
    puts
  end

  def instructions
    puts 'There are two game modes:'
    puts 'Creator: in this mode you choose the colors and order of the balls.'
    puts 'Guesser: the computer creates the code for you, and you guess.'
    puts 'In both moves, the guesser has 12 attempts and gets some feedback: a white ' + '○'.white + ' for correct color and a green ' + '○'.green + ' for correct color and position.'
    puts
  end

  def choose_mode
    puts 'Now, please choose a mode to play:'
    puts "Type either 'creator' or 'guesser'."
    validate_mode_input(gets.chomp)
  end

  def validate_mode_input(str)
    unless str.downcase === 'creator' || str.downcase === 'guesser'
      puts "The mode you've chosen isn't valid. Choose again."
      str = gets.chomp
    end
    str
  end

  def set_game_variables
    @attempts = 0
    @game_over = false
  end

  def creator_mode
    puts 'Please, type the color of the balls in order. For example, for: ' +
         '● '.blue + '● '.white + '● '.cyan + '●'.magenta + ". You'd do: type blue, press enter, type white, press enter, type cyan, press enter."

    create_code
    computer_guess
  end

  def guesser_mode
    generate_code
    until @game_over
      puts
      puts 'Type your guess. Remember your choices are: ' + 'red,'.red + ' green,'.green + ' yellow,'.yellow + ' blue,'.blue + ' magenta,'.magenta + ' cyan,'.cyan + ' white,'.white + ' and ' + 'pink'.pink + '.'

      @guesser_code = [validate_color_input(gets.chomp), validate_color_input(gets.chomp),
                       validate_color_input(gets.chomp), validate_color_input(gets.chomp)]

      compare_codes
      win?

      @attempts += 1
      lose if @attempts == 12
    end
  end

  # creator_mode stuff below

  def create_code
    @code = []

    4.times do |_i|
      color = validate_color_input(gets.chomp)
      while @code.include?(color)
        puts "You can't repeat colors. Please choose again."
        color = validate_color_input(gets.chomp)
      end
      @code << color
    end

    @code.each_with_index do |color, index|
      @code[index] = '●'.send(color)
    end

    puts 'Your code is: ' + @code.join(' ')
  end

  def computer_guess
    possible_solutions = generate_all_possible_codes
    attempt = 0

    until attempt == 12
      attempt += 1
      puts
      puts "Attempt #{attempt}:"
      @guesser_code = generate_computer_guess(possible_solutions)

      compare_codes
      break if win?

      possible_solutions = update_possible_solutions(possible_solutions, @guesser_code)
    end
    lose
  end

  def generate_computer_guess(possible_solutions)
    possible_solutions.sample
  end

  def update_possible_solutions(possible_solutions, guess)
    possible_solutions.select do |code|
      compare_codes_for_update(guess, code).strip == @feedback
    end
  end

  def compare_codes_for_update(_guess, code)
    @feedback = ''
    @guesser_code.each_with_index do |color, index|
      ball = '●'.send(color)
      next unless code.include?(ball)

      @feedback += if ball == code[index]
                     double_correct + ' '
                   else
                     correct + ' '
                   end
    end
    @feedback
  end

  def generate_all_possible_codes
    COLOR_CHOICES.repeated_permutation(4).to_a
  end

  # guesser_mode stuff below

  def generate_code
    @code = []
    set_of_balls = Set.new

    while @code.length < 4
      color_ball = random_color_ball
      unless set_of_balls.include?(color_ball)
        @code << color_ball
        set_of_balls.add(color_ball)
      end
    end

    puts 'A code has been generated, it does not have duplicates.'
  end

  def random_color_ball
    index = rand(1...8)
    ball = ''

    case index
    when 1
      return '●'.red
    when 2
      return '●'.green
    when 3
      return '●'.yellow
    when 4
      return '●'.blue
    when 5
      return '●'.magenta
    when 6
      return '●'.cyan
    when 7
      return '●'.white
    when 8
      return '●'.pink
    end

    ball
  end

  COLOR_CHOICES = %w[red green yellow blue magenta cyan white pink]

  # game stuff below

  def validate_color_input(input)
    unless COLOR_CHOICES.include?(input.downcase)
      puts 'Enter a valid color.'
      input = gets.chomp
    end

    input
  end

  def double_correct
    '○'.green
  end

  def correct
    '○'.white
  end

  def compare_codes
    puts
    guesser_code = []
    @feedback = ''

    @guesser_code.each_with_index do |color, index|
      ball = '●'.send(color)
      guesser_code << ball

      next unless @code.include?(ball)

      @feedback += if ball == @code[index]
                     double_correct + ' '
                   else
                     correct + ' '
                   end
    end

    puts 'Your code: ' + guesser_code.join(' ') if @mode == 'guesser'
    puts "Computer's code: " + guesser_code.join(' ') if @mode == 'creator'
    puts @feedback
  end

  def win?
    return unless @feedback.delete(' ') === double_correct.delete(' ') * 4

    puts
    puts "Congratulations! You've guessed the correct code!" if @mode == 'guesser'
    puts 'The computer has guessed your code!' if @mode == 'creator'
    puts @code.join(' ')
    puts

    @game_over = true
  end

  def lose
    puts
    if @mode == 'guesser'
      puts "You didn't guess the code :c"
      puts 'The code: ' + @code.join(' ')
      puts 'Your guess: ' + @guesser_code.join(' ')
    else
      @guesser_code.each_with_index do |color, index|
        @guesser_code[index] = '●'.send(color)
      end
      puts "The computer didn't guess your code :c"
      puts 'Your code: ' + @code.join(' ')
      puts "Computer's code: " + @guesser_code.join(' ')
    end
    puts

    @game_over = true
  end
end
