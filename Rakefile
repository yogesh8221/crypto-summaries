require_relative "./coinmarketcap"
require 'aylien_text_api'
require 'fileutils'

task :generate do
  client = AylienTextApi::Client.new(
    app_id: ENV["AYLIEN_APP_ID"],
    app_key: ENV["ALYIEN_APP_KEY"]
  )
  coins_dir = "coins"
  FileUtils.mkdir_p(coins_dir)
  all_coins = []
  lenghts = [1, 3, 5]

  Coinmarketcap.fetch.each do |current_coin|
    external_url = Coinmarketcap.external_website(current_coin)

    output_names = [current_coin["name"], current_coin["id"], current_coin["symbol"]]

    lenghts.each do |number_of_sentences|
      local_manual_path = File.join("manual", "#{current_coin['symbol']}-#{number_of_sentences}.txt")
      if File.exist?(local_manual_path)
        puts "Using local, manual description of the coin for #{number_of_sentences} sentence(s)"
        output_names.each do |output_name|
          output_file = File.join(coins_dir, "#{output_name}-#{number_of_sentences}.txt")
          FileUtils.cp(local_manual_path, output_file)
        end
      else
        puts "getting #{number_of_sentences} sentence summary for #{current_coin['name']} (#{external_url})"
        summary = client.summarize(url: external_url, sentences_number: number_of_sentences)
        output_names.each do |output_name|
          output_file = File.join(coins_dir, "#{output_name}-#{number_of_sentences}.txt")
          File.write(output_file, summary[:sentences].join(" "))
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
  File.write("index.html", html_content.join("\n"))
end
