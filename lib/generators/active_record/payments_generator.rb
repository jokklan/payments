require 'rails/generators/active_record'
require 'generators/payments/orm_helpers'

module ActiveRecord
  module Generators
    class PaymentsGenerator < ActiveRecord::Generators::Base
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      include Payments::Generators::OrmHelpers
      source_root File.expand_path("../templates", __FILE__)

      def copy_payments_migration
        if (behavior == :invoke && model_exists?) || (behavior == :revoke && migration_exists?(table_name))
          migration_template "migration_existing.rb", "db/migrate/add_payments_to_#{table_name}"
        else
          migration_template "migration.rb", "db/migrate/payments_create_#{table_name}"
        end
      end

      def generate_model
        invoke "active_record:model", [name], :migration => false unless model_exists? && behavior == :invoke
      end

      def inject_payments_content
        inject_into_class(model_path, class_name, model_contents + <<CONTENT) if model_exists?
  # Setup accessible (or protected) attributes for your model
  attr_accessible :session_id, :order_date, :state, :total
  attr_protected :ordernumber
CONTENT
      end

      def migration_data
<<RUBY

      ## Payments orderable
      t.string :ordernumber
      t.string :session_id

      t.datetime :order_date
      t.string :state
      t.float :total
RUBY
      end
    end
  end
end
