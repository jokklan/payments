module Payments
  module Generators
    class InstallGenerator < Rails::Generators::Base
  
      source_root File.expand_path("../../templates", __FILE__)
      
      desc "Creates a Payments initializer and migrations for transactions."
      
      class_option :orm

      def generate_payments_initializer
        template "config/initializers/payments.rb.erb", File.join(destination_root, "config", "initializers", "payments.rb")
      end
  
      def rake_db
        rake("payments:install:migrations")
      end
      
    end
  end
end
