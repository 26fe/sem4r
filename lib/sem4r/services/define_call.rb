module Sem4r
  module DefineCall

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

      soap_message = @connector.message_v13(credentials)
      soap_message.body = soap_body_content
      if credentials.sandbox?
        soap_message.send(@service_url, soap_action)
      else
        soap_message.send(@service_url, soap_action)
      end
    end

    def helper_call_v2009(credentials, soap_body_content)
      soap_message = @connector.message_v2009(credentials, @header_namespace)
      soap_message.body = soap_body_content
      if credentials.sandbox?
        soap_message.send(@service_url)
      else
        soap_message.send(@service_url)
      end
    end

    module ClassMethods
      def define_call_v13(method, *args)
        public_method_pars = ['credentials'] .concat(args).join(",")

        private_method_pars = args.join(",")
        private_method_pars = ", #{private_method_pars}" unless private_method_pars.empty?

        rubystr =<<-EOFS
          define_method :#{method.to_sym} do |#{public_method_pars}|
            soap_body_content = send "_#{method}" #{private_method_pars}
            helper_call_v13(credentials, soap_body_content)
          end
        EOFS
        eval rubystr
      end

      def define_call_v2009(method, *args)
        public_method_pars = ['credentials'] .concat(args).join(",")

        private_method_pars = args.join(",")
        private_method_pars = ", #{private_method_pars}" unless private_method_pars.empty?

        rubystr =<<-EOFS
          define_method :#{method.to_sym} do |#{public_method_pars}|
            soap_body_content = send "_#{method}" #{private_method_pars}
            helper_call_v2009(credentials, soap_body_content)
          end
        EOFS
        eval rubystr
      end
    end

  end
end
