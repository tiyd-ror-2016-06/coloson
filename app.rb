require "sinatra/base"
require "sinatra/json"
require "pry"

DB = {}

class Coloson < Sinatra::Base
  def self.reset_database
    DB.clear
  end
end

Coloson.run! if $PROGRAM_NAME == __FILE__
