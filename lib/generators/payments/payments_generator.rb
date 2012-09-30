module Payments
  module Generators
    class PaymentsGenerator < Rails::Generators::NamedBase
      namespace "payments"
      source_root File.expand_path("../templates", __FILE__)

      desc "Generates a model with the given NAME (if one does not exist) with payments " <<
           "configuration plus a migration file and payments routes."

      hook_for :orm

      class_option :routes, :desc => "Generate routes", :type => :boolean, :default => true

      def add_payments_routes
        payments_route  = "payments_for :#{plural_name}"
        payments_route << %Q(, :class_name => "#{class_name}") if class_name.include?("::")
        payments_route << %Q(, :skip => :all) unless options.routes?
        route payments_route
      end
      
    end
  end
end

