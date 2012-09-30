module Payments
  module Generators
    # Include this module in your generator to generate Payments views.
    # `copy_views` is the main method and by default copies all views
    # with forms.
    module ViewPathTemplates #:nodoc:
      extend ActiveSupport::Concern

      included do
        argument :scope, :required => false, :default => nil,
                         :desc => "The scope to copy views to"

        public_task :copy_views
      end

      def copy_views
        view_directory :payments
        # view_directory :mailer
      end

      protected

      def view_directory(name, _target_path = nil)
        directory name.to_s, _target_path || "#{target_path}/#{name}"
      end

      def target_path
        @target_path ||= "app/views/#{scope || :payments}"
      end
    end

    class ViewsGenerator < Rails::Generators::Base
      include ViewPathTemplates

      source_root File.expand_path("../../../../app/views/payments", __FILE__)
      desc "Copies Payments views to your application."

    end
  end
end
