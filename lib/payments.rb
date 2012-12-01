autoload :PaymentsGenerator, 'generators/payments_generator'

module Payments
  require 'payments/mapping'
  require 'payments/route'
  require 'payments/configuration'
  require 'payments/models'
  require 'payments/engine'
  
  # Store scopes mappings.
  mattr_reader :mappings
  @@mappings = ActiveSupport::OrderedHash.new
  
  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = Payments.active_merchant_mode
    Payments::Transaction.gateway = ActiveMerchant::Billing::Base.gateway(Payments.active_merchant_payment_provider).new(Payments.active_merchant_login_information)
    Payments::Transaction.integration = ActiveMerchant::Billing::Base.integration(Payments.active_merchant_payment_provider)
  end
  
  class << self
    
    def add_mapping(resource, options)
      mapping = Payments::Mapping.new(resource, options)
      @@mappings[mapping.name] = mapping
    end
    
  end
end

ActiveRecord::Base.extend Payments::Models