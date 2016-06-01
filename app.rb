require "sinatra/base"
require "sinatra/json"
require "pry"
require "./tests.rb"

DB = {}

class Coloson < Sinatra::Base

  set :show_exceptions, false
  error do |e|
    raise e
  end

  def self.reset_database
    DB.clear
  end


#view evens
get "/numbers/evens" do
  unless DB["evens"]
    DB["evens"] = []
  end
  json DB["evens"]
end


#add evens
post "/numbers/evens" do
  new_number = params["number"]

    if new_number == new_number.to_i.to_s
      DB["evens"].push new_number.to_i
      200
    end
  end


#view odds
  get "/numbers/odds" do
    unless DB["odds"]
      DB["odds"] = []
    end
    json DB["odds"]
  end


#add odds
  post "/numbers/odds" do
    new_number = params["number"]

      if new_number == new_number.to_i.to_s
        if DB["odds"]
          DB["odds"].push new_number.to_i
          200
        else
          DB["odds"] = [new_number.to_i]
        end
      end
    end


#delete numbers
  delete "/numbers/odds" do
      number.to_i = params[:number]
      existing_item = DB.find { |i| i["number"] == number.to_i }
      if existing_item
        DB.delete existing_item
        status 200
      else
        status 404
      end
    end










end






Coloson.run! if $PROGRAM_NAME == __FILE__
