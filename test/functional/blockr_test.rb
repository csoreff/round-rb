require_relative "setup"

require "bitvault/blockchain/blockr"

describe "Blockr.io interface" do

  def blockr
    BitVault::Blockchain::Blockr.new "test"
  end

  it "can query unspent outputs" do
    result = blockr.unspent %w[
      n4rYhkv1LgtbXaXuFNCgG1hATJJTSec8F5
      n4rYhdx8CGo5fSVGh3jpfPhdHvJu6U7EQo
      n4rYdFbkiLSTdQ3uWsG7C46nikJmHjvhuV
    ]
    puts JSON.pretty_generate(result)
  end


  # Test Blocker#balance
  it "can query balance by address list" do

    balances = blockr.balance %w[
      n4rYhkv1LgtbXaXuFNCgG1hATJJTSec8F5
      n4rYhdx8CGo5fSVGh3jpfPhdHvJu6U7EQo
      n4rYdFbkiLSTdQ3uWsG7C46nikJmHjvhuV
    ]

    puts JSON.pretty_generate(balances)
  end


  # Test Blocker#balance
  it "can query with a one-element address list" do

    balance = blockr.balance [ "n4rYhdx8CGo5fSVGh3jpfPhdHvJu6U7EQo" ]
    puts JSON.pretty_generate(balance)
  end


  # Test Blocker#balance
  it "can query balance by single address" do

    balance = blockr.balance "n4rYhdx8CGo5fSVGh3jpfPhdHvJu6U7EQo"
    puts JSON.pretty_generate(balance)
  end


  # Test Blocker#transactions
  it "can query transaction info" do

    address_list = %w[
      n4rYhkv1LgtbXaXuFNCgG1hATJJTSec8F5
      n4rYhdx8CGo5fSVGh3jpfPhdHvJu6U7EQo
      n4rYdFbkiLSTdQ3uWsG7C46nikJmHjvhuV
    ]

    # address_info is a convenient source of tx ids
    data = blockr.address_info address_list

    # Suck out the transaction IDs
    transaction_list = []
    data.each do |addr_info|
      transaction_list << addr_info[:first_tx][:tx]
      transaction_list << addr_info[:last_tx][:tx]
    end

    # This is very verbose
    puts JSON.pretty_generate blockr.transactions transaction_list

  end

end
