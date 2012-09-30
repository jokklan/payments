module Payments
  include ActiveSupport::Configurable

  config_accessor :active_merchant_mode, :active_merchant_payment_provider, :active_merchant_login_information

  self.active_merchant_mode = :test
  self.active_merchant_payment_provider = "bogus"
  self.active_merchant_login_information = {login: "", password: ""}
  
end

