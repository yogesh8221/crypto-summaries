# Crypto Summaries

If you automate crypto currency trading, and send out reports, you might want a summary of what a coin does, is it a coin that for advertising? Gaming? Paying coffee? 

This project tries to provide the simpliest possible API to get a summary of a coin. Ideally this would be integrated in [coinmarketcap](https://coinmarketcap.com), but unfortunately that's not the case right now.

Check out [krausefx.github.io/crypto-summaries](https://krausefx.github.io/crypto-summaries/) for a list of the available summaries.

## How to use the API

### Access the summary of Bitcoin:

- **1 line summary**: [https://krausefx.github.io/crypto-summaries/coins/BTC-1.txt](https://krausefx.github.io/crypto-summaries/coins/BTC-1.txt)
- **3 lines summary**: [https://krausefx.github.io/crypto-summaries/coins/BTC-3.txt](https://krausefx.github.io/crypto-summaries/coins/BTC-3.txt)
- **5 lines summary**: [https://krausefx.github.io/crypto-summaries/coins/BTC-5.txt](https://krausefx.github.io/crypto-summaries/coins/BTC-5.txt)

Alternatively you can also use the name of the coin instead of `symbol`

- **3 lines summary**: [https://krausefx.github.io/crypto-summaries/coins/Bitcoin-3.txt](https://krausefx.github.io/crypto-summaries/coins/Bitcoin-3.txt)

### Access the summary of Ethereum

Same thing, e.g. 

- [https://krausefx.github.io/crypto-summaries/coins/ETH-5.txt](https://krausefx.github.io/crypto-summaries/coins/ETH-5.txt)
- [https://krausefx.github.io/crypto-summaries/coins/Ethereum-1.txt](https://krausefx.github.io/crypto-summaries/coins/Ethereum-1.txt)

## How does it work?

The data comes from different sources

- Manually provided (see section below)
- Abstract from Wikipedia, the first `x` sentences
- A summary of the website that's linked on [coinmarketcap](https://coinmarketcap.com), summarized via [aylien.com](https://aylien.com/).

Notice the [LICENSE](LICENSE) file - you have to check the permission from Wikipedia to be sure you're allowed to use the abstract.

## How can I overwrite the automatically determined summary?

Check out the [./manual](./manual) directory, you can use the official `symbol` with the number of sentences (`[symbol]-[sentences].txt`) and store the summary in there. Next time the script runs, it will be applied to all the public facing `.txt` files.

If you want to help, check out [./missing_summaries.txt](./missing_summaries.txt) for the currencies for which there is no summary available at all.

## Re-generate the files

- Make sure to run `bundle install` to install all dependencies
- Make sure to have provided the summary API keys `AYLIEN_APP_ID` and `ALYIEN_APP_KEY`
- Run `bundle exec rake generate`
- Commit & push the changes
