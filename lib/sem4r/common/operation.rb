# -------------------------------------------------------------------------
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
# 
# -------------------------------------------------------------------------

module Sem4r

  class Operation
    include SoapAttributes

    enum :Operations, [
      :ADD,
      :REMOVE,
      :SET]

    attr_reader :operation_type
    g_accessor :operator

    def add(operand)
      operator "ADD"
      @operand = operand
      self
    end

    def remove(operand)
      operator "REMOVE"
      @operand = operand
      self
    end

    def set(operand)
      operator "SET"
      @operand = operand
      self
    end

    def to_xml(tag)
      if @operand == nil
        raise Sem4rError, "Missing Operand"
      end

      xml = ""
      if tag
        xml += "<#{tag} xsi:type='#{operation_type}'>"
      end
      xml +=<<-EOS
        <operator>#{operator}</operator>
        #{@operand.to_xml('operand')}
      EOS

      if tag
        xml += "</#{tag}>"
      end
      xml
    end

  end

end
