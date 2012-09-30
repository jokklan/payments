module Payments
  module PaymentsHelper

    def amount(price)
      (price*100).to_i
    end
    
  end
end
