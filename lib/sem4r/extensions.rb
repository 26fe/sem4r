# -*- coding: utf-8 -*-
module Sem4r #:nodoc:
  module CoreExtensions #:nodoc:
    module Hash #:nodoc:
      # Return a new hash with all keys converted to strings.
      def stringify_keys
        inject({}) do |options, (key, value)|
          options[key.to_s] = value
          options
        end
      end

      # Destructively convert all keys to strings.
      def stringify_keys!
        keys.each do |key|
          self[key.to_s] = delete(key)
        end
        self
      end

      # Return a new hash with all keys converted to symbols.
      def symbolize_keys
        inject({}) do |options, (key, value)|
          options[(key.to_sym rescue key) || key] = value
          options
        end
      end

      # Destructively convert all keys to symbols.
      def symbolize_keys!
        self.replace(self.symbolize_keys)
      end

      alias_method :to_options,  :symbolize_keys
      alias_method :to_options!, :symbolize_keys!

      # Validate all keys in a hash match *valid keys, raising ArgumentError on a mismatch.
      # Note that keys are NOT treated indifferently, meaning if you use strings for keys but assert symbols
      # as keys, this will fail.
      #
      # ==== Examples
      #   { :name => "Rob", :years => "28" }.assert_valid_keys(:name, :age) # => raises "ArgumentError: Unknown key(s): years"
      #   { :name => "Rob", :age => "28" }.assert_valid_keys("name", "age") # => raises "ArgumentError: Unknown key(s): name, age"
      #   { :name => "Rob", :age => "28" }.assert_valid_keys(:name, :age) # => passes, raises nothing
      def assert_valid_keys(*valid_keys)
        unknown_keys = keys - [valid_keys].flatten
        raise(ArgumentError, "Unknown key(s): #{unknown_keys.join(", ")}") unless unknown_keys.empty?
      end

      #
      # Sem4r
      #
      def assert_check_keys(*mkeys)
        missing_keys = [mkeys].flatten - keys
        raise(ArgumentError, "Missing key(s): #{missing_keys.join(", ")}") unless missing_keys.empty?
      end
    end

    # Rails' ActiveSupport
    module String #:nodoc:
      def underscore
        # strtolower(preg_replace('/([a-z])([A-Z])/', '$1_$2', $class_name))
        self.gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          tr("-", "_").
          downcase
      end

      def camel_case
        self.gsub(/_([a-z])/) { $1.upcase }
      end
    end
  end
end

class Hash #:nodoc:
  include Sem4r::CoreExtensions::Hash
end

class String
  include Sem4r::CoreExtensions::String
end
