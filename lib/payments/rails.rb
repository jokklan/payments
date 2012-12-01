require 'payments/rails/routes'

module Payments
  class Engine < ::Rails::Engine
    config.payments = Payments
    engine_name "payments"
    
    initializer "payments.url_helpers" do
      Payments.include_helpers(Payments::Controllers)
    end
  end
end