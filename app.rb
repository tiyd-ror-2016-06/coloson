require "sinatra/base"
require "sinatra/json"
require "pry"
require "json"

DB = {}

class Coloson < Sinatra::Base
  set :logging, true
  set :show_exceptions, false

  error do |e|
    raise e
  end

  def self.reset_database
    DB.clear
  end

  get "/numbers/evens" do
    # unless DB["evens"]
    #   DB["evens"] = []
    # end
    DB["evens"] ||= []

    body DB["evens"].to_json
  end

  post "/numbers/evens" do
    number = params[:number].to_i

    DB["evens"].push number

    body "ok"
  end
end

Coloson.run! if $PROGRAM_NAME == __FILE__
