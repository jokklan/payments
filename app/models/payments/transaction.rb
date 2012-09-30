module Payments
  class Transaction < ActiveRecord::Base

    serialize :params
  
    cattr_accessor :gateway      
    cattr_accessor :integration
    
    attr_accessible :orderarble, :orderable_id, :orderable_type, :action, :amount, :reference, :success, :test, :message, :params, :position

    acts_as_indexed :fields => [:action, :reference, :message, :params]

    validates :action, presence: true
    validates :amount, presence: true
    validates :message, presence: true
    validates :reference, presence: true, :if => "success?"
  
    belongs_to :orderable, :polymorphic => true
  
    scope :authorized, where(action: "authorize")
    scope :captured, where(action: "capture")
    scope :successful, where(success: true)
    scope :failed, where(success: false)
    scope :testmode, where(test: true)
  
    class << self

      def authorize(params, options = {})
        process('authorize', integration) do |integ|
          integ.notification(params, options)
        end 
      end

      def capture(amount, authorization, options = {})
        process('capture', gateway, amount) do |gw|
          gw.capture(amount, authorization, options)
        end
      end

      private

      def process(action, type, amount = nil)
        result = Transaction.new
        result.action = action

        begin
          response = yield type
          result.amount     = (amount.nil? ? response.amount : amount)
          result.success    = response.success?
          result.reference  = response.authorization
          result.message    = response.message
          result.params     = response.params
          result.test       = response.test?
        rescue ActiveMerchant::ActiveMerchantError => e
          result.amount     = amount
          result.success    = false
          result.reference  = nil
          result.message    = e.message
          result.params     = {}
          result.test       = gateway.test?
        end
        result
      end
  
    end  
  
  end
end

