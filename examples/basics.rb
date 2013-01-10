
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)


require 'scottrade'

scottrade = Scottrade::Scottrade.new(ENV["SCOTTRADE_ACCOUNT"],ENV["SCOTTRADE_PASSWORD"])
begin
  scottrade.authenticate
rescue StandardError => e
  puts e
  exit 1
end

begin
  scottrade.brokerage.update_accounts
  scottrade.brokerage.update_positions
  
rescue StandardError => e
  puts e
  exit 1
end


scottrade.brokerage.instance_variables.each{|variable|
  print "#{variable} : "; $stdout.flush
  puts scottrade.brokerage.instance_variable_get(variable)
}
print "\n------------------------------------\n"

scottrade.brokerage.accounts.each{|account|
  account.instance_variables.each{|variable|
    print "#{variable} : "; $stdout.flush
    puts account.instance_variable_get(variable)
  }
  print "\n***************\n"
}

scottrade.brokerage.positions.each{|position|
  position.instance_variables.each{|variable|
    print "#{variable} : "; $stdout.flush
    puts position.instance_variable_get(variable)
  }
  print "\n***************\n"
}
