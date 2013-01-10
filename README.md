# Scottrade

Very basic gem for accessing Scottrade account information including balances and market positions. 

**This software comes with no warranty and you use it at your own risk.**


## Installation

Add this line to your application's Gemfile:

    gem 'scottrade'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scottrade

## Usage

To run the tests or example, set the environment key `SCOTTRADE_ACCOUNT` and `SCOTTRADE_PASSWORD` with your account information.

Basic usage is:

	scottrade = Scottrade::Scottrade.new(`ACCOUNT_NUMBER`,`PASSWORD`)
	scottrade.authenticate
	scottrade.brokerage.update_accounts
	scottrade.brokerage.update_positions
	
	puts scottrade.brokerage.accountBalance
	


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
