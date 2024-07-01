class GamesController < ApplicationController
  require 'open-uri'
  require 'json'

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    start_time = Time.now
    @word = params[:word].upcase
    @letters = params[:letters].split
    end_time = Time.now
    @time_taken = end_time - start_time
    @message, @score = calculate_score(@word, @letters, @time_taken)
    session[:total_score] ||= 0
    session[:total_score] += @score
    @total_score = session[:total_score]
  end

  private

  def calculate_score(word, letters, time_taken)
    if valid_word?(word, letters)
      score = word.length / time_taken
      message = "Congratulations! #{word} is a valid English word ! "
    else
      score = 0
      message = "Sorry but #{word} does not seem to be a valid English word..."
    end
    [message, score]
  end

  def valid_word?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) } && english_word?(word)
  end

  def english_word?(word)
    url = "https://dictionary.lewagon.com/#{word}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json['found']
  end
end
