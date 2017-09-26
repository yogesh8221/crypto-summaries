require_relative "./coinmarketcap"
require 'aylien_text_api'
require 'fileutils'

task :generate do
  raise "API keys not found" if ENV["AYLIEN_APP_ID"].to_s.length == 0 || ENV["ALYIEN_APP_KEY"].to_s.length == 0
  client = AylienTextApi::Client.new(
    app_id: ENV["AYLIEN_APP_ID"],
    app_key: ENV["ALYIEN_APP_KEY"]
  )
  coins_dir = "coins"
  FileUtils.mkdir_p(coins_dir)
  all_coins = []
  lenghts = [1, 3, 5]
  missing_summaries = []

  Coinmarketcap.fetch.each_with_index do |current_coin, index|
    break if index > 50

    # Search on Wikipedia
    puts "accessing wikipedia for coin #{current_coin['name']}"
    query = "#{current_coin['name']}%20cryptocurrency%20#{current_coin['symbol']}"
    wikipedia_url = "https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=#{query}&utf8=&format=json"
    wiki_pages = JSON.parse(Faraday.get(wikipedia_url).body)
    first_result = wiki_pages["query"]["search"].first
    first_result = wiki_pages["query"]["search"][1] if wiki_pages["query"]["search"].count > 1 && first_result["title"] == "List of cryptocurrencies"

    if first_result
      content_url = "https://en.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&exintro=&titles=#{first_result['title']}"
      details = JSON.parse(Faraday.get(content_url).body)
      extract = details["query"]["pages"].values.first["extract"]
      extract = extract.gsub(/<[^>]*>/ui,'') # sanitze, but for poor people
    end

    output_names = [current_coin["name"], current_coin["id"], current_coin["symbol"]]
    external_url = nil

    lenghts.each do |number_of_sentences|
      local_manual_path = File.join("manual", "#{current_coin['symbol']}-#{number_of_sentences}.txt")
      if File.exist?(local_manual_path)
        puts "Using local, manual description of the coin for #{number_of_sentences} sentence(s)"
        output_names.each do |output_name|
          output_file = File.join(coins_dir, "#{output_name}-#{number_of_sentences}.txt")
          FileUtils.cp(local_manual_path, output_file)
        end
      else
        puts "getting #{number_of_sentences} sentence summary for #{current_coin['name']}"
        if extract.to_s.length > 5
          summary = extract.split(". ")[0..(number_of_sentences-1)].join(". ")
        else
          external_url ||= Coinmarketcap.external_website(current_coin)
          if external_url
            summary = client.summarize(url: external_url, sentences_number: number_of_sentences)[:sentences].join(" ") + "."
          end
          if summary.to_s.length < 10
            summary = "No summary found - feel free to contribute one on https://github.com/KrauseFx/crypto-summaries"
            missing_summaries << current_coin["symbol"]
          end
        end

        output_names.each do |output_name|
          output_file = File.join(coins_dir, "#{output_name}-#{number_of_sentences}.txt")
          File.write(output_file, summary)
        end
      end
    end

    all_coins << current_coin["symbol"]
  end

  # Create an index.html
  html_content = ["<h1>An API for short summary of key features of all crypto currency</h1>"]
  html_content << "<ul>"
  html_content += all_coins.collect do |current_symbol|
    "<li> #{current_symbol} (" + lenghts.collect do |number_of_sentences|
      link = File.join(coins_dir, "#{current_symbol}-#{number_of_sentences}.txt")
      "<a href='#{link}' target='_blank'>#{number_of_sentences}</a>"
    end.join(", ") + ")</li>"
  end
  html_content << "</ul>"
  html_content << "<h3><a href='https://github.com/KrauseFx/crypto-summaries/'>Pull Requests welcome</a><h3>"
  html_content << "<h5>Webdesign and development by <a href='https://krausefx.com'>Felix Krause</a><h5>"
  puts html_content
  File.write("index.html", html_content.join("\n"))
  File.write("missing_summaries.txt", missing_summaries.uniq.join("\n"))
end
