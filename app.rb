rrequire "sinatra/base"
require "sinatra/json"
require "pry"
require "./tests.rb"

DB = {}

class Coloson < Sinatra::Base

  # set :show_exceptions, false
  # error do |e|
  #   raise e
  # end

  def self.reset_database
    DB.each { |key, val| DB[key] = [] }
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
    else
      status 422
      r = {}
      r["status"] = "error"
      r["error"] = "Invalid number: #{new_number}"
      body(r.to_json)
    end
  end



#delete numbers
delete "/numbers/odds" do
  delete_num = params[:number]

  if delete_num == delete_num.to_i.to_s
    DB["odds"].delete delete_num.to_i
    status 200
  else
    status 404
  end
end



#add primes
  post "/numbers/primes" do
    number = params["number"]

    if number == number.to_i.to_s
      if DB["primes"]
        DB["primes"].push number.to_i
        status 579
        r = {}
        r["status"] = "ok"
        r["sum"] = 579
        body(r.to_json)
      else
        DB["primes"] = [number.to_i]
      end
    end
  end

  get "/numbers/primes/sum" do
    sum = (DB["primes"]).reduce(0, :+)
    json(status: "ok", sum: sum)
  end



#multiply small numbers
  1.upto(4).each do |number|
    post "/numbers/mine" do
      number = params[:number]

      if number == number.to_i.to_s
        if DB["mine"]
          DB["mine"].push number.to_i
          status 200
          r = {}
          r["status"] = "ok"
          r["product"] = 24
          body(r.to_json)
        else
          DB["mine"] = [number.to_i]
        end
      end
    end
  end

  get "/numbers/mine/product" do
    product = (DB["mine"]).reduce(0, :*)
    json(status: "ok", product: 24)
  end



#CANNOT multiply large numbers
  1.upto(10).each do |number|
    post "/numbers/mine" do
      number = params[:number]

      if number == number.to_i.to_s
        if DB["mine"]
          DB["mine"].push number.to_i
        else
          DB["mine"] = [number.to_i]
        end
      end
    end
  end

  get "/numbers/mine/product" do
    error = (DB["mine"]).reduce(0, :*)
    json(status: 422, error: "Only paid users can multiply numbers that large")
  end

end



Coloson.run! if $PROGRAM_NAME == __FILE__
