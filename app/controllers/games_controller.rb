require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('a'..'z').to_a[rand(26)] }
  end

  def score
    @answer = params['answer']
    @letters = params['letters']
    url = "https://wagon-dictionary.herokuapp.com/#{@answer}"

    json = URI.open(url).read
    @correct = JSON.parse(json)['found']
    @count_answer = Hash.new(0)
    @count_letters = Hash.new(0)

    @answer.chars.each do |letter|
      if @count_answer.key?(letter)
        @count_answer[letter] += 1
      else
        @count_answer[letter] = 1
      end
    end

    @letters.split(' ').each do |letter|
      if @count_letters.key?(letter)
        @count_letters[letter] += 1
      else
        @count_letters[letter] = 1
      end
    end

    @matches =
      @answer.chars.all? do |letter|
        @count_answer[letter] <= @count_letters[letter]
      end

    @results =
      if @correct && @matches
        "Congratulations! #{@answer.upcase} is a valid English word! Score: #{@answer.length**2}"
      elsif @correct && !@matches
        "Sorry, but #{@answer.upcase} can't be built out of #{@letters}"
      else
        "Sorry, but #{@answer.upcase} does not seem to be a valid English word..."
      end
  end
end
