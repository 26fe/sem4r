## -------------------------------------------------------------------
## Copyright (c) 2009 Sem4r giovanni.ferro@gmail.com
##
## Permission is hereby granted, free of charge, to any person obtaining
## a copy of this software and associated documentation files (the
## "Software"), to deal in the Software without restriction, including
## without limitation the rights to use, copy, modify, merge, publish,
## distribute, sublicense, and/or sell copies of the Software, and to
## permit persons to whom the Software is furnished to do so, subject to
## the following conditions:
##
## The above copyright notice and this permission notice shall be
## included in all copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
## EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
## MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
## NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
## LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
## OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
## WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
## -------------------------------------------------------------------

module Sem4r
  module Enum

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def enum(set, values)
        tmp = values.map do |v|
          if const_defined? (v.to_sym)
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

      def g_accessor(name)
        name = name.to_s
        str= <<-EOFS
        define_method :#{name}= do |value|
          @#{name}=value
        end

        define_method :#{name} do |value = nil|
          value ? self.#{name}= value : @#{name}
        end
        EOFS
        eval str
      end
      
      def g_set_accessor(column)
        column  = column.to_s
        columns = "#{column}s"
        str= <<-EOFS      
          define_method :#{column}= do |value|
            @#{columns} ||= []
            @#{columns} << value
          end

          define_method :#{column} do |value|
            @#{columns} ||= []
            @#{columns} << value
          end

          define_method :#{columns} do |*values|
            if values
               @#{columns} ||= []
               @#{columns}.concat(values)
            else
               @#{columns}
            end
          end

        EOFS
        eval str        
      end
      
    end

  end
end


if $0 == __FILE__
  class P
    include Sem4r::Enum
    enum :AggregationTypes, [
      :Daily,
      :DayOfWeek,
      :HourlyByDate,
      :HourlyRegardlessDate,
      :Monthly,
      :Quarterly,
      :Summary,
      :Weekly,
      :Yearly,

      :AdGroup,
      :Campaign,
      :Creative,
      :Keyword]

    enum :Columns, [:Campaign, :Id, :Keyword]
  end

  puts P::Daily
end
