class BitVault::Application < BitVault::Base
  def_delegators :@resource, :name, :callback_url, :update, :api_token

  def wallets
    @resource.context.set_token(@resource.url, @resource.api_token)
    @wallets ||= BitVault::WalletCollection.new(resource: @resource.wallets)
    @wallets
  end
end