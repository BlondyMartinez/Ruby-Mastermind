require_relative 'color'

class Game
  def initialize
    welcome
    instructions
    mode = choose_mode
    set_game_variables
    play(mode)
  end

  def play(game_mode)
    puts
    if game_mode === 'creator'
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
    
    4.times do |i|
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

    puts 'Your code: ' + guesser_code.join(' ')
    puts @feedback
  end

  def win?
    return unless @feedback.delete(' ') === double_correct.delete(' ') * 4

    puts
    puts "Congratulations! You've guessed the correct code!"
    puts @code.join(' ')
    puts

    @game_over = true
  end

  def lose
    puts
    puts "You didn't guess the code :c"
    puts 'The code: ' + @code.join(' ')
    puts 'Your guess: ' + @guesser_code.join(' ')
    puts

    @game_over = true
  end
end
