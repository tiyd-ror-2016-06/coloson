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

  get "/numbers/:collection" do
    DB[ params[:collection] ] ||= []

    body DB[ params[:collection] ].to_json
  end

  post "/numbers/:collection" do
    number = params[:number].to_i

    DB[ params[:collection] ] ||= []
    DB[ params[:collection] ].push number

    body "ok"
  end

  delete "/numbers/:collection" do
    number = params[:number].to_i

    DB[ params[:collection] ].delete number

    body "ok"
  end
end

Coloson.run! if $PROGRAM_NAME == __FILE__
