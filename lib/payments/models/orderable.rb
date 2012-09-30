require 'state_machine/core'

module Payments
  module Models
    module Orderable
      extend ActiveSupport::Concern
      
      module ClassMethods
        
        def include_states
          extend StateMachine::MacroMethods
    
          state_machine :state, :initial => :pending do
            event :payment_authorized do
              transition :pending => :authorized
              transition :payment_declined => :authorized
            end

            event :payment_captured do      
              transition :capture_failed => :completed
              transition :authorized => :completed
            end

            event :transaction_declined do
              transition :pending => :payment_declined
              transition :payment_declined => :payment_declined
              transition :authorized => :capture_failed
              transition :capture_failed => :capture_failed
            end

            state :authorized, :capture_failed do
              def captureable?
                true
              end
            end

            state all - [:authorized, :capture_failed] do
              def captureable?
                false
              end
            end
          end
        end
        
        def include_associations
          has_many :transactions, as: :orderable
        end
      end
      
      

      def capture_payment(options = {})
        transaction do
          capture = Payments::Transaction.capture(price_in_base_unit, authorization_reference, options)
          transactions.push(capture)
          if capture.success?
            payment_captured!
          else
            transaction_declined!
          end
          capture
        end
      end

      def authorize_payment(params, options = {})
        # Protective block, so either all or none of the sql queries succes
        transaction do
          authorization = Payments::Transaction.authorize(params, options)
          transactions.push(authorization)
          if authorization.success?
            payment_authorized!
          else
            transaction_declined!
          end
          authorization
        end
      end

      def authorization_reference
        if authorization = transactions.find_by_action_and_success('authorize', true, :order => 'id ASC')
          authorization.reference
        end 
      end
    
      def price_in_base_unit
        (total*100).round
      end
      
      def ordernumber
        if read_attribute(:ordernumber).blank?
          self.update_attribute(:ordernumber, (Time.now.to_s + id.to_s).gsub(/[^\w_]/, '').rjust(4, "0")[0,20])
        end
        read_attribute(:ordernumber)
      end
      
    end
  end
end