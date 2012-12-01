require "active_support/core_ext/object/try"

module ActionDispatch::Routing
  class Mapper
    
    def payments_for(*resources)
      @devise_finalized = false
      options = resources.extract_options!
      
      options[:as]          ||= @scope[:as]     if @scope[:as].present?
      options[:module]      ||= @scope[:module] if @scope[:module].present?
      options[:path_prefix] ||= @scope[:path]   if @scope[:path].present?
      options[:path_names]    = (@scope[:path_names] || {}).merge(options[:path_names] || {})
      options[:constraints]   = (@scope[:constraints] || {}).merge(options[:constraints] || {})
      options[:defaults]      = (@scope[:defaults] || {}).merge(options[:defaults] || {})
      options[:options]       = (@scope[:options] || {}).merge({:format => false}) if options[:format] == false

      resources.map!(&:to_sym)

      resources.each do |resource|
        mapping = Payments.add_mapping(resource, options)
        
        # begin
        #   raise_no_devise_method_error!(mapping.class_name) unless mapping.to.respond_to?(:devise)
        # rescue NameError => e
        #   raise unless mapping.class_name == resource.to_s.classify
        #   warn "[WARNING] You provided devise_for #{resource.inspect} but there is " <<
        #     "no model #{mapping.class_name} defined in your application"
        #   next
        # rescue NoMethodError => e
        #   raise unless e.message.include?("undefined method `devise'")
        #   raise_no_devise_method_error!(mapping.class_name)
        # end
        payments_scope mapping.name do
          payments_routes(mapping, mapping.controller)
        end
      end
    end
    
    def payments_scope(scope)
      constraint = lambda do |request|
        request.env["payment.mapping"] = Payments.mappings[scope]
        true
      end

      constraints(constraint) do
        yield
      end
    end
    alias :as :payments_scope
    
    protected
    
    def payments_routes(mapping, controller) #:nodoc:
      # scope :module => "payments" do
        resources :payments, only: [], :controller => controller, :path => mapping.path, :as => mapping.as do
          member do
            get :submit
            get :cancel
            get :return
            post :callback
          end
        end
      # end
      
    end
    
  end
end