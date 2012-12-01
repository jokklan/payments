module Devise
  class Engine < ::Rails::Engine
    config.payments = Payments
  end
end