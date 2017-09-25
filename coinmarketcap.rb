require "json"
require "faraday"
require "faraday_middleware"

class Coinmarketcap
  def self.fetch(order_by: "market_cap_usd")
    @_content ||= JSON.parse(Faraday.get("https://api.coinmarketcap.com/v1/ticker/").body)

    all_markets = @_content.dup
    all_markets = all_markets.sort_by do |market|
      market[order_by].to_f
    end.reverse

    all_markets = all_markets.collect do |market|
      market.merge({ "url" => "https://coinmarketcap.com/currencies/#{market['id']}" }) # because the URL isn't provided for some reason
    end

    return all_markets
  end

  def self.external_website(coin)
    # Coinmarketcap doesn't expose the URL :(
    # So back to HTML scraping
    connection = Faraday.new(coin["url"]) do |builder|
      builder.use FaradayMiddleware::FollowRedirects
      builder.adapter :net_http
    end
    html_content = connection.get.body
    matched = html_content.match(/<span.*title\=\"Website\"\>\<\/span\>.*\<a href\=\"([\w\-\_\.\:\/]+)\"/)
    if matched.length > 1
      return matched[1]
    else
      puts "Couldn't find website URL for coin #{coin['name']}: #{coin['url']}"
      return nil
    end
  end
end
