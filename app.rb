require "sinatra"
require "sinatra/reloader"
require "dotenv/load"
require "http"
require "json"

key = ENV.fetch("KEY")

get("/") do
  
  list_url = "https://api.exchangerate.host/list?access_key=#{key}"
  list_raw = HTTP.get(list_url).to_s
  list_json = JSON.parse(list_raw)
  @currencies = list_json.fetch("currencies").keys

  erb(:homepage)

end

get("/:first_currency") do

  list_url = "https://api.exchangerate.host/list?access_key=#{key}"
  list_raw = HTTP.get(list_url).to_s
  list_json = JSON.parse(list_raw)
  @currencies = list_json.fetch("currencies").keys
  @first_currency = params.fetch("first_currency")
  
  erb(:first_currency)

end

get("/:first_currency/:second_currency") do

  @first_currency = params.fetch("first_currency")
  @second_currency = params.fetch("second_currency")
  conversion_url = "https://api.exchangerate.host/live?access_key=#{key}&source=#{@first_currency}&currencies=#{@second_currency}"
  conversion_raw = HTTP.get(conversion_url).to_s
  conversion_json = JSON.parse(conversion_raw)
  @conversion_rate = conversion_json.fetch("quotes").fetch("#{@first_currency}#{@second_currency}")
  
  erb(:second_currency)

end
