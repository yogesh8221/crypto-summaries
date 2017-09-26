require_relative "./coinmarketcap"
require 'fileutils'

task :generate do
  coins_dir = "coins"
  FileUtils.mkdir_p(coins_dir)
  all_coins = []
  lenghts = [1, 3, 5]
  missing_summaries = []

  Coinmarketcap.fetch.each_with_index do |current_coin, index|
    next if index > 100
    output_names = [current_coin["name"], current_coin["id"], current_coin["symbol"]]

    lenghts.each do |number_of_sentences|
      local_manual_path = File.join("manual", "#{current_coin['symbol']}-#{number_of_sentences}.txt")

      if File.exist?(local_manual_path)
        puts "Using local, manual description of the coin #{current_coin['symbol']} for #{number_of_sentences} sentence(s)"
        output_names.each do |output_name|
          output_file = File.join(coins_dir, "#{output_name}-#{number_of_sentences}.txt".gsub("/", "-"))
          FileUtils.cp(local_manual_path, output_file)
        end
        all_coins << current_coin["symbol"]
      else
        missing_summaries << current_coin["symbol"]
        output_names.each do |output_name|
          output_file = File.join(coins_dir, "#{output_name}-#{number_of_sentences}.txt".gsub("/", "-"))
          File.write(output_file, "No summary found - feel free to contribute one on https://github.com/KrauseFx/crypto-summaries")
        end
      end
    end

  end

  # Create an index.html
  html_content = ["<h1>An API for short summary of key features of all crypto currency</h1>"]
  html_content << "<ul>"
  html_content += all_coins.uniq.collect do |current_symbol|
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
