
class PaymentsController < ::ApplicationController
  helper ActiveMerchant::Billing::Integrations::ActionViewHelper

  helpers = %w(resource resource_name payment_mapping)
  hide_action *helpers
  helper_method *helpers

  prepend_before_filter :assert_is_payment_resource!

  def cancel
  end

  def submit
  end

  def return
  end

  def callback
    if resource.authorize_payment(request.raw_post)
      OrderMailer.order_confirmation(resource).deliver
      OrderMailer.order_notification(resource).deliver
    else
      OrderMailer.order_failure(resource).deliver
      OrderMailer.order_failure_notification(resource).deliver
    end
    render nothing: true
  end



  # Gets the actual resource stored in the instance variable
  def resource
    instance_variable_get(:"@#{resource_name}") || resource = resource_class.find(params[:id])
  end

  # Proxy to payment map name
  def resource_name
    payment_mapping.name
  end
  alias :scope_name :resource_name
  
  # Proxy to devise map class
  def resource_class
    payment_mapping.klass
  end

  # Attempt to find the mapped route for payment based on request path
  def payment_mapping
    @payment_mapping ||= request.env["payment.mapping"]
  end

  # Sets the resource creating an instance variable
  def resource=(new_resource)
    instance_variable_set(:"@#{resource_name}", new_resource)
  end

  # Build a payment resource.
  def build_resource(hash=nil)
    hash ||= params[resource_name] || {}
    self.resource = resource_class.new(hash)
  end

  # Checks whether it's a devise mapped resource or not.
  def assert_is_payment_resource! #:nodoc:
    unknown_action! <<-MESSAGE unless payment_mapping
Could not find payment mapping for path #{request.fullpath.inspect}.
Maybe you forgot to wrap your route inside the scope block? For example:

payment_scope :order do
  match "/some/route" => "some_payment_controller"
end
MESSAGE
  end

  def unknown_action!(msg)
    logger.debug "[Payments] #{msg}" if logger
    raise AbstractController::ActionNotFound, msg
  end

end
