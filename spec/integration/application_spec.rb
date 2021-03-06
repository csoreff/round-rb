require 'spec_helper'

describe Round::Application do
  let!(:app_and_client) { app_auth_client }
  let!(:app) { app_and_client[0] }
  let!(:client) { app_and_client[1] }

  describe 'application auth' do
    it 'should create wallets' do
      _, wallet = app.wallets.create('name', 'password')
      expect { wallet.unlock('password') }.to_not raise_error
      expect { wallet.unlock('wrong') }.to raise_error
    end

    it 'should have accounts' do
      backup, wallet = app.wallets.create('name', 'p2')
      account = wallet.accounts['default']
      expect(backup.class).to eq String
      expect(account.respond_to?(:pay)).to eq true
    end

    it 'should create bitcoin and testnet accounts' do
      _, wallet = app.wallets.create('name', 'p2')
      testnet_a = wallet.accounts.create(name: 'test', network: :bitcoin_testnet)
      bitcoin_a = wallet.accounts.create(name: 'bit', network: :bitcoin)
      litecoin_a = wallet.accounts.create(name: 'lite', network: :litecoin)
      dogecoin_a = wallet.accounts.create(name: 'doge', network: :dogecoin)
      testnet_addr = testnet_a.addresses.create.string
      expect(testnet_addr[0]).to eq '2'
      bitcoin_addr = bitcoin_a.addresses.create.string
      expect(bitcoin_addr[0]).to eq '3'
      litecoin_addr = litecoin_a.addresses.create.string
      dogecoin_addr = dogecoin_a.addresses.create.string
      puts testnet_addr
      puts bitcoin_addr
      puts litecoin_addr
      puts dogecoin_addr
    end

    it 'should view users' do
      size = app.users.size
      identify_auth_user
      expect(app.users.size).to eq size + 1
    end

    # Uncomment this if you'd like to test resetting tokens.
    # This will break other tests and force you to reassign ENV vars.
    #it 'should reset api_token' do
      #api_token = app.api_token
      #app.totp = Round::TestHelpers::Auth::TestCreds::TOTP_SECRET
      #token = app.get_mfa
      #puts token
      #new_app = app.with_mfa!(token).reset(Round::API_TOKEN)
      #new_app.refresh
      #expect(new_app.api_token).to_not eq api_token
      #puts 'NEW API TOKEN'
      #puts new_app.api_token
    #end
  end
end
