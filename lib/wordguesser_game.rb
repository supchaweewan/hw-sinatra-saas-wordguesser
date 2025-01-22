class WordGuesserGame
  # first, make all the getters and setters
  attr_accessor :word, :guesses, :wrong_guesses

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

# ==================================================================
# ==================================================================
  def guess(letter)
    # check for valid input
    # raise ArgumentError if letter is nil, empty, or not a letter
    if letter == nil || letter == '' || letter =~ /[^a-zA-Z]/
      raise ArgumentError
    end
    # set letter to lowercase
    letter.downcase!
    # check if letter has already been guessed
    if @guesses.include?(letter) || @wrong_guesses.include?(letter)
      return false
    end
    # check if letter is in word
    if @word.include?(letter)
      @guesses += letter
    else
      @wrong_guesses += letter
    end
    return true
  end
# ==================================================================
  def word_with_guesses
    # return word with guessed letters filled in
    # if no letters guessed, return all dashes
    if @guesses == ''
      return '-' * @word.length
    end
    # replace dashes with guessed letters
    @word.gsub(/[^#{@guesses}]/, '-')
  end
# ==================================================================
  def check_win_or_lose
    # return :win, :lose, or :play depending on game state
    # if all letters guessed, return :win
    if word_with_guesses == @word
      return :win
    # if 7 or more wrong guesses, return :lose
    elsif @wrong_guesses.length >= 7
      return :lose
    else
      return :play
    end
  end

end