module Payments
  class Mapping #:nodoc:
    attr_reader :singular, :scoped_path, :path, :controller, :path_names, :klass,
                :class_name, :sign_out_via, :format, :used_routes, :used_helpers, :failure_app, :as

    alias :name :singular
    
    def initialize(name, options) #:nodoc:
      @scoped_path = options[:as] ? "#{options[:as]}/#{name}" : name.to_s
      @singular = (options[:singular] || @scoped_path.tr('/', '_').singularize).to_sym

      @class_name = (options[:class_name] || name.to_s.classify).to_s
      @klass = @class_name.constantize

      @path = (options[:path] || name).to_s
      @path_prefix = options[:path_prefix]

      @sign_out_via = options[:sign_out_via] || Devise.sign_out_via
      @format = options[:format]

      @controller = options[:controller]
      @as = options[:as]
    end
    
    private
    
  end
end