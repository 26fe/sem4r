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
  module SoapCall

    def self.included(base)
      base.extend ClassMethods
    end
    
    def helper_call_v13(credentials, soap_body_content)
      re = /<(\w+)/m   # use double blackslash because we are into string
      match_data = soap_body_content.match(re)
      if match_data
        soap_action = match_data[1]
      else
        puts "errore"
        puts soap_body_content
        raise "Soapaction not found"
      end

      soap_message = SoapMessageV13.new( @connector, credentials)
      soap_message.body = soap_body_content
      if credentials.sandbox?
        soap_message.send(@sandbox_service_url, soap_action)
      else
        soap_message.send(@production_service_url, soap_action)
      end
    end

    def helper_call_v2009(credentials, soap_body_content)
      soap_message = SoapMessageV2009.new(@connector, credentials)
      soap_message.init( @header_namespace, @service_namespace )
      soap_message.body = soap_body_content
      if credentials.sandbox?
        soap_message.send(@sandbox_service_url)
      else
        soap_message.send(@production_service_url)
      end
    end

    module ClassMethods
      def soap_call(helper_version, method, options = {})
        options.assert_valid_keys(:mutate)
        mutate = options.delete :mutate
        if mutate.nil? or mutate
          smutate = "credentials.mutable?"
        else
          smutate = "true"
        end
        # public_method_pars = ['credentials'].concat(args).join(",")

        # private_method_pars = args.join(",")
        # private_method_pars = ", #{private_method_pars}" unless private_method_pars.empty?

        rubystr =<<-EOFS
          define_method :#{method.to_sym} do |*args|
            credentials = args.shift
            if #{smutate}
              soap_body_content = send("_#{method}", *args)
              #{helper_version}(credentials, soap_body_content)
            else
              raise "mutate methods '#{method}' cannot be called on read_only profile"
            end
          end
        EOFS
        eval rubystr
      end

      def soap_call_v13(method, options = {})
        soap_call("helper_call_v13", method, options)
      end

      def soap_call_v2010(method, options = {})
        soap_call("helper_call_v2009", method, options)
      end
    end

  end
end
