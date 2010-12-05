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

  class SoapService

    def helper_call(api_version, soap_body_content)
      soap_action = ""

      case api_version
        when "v13"
          soap_message = SoapMessageV13.new(@connector, @credentials)
          match_data = soap_body_content.match(/<(\w+)/m)
          if match_data
            soap_action = match_data[1]
          else
            raise "Soapaction not found in #{soap_body_content}"
          end
        when "v2010"
          soap_message = SoapMessageV2010.new(@connector, @credentials)
          soap_message.init(@header_namespace, @service_namespace)
        else
          raise "unkwnow api version #{api_version}"
      end

      if @credentials.sandbox?
        soap_message.send(@sandbox_service_url, soap_action, soap_body_content)
      else
        soap_message.send(@production_service_url, soap_action, soap_body_content)
      end
    end

    def helper_call_raw(xml_message)
      soap_message = SoapMessageV2010.new(@connector, @credentials)
      soap_message.init( @header_namespace, @service_namespace )
      if @credentials.sandbox?
        soap_message.send_raw(@sandbox_service_url, xml_message)
      else
        soap_message.send_raw(@production_service_url, xml_message)
      end
    end


    def self._soap_call(api_version, method, options = {})
      options.assert_valid_keys(:mutate)
      mutate = options.delete :mutate
      if mutate.nil? or mutate
        smutate = "@credentials.mutable?"
      else
        smutate = "true"
      end
      rubystr =<<-EOFS
          define_method :#{method.to_sym} do |*args|
            if #{smutate}
              soap_body_content = send("_#{method}", *args)
              helper_call('#{api_version}', soap_body_content)
            else
              raise "mutate methods '#{method}' cannot be called on read_only profile"
            end
          end
      EOFS
      eval rubystr

      rubystr =<<-EOFS
          define_method :#{(method.to_s + "_raw").to_sym} do |*args|
            soap_message = args.shift
            if #{smutate}
              helper_call_raw('#{api_version}', soap_message)
            else
              raise "mutate methods '#{method}' cannot be called on read_only profile"
            end
          end
      EOFS
      eval rubystr
    end

  end

  class SoapServiceV13 < SoapService
    def self.soap_call(method, options = {})
      _soap_call("v13", method, options)
    end
  end

  class SoapServiceV2010 < SoapService
    def self.soap_call(method, options = {})
      _soap_call("v2010", method, options)
    end
  end

end # module Sem4rSoap