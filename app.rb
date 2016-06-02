require "sinatra/base"
require "sinatra/json"
require "pry"

DB = {}

class Coloson < Sinatra::Base
  set :show_exceptions, false
  error do |e|
    raise e
  end

  def self.reset_database
    DB.clear
  end
end

Coloson.run! if $PROGRAM_NAME == __FILE__
