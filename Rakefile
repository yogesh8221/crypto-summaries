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

  Coinmarketcap.fetch.each do |current_coin|
    external_url = Coinmarketcap.external_website(current_coin)

    output_names = [current_coin["name"], current_coin["id"], current_coin["symbol"]]
    lenghts = [1, 3, 5]

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
  end
end
