# -*- coding: utf-8 -*-
class VarForErb

  attr_accessor :email
  attr_accessor :password
  attr_accessor :auth_token
  attr_accessor :developer_token
  attr_accessor :client_email

  def get_binding
    binding
  end
end

class Client

  def initialize(profile = :sandbox)

    @config = Sem4r::Profile.configure
    @options = Sem4r::Profile.load_config(@config, profile)

    Sem4r::Profile.try_to_find_in_password_file("password", @options, @config)
    Sem4r::Profile.try_to_find_in_password_file("auth_token", @options, @config)

    Sem4r::Profile.try_to_find_in_password_file("token_credential_key", @options, @config)
    Sem4r::Profile.try_to_find_in_password_file("token_credential_secret", @options, @config)

    @email = @options["email"]
    @password = @options["password"]
    @auth_token = @options["auth_token"]

    @token_credential_key = @options["token_credential_key"]
    @token_credential_secret = @options["token_credential_secret"]
  end

  def send(service_url, soap_action, filename)
    puts "** #{service_url}"

    request_xml = read_message(filename)
    puts Sem4r::pretty_print_xml_with_nokogiri(request_xml)

    headers = {
        "Content-Type" => "text/xml; charset=utf-8",
        "Content-Length" => request_xml.length.to_s,
        "SOAPAction" => soap_action}
    client = HTTPClient.new(:agent_name => 'Ruby')
    response = client.post(service_url, request_xml, headers)
    # pp response

    response_xml = response.body.content

    puts "*********************"
    puts Sem4r::pretty_print_xml_with_nokogiri(response_xml)
  end

  def send_oauth(service_url, soap_action, filename)
    puts "** #{service_url}"

    request_xml = read_message(filename)
    puts Sem4r::pretty_print_xml_with_nokogiri(request_xml)

    headers = {
        "Content-Type" => "text/xml; charset=utf-8",
        "Content-Length" => request_xml.length.to_s,
        "SOAPAction" => soap_action}

    client = Signet::OAuth1::Client.new(
        :temporary_credential_uri =>
            'https://www.google.com/accounts/OAuthGetRequestToken',
        :authorization_uri =>
            'https://www.google.com/accounts/OAuthAuthorizeToken',
        :token_credential_uri =>
            'https://www.google.com/accounts/OAuthGetAccessToken',
        :client_credential_key => 'anonymous',
        :client_credential_secret => 'anonymous',
        :token_credential_key => @token_credential_key,
        :token_credential_secret => @token_credential_secret
    )

    request = client.generate_authenticated_request(
        :method => "POST",
        :uri => service_url,
        :headers => headers,
        :body => request_xml
    )

    auth_header = request[2].select { |k,v| k == "Authorization" }
    v = auth_header[0][1]

    headers["Authorization"] = v
    pp headers

    client = HTTPClient.new(:agent_name => 'Ruby')

    response = client.post(service_url, request_xml, headers)
    # pp response

    response_xml = response.body.content

    puts "*********************"
    puts Sem4r::pretty_print_xml_with_nokogiri(response_xml)

  end

  def read_message(filename)
    requests_xml_dir = File.expand_path(File.join(File.dirname(__FILE__), "requests_xml"))
    unless File.directory?(requests_xml_dir)
      puts "#{requests_xml_dir} not exists"
      exit
    end

    var_for_erb = VarForErb.new
    var_for_erb.email = @email
    var_for_erb.password = @password
    var_for_erb.auth_token = @auth_token
    var_for_erb.developer_token = "#{@email}++EUR"
    var_for_erb.client_email = "client_1+#{@email}"

    filepath = File.join(requests_xml_dir, filename)
    template_request_xml = File.read(filepath)
    template = ERB.new(template_request_xml)
    request_xml = template.result(var_for_erb.get_binding)
    request_xml
  end

  #
  # ClientLogin
  #
  def authorize_token(force = false)
    return @auth_token unless force or @auth_token.nil?
    url = "https://www.google.com/accounts/ClientLogin"
    body = "accountType=GOOGLE&Email=#{URI.escape(@email)}&Passwd=#{URI.escape(@password)}&service=adwords"
    headers = {'Content-Type' => 'application/x-www-form-urlencoded'}


    client = HTTPClient.new(:agent_name => 'Ruby')
    response = client.post(url, body, headers)

    #pp response
    #pp response.body

    if response.status < 400
      # pp response.body.content
    end
    @auth_token = response.body.content[/Auth=(.*)/, 1]
    @options["auth_token"] = @auth_token

    Sem4r::Profile.save_passwords("auth_token", @options, @config)
    @auth_token
  end


  def oauth
    client = Signet::OAuth1::Client.new(
        :temporary_credential_uri =>
            'https://www.google.com/accounts/OAuthGetRequestToken',
        :authorization_uri =>
            'https://www.google.com/accounts/OAuthAuthorizeToken',
        :token_credential_uri =>
            'https://www.google.com/accounts/OAuthGetAccessToken',
        :client_credential_key => 'anonymous',
        :client_credential_secret => 'anonymous'
    )

    # ""https://{server}/api/adwords/",
    # where {server} is either
    # "adwords.google.com" or "adwords-sandbox.google.com".

    client.fetch_temporary_credential!(:additional_parameters => {
        # :scope => 'https://mail.google.com/mail/feed/atom'
        :scope => "https://adwords-sandbox.google.com/api/adwords/"
    })

    puts "go to this url: #{client.authorization_uri}"
    puts "and type authorization here: "
    verifier = gets.chop
    puts "authorization is '#{verifier}'"
    client.fetch_token_credential!(:verifier => verifier)

    puts "client_credential_key    #{client.client_credential_key}"
    puts "client_credential_secret #{client.client_credential_secret}"

    puts "token_credential_key    #{client.token_credential_key}"
    puts "token_credential_secret #{client.token_credential_secret}"

    @options["token_credential_key"] = client.token_credential_key
    @options["token_credential_secret"] = client.token_credential_secret
    Sem4r::Profile.save_passwords("token_credential_key", @options, @config)
    Sem4r::Profile.save_passwords("token_credential_secret", @options, @config)
    # response = client.fetch_protected_resource(
    #     :uri => 'https://mail.google.com/mail/feed/atom'
    # )

    # The Rack response format is used here
    # status, headers, body = response

    # puts body
  end

end
