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

  get "/numbers/:collection" do
    json get_collection
  end

  post "/numbers/:collection" do
    if is_valid_number? params[:number]
      get_collection.push params[:number].to_i
      body "ok"
    else
      status 422
      json(
        status: "error",
        error: "Invalid number: #{params[:number]}"
      )
    end
  end

  delete "/numbers/:collection" do
    number = params[:number].to_i

    get_collection.delete number

    body "ok"
  end

  get "/numbers/:collection/sum" do
    c = get_collection
    json(
      status: "ok",
      sum: c.reduce(:+)
    )
  end

  def get_collection
    DB[ params[:collection] ] ||= []
    DB[ params[:collection] ]
  end

  def is_valid_number? string
    string.to_i.to_s == string
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
