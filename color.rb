class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  %w[red green yellow blue magenta cyan white pink].each do |color|
    define_method(color) do
      colorize(COLOR_CODES[color.to_sym])
    end
  end

  # Define color codes for each color
  COLOR_CODES = {
    red: 31,
    green: 32,
    yellow: 33,
    blue: 34,
    magenta: 35,
    cyan: 36,
    white: 37,
    pink: 95
  }

  def color_name
    color_code = self.color_code
    color_code ? COLOR_CODES.key(color_code) : nil
  end
end
