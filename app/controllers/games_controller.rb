require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = (1..10).map do
      ('A'..'Z').to_a.sample
    end
  end

  def word_check(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    unique_words = open(url).read
    word_check = JSON.parse(unique_words)
    word_check['found'] == true
  end

  def check_grid(attempt, grid)
    result_array = []
    attempt_array = attempt.upcase.split('')
    attempt_array.each do |character|
      result_array << grid.include?(character)
      index = grid.find_index(character)
      grid.delete_at(index.to_i)
    end
    result_array.exclude?(false)
  end

  def score
    @result_array = []
    @letters = params[:letters].upcase.split('')
    @word = params[:attempt]
    @is_word = word_check(@word)
    @result = ''
    if @is_word == false || check_grid(@word, @letters) == false
      @result = 'That is invalid'
    else
      @result = @word.length * 10
    end
  end
end

