require 'payments/models/orderable'

module Payments
  module Models
    
    def acts_as_orderable(*modules)
      options = modules.extract_options!
      include Payments::Models::Orderable
      send(:include_states)
      send(:include_associations)
      options.each { |key, value| send(:"#{key}=", value) }
    end
    
  end
end