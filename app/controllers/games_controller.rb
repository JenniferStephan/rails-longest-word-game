require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ("A".."Z").to_a.sample }
  end

  def score
    @letters = params[:letters]
    @word = params[:userword]
    if included?(@word.upcase, @letters)
      if english_word?(@word)
      @score = @word.size
      @text = "well done"
      else
      @score = 0
      @text = "not an english word"
      end
    else
      @score = 0
      @text = "not in the grid"
    end
  end

private

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def included?(userword, letters)
    userword.chars.all? { |letter| userword.count(letter) <= letters.count(letter) }
  end
end
