# -------------------------------------------------------------------
# Copyright (c) 2009-2010 Sem4r sem4ruby@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# -------------------------------------------------------------------

module Sem4r
  module SoapAttributes

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def enum(set, values)
        tmp = values.map do |v|
          if const_defined?(v.to_sym)
            const_get(v.to_sym)
          else
            const_set(v.to_sym, v.to_s)
          end
        end
        const_set( set.to_sym, tmp )
      end

      def g_reader(name)
        attr_reader name
      end

      #
      # constraints
      #   values_in
      #
      # TODO: g_accessor prende in input anche elements ed estrae automaticamente l'elemento che interessa
      #       cioe' invece di scrivere headline       el.elements["headline"].text dovrebbe bastare scrivere
      #       headline el
      def g_accessor(name, constraints = {})
        name = name.to_s

        # vales_in
        enum = nil
        if constraints.key?(:values_in)
          enum = const_get(constraints[:values_in])
        end

        # if_type
        if_type = nil
        if constraints.key?(:if_type)
          if_type = constraints[:if_type]
          other_instance_var = "type"
        end

        # default_value
        default_value = nil
        if constraints.key?(:default)
          default_value = constraints[:default]
        end

        define_method "#{name}=" do |value|
          if enum and !enum.include?(value)
            raise "Value '#{value}' not permitted "
          end
          if if_type
            type = instance_variable_get "@#{other_instance_var}"
            raise "type must be '#{if_type}' instead of '#{type}'" unless if_type == type
          end
          instance_variable_set "@#{name}", value
        end

        define_method "#{name}" do |*values|  # |value = nil| is incorrect in ruby 1.8
          raise ArgumentError, "wrong number of arguments (#{values.size} for 0)" if values.length > 1
          value = values.first
          if value
            self.__send__("#{name}=", value)
          elsif instance_variable_defined? "@#{name}"
            instance_variable_get "@#{name}"
          else
            default_value
          end
        end
      end
      
      def g_set_accessor(column, constraints = {})
        column  = column.to_s
        columns = "#{column}s"

        # values_in
        enum = nil
        if constraints.key?(:values_in)
          enum = const_get(constraints[:values_in])
        end

        define_method "#{column}=" do |value|
          if enum and !enum.include?(value)
            raise "Value not permitted #{value}"
          end
          instance_eval <<-EOFS
            @#{columns} ||= []
            @#{columns} << value unless @#{columns}.include?(value)
          EOFS
        end

        alias_method column, "#{column}="

        define_method "#{columns}" do |*values|
          if values and !values.empty?
            instance_eval "@#{columns} ||= []"
            values.each do |value|
              instance_eval "@#{column}(value)"
            end
          else
            instance_eval "@#{columns} ||= []"
            instance_variable_get "@#{columns}"
          end
        end

      end
      
    end

  end
end

