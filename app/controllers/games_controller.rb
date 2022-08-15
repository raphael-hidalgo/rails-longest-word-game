require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = []
    @start_time = Time.now()
    10.times { @letters << ('A'..'Z').to_a.sample }
    @letters
  end

  def word_ok(letters, word)
    word.chars.all? { |i| word.count(i) <= letters.count(i) }
  end

  def score
    @end_time = Time.now().to_datetime
    @word = params[:word].downcase()
    @grid = JSON.parse(params[:letters]).map{|i| i.downcase()}
    @start_time = params[:start].to_datetime
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    api_answer = JSON.parse(URI.open(url).read)
    seconds = ((@end_time - @start_time).to_f * 60000).round()
    if word_ok(@grid, @word) == false
      @result = { time: "#{seconds} seconds", score: 0, message: 'not in the grid' }
    else
      @result = { score: (api_answer['found'] == true ? api_answer['length'].fdiv(seconds) : 0),
                message: (api_answer['found'] == true ? 'Well done!' : 'Not an english word'),
                time: "#{seconds} seconds" }
    end
  end
end
