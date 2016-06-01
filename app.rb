require "sinatra/base"
require "sinatra/json"
require "pry"
require "json"

DB = {
  "evens" => [],
  "odds" => [],
  "primes" => [],
  "mine" => []
}

class Coloson < Sinatra::Base


  # set :show_exceptions, false
  # error do |e|
  #   raise e
  # end

  def self.reset_database
    DB.clear
    DB["evens"] = []
    DB["odds"] = []
    DB["primes"] = []
    DB["mine"] = []
  end





  get "/numbers/evens" do
    json DB["evens"]
  end

  get "/numbers/odds" do
    json DB["odds"]
  end

  get "/numbers/primes/sum" do
    sum = DB["primes"].reduce(:+)

    {"status" => "ok", "sum" => sum}.to_json

  end

  get "/numbers/mine/product" do
    product = DB["mine"].inject(1) do | product, number|
      product * number
    end

    if product < 1000
      body({ "status" => "ok", "product" => product }.to_json)
    else
      body({ "status" => "error", "error" => "Only paid users can multiply numbers that large"}.to_json)
      status 422
    end
    #binding.pry
  end



  post "/numbers/evens" do
    number = params[:number]
    if number == number.to_i.to_s
      DB["evens"].push number.to_i
      json
    else
      status 422
      body({"status" => "error", "error" => "Invalid number: #{number}"}.to_json)
    end
  end

  post "/numbers/odds" do
    number = params[:number]
    if number == number.to_i.to_s
      DB["odds"].push number.to_i
      json
    else
      status 422
      body({"status" => "error", "error" => "Invalid number: #{number}"}.to_json)
    end
  end

  post "/numbers/primes" do
    number = params[:number]
    if number == number.to_i.to_s
      DB["primes"].push number.to_i
      json
    else
      status 422
      body({"status" => "error", "error" => "Invalid number: #{number}"}.to_json)
    end
  end

  post "/numbers/mine" do
    number = params[:number]
    if number == number.to_i.to_s
      DB["mine"].push number.to_i
      json
    else
      status 422
      body({"status" => "error", "error" => "Invalid number: #{number}"}.to_json)
    end
  end


  delete "/numbers/odds" do
    number = params[:number]
    existing_number = DB["odds"].find { |i| i == number.to_i }
    DB["odds"].delete existing_number
    body(json DB["odds"])
    #binding.pry
  end

end

Coloson.run! if $PROGRAM_NAME == __FILE__
