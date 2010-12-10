# -*- coding: utf-8 -*-
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

module Sem4rSoap

  class MetaSoapAttribute
    attr_reader :name, :xpath
    def initialize(name, is_enum, xpath = nil)
      @name, @is_enum = name.to_sym, is_enum
      if xpath
        @xpath = xpath
      else
        @xpath = name.to_s.camel_case
      end
    end

    def enum?
      @is_enum
    end
  end

  module SoapAttributes

    def self.included(base)
      base.extend ClassMethods
    end

    def _to_xml(tag)
      builder = Builder::XmlMarkup.new
      builder.tag!(tag) do |t|
        self.class.attributes.each do |a|
          unless a.enum?
            value = self.send(a.name)
            t.__send__(a.xpath, value) unless value.nil? # value could be a boolean so 'if value' is wrong
          end
        end
      end
    end

    def _from_element(el)
      self.class.attributes.each do |a|
        unless a.enum?
          value = el.at_xpath(a.xpath)
          __send__ a.name, value.text.strip unless value.nil?
        end
      end
      self
    end

    def _to_s
      self.class.attributes.map do |a|
        if a.enum? then "" else self.send(a.name) end
      end.join(' ')
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

      def attributes
        @attributes
      end

      def g_reader(name)
        @attributes  ||= []
        @attributes << MetaSoapAttribute.new(name, false)
        attr_reader name
      end

      #
      # constraints
      #   :values_in
      #   :if_type
      #   :default
      #
      # TODO: g_accessor prende in input anche elements ed estrae automaticamente l'elemento che interessa
      #       cioe' invece di scrivere headline       el.at_xpath("headline").text dovrebbe bastare scrivere
      #       headline el
      def g_accessor(name, constraints = {})
        constraints.assert_valid_keys(:xpath, :values_in, :if_type, :default)
        attribute = add_attribute(name, false, constraints[:xpath])
        name = name.to_s

        #
        # define setter
        #

        # values_in
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

        #
        # define getter ( almost :-) )
        #

        # default_value
        default_value = nil
        if constraints.key?(:default)
          default_value = constraints[:default]
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
        constraints.assert_valid_keys(:values_in)

        column  = column.to_s
        columns = "#{column}s"
        attribute = add_attribute(columns, true)

        # values_in
        enum = nil
        if constraints.key?(:values_in)
          enum = const_get(constraints[:values_in])
        end

        #
        # define
        #    column= :a
        #    column :a
        #

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

        #
        # define
        #    colums [:a,:b,:c]
        # define
        #    colums
        #

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

      def _from_element(el)
        return nil unless el
        new._from_element(el)
      end

      private

      def add_attribute(name, is_enum, xpath = nil)
        @attributes  ||= []
        name = name.to_sym
        m = @attributes.find { |e| e.name == name.to_sym }
        if m
          raise "attribute #{name} already defined!!"
        end
        m = MetaSoapAttribute.new(name, is_enum, xpath)
        @attributes << m
        m
      end

    end # ClassMethods

  end # SoapAttributes
end # Sem4r
