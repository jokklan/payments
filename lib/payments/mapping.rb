module Payments
  class Mapping #:nodoc:
    attr_reader :singular, :scoped_path, :path, :controller, :path_names, :klass,
                :class_name, :sign_out_via, :format, :used_routes, :used_helpers, :failure_app, :as

    alias :name :singular
    
    # Receives an object and find a scope for it. If a scope cannot be found,
    # raises an error. If a symbol is given, it's considered to be the scope.
    class << self
      
      def find_scope!(duck)
        case duck
        when String, Symbol
          return duck
        when Class
          Payments.mappings.each_value { |m| return m.name if duck <= m.to }
        else
          Payments.mappings.each_value { |m| return m.name if duck.is_a?(m.to) }
        end

        raise "Could not find a valid mapping for #{duck.inspect}"
      end

      def find_by_path!(path, path_type=:fullpath)
        Devise.mappings.each_value { |m| return m if path.include?(m.send(path_type)) }
        raise "Could not find a valid mapping for path #{path.inspect}"
      end
      
    end
    
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