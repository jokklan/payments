autoload :PaymentsGenerator, 'generators/payments_generator'

require 'payments/mapping'
require 'payments/configuration'
require 'payments/models'
require 'payments/rails'

module Payments  
  module Controllers
    autoload :UrlHelpers, 'payments/controllers/url_helpers'
  end
  
  URL_HELPERS = ActiveSupport::OrderedHash.new
  
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
    
    def include_helpers(scope)
      ActiveSupport.on_load(:action_controller) do
        include scope::Helpers if defined?(scope::Helpers)
        include scope::UrlHelpers
      end
      
      ActiveSupport.on_load(:action_view) do
        include scope::UrlHelpers
      end
    end

  end
end

ActiveRecord::Base.extend Payments::Models