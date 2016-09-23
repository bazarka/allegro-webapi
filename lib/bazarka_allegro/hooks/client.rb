module BazarkaAllegro
  module Hooks
  class Client
    if Rails.env == 'production'
      END_POINT = 'https://webapi.allegro.pl/service.php?wsdl'
    else
      END_POINT = 'https://webapi.allegro.pl.webapisandbox.pl/service.php?wsdl'
      # END_POINT = 'https://webapi.allegro.pl/service.php?wsdl'
    end


    attr_accessor :user_login, :webapi_key, :local_version, :country_code
    attr_reader :client, :password, :session_handle

    def initialize(store, general_credentials = {})
      if !store.nil?
        extension = store.extensions.where(key: :allegro).first
        #Rails.logger.info "------------------"
        #Rails.logger.info extension
        #Rails.logger.info "------------------"
        self.user_login = extension.details['user_login']
        self.webapi_key = extension.details['webapi_key']
        self.country_code = extension.details['country_code']
        self.password = extension.details['password']

      elsif !general_credentials.blank?
        #Rails.logger.info  general_credentials
        #puts general_credentials
        self.user_login = general_credentials[:user_login]
        self.webapi_key = general_credentials[:webapi_key]
        self.country_code = general_credentials[:country_code]
        self.password = general_credentials[:password]
      else
        # store jest nilem. pobierz atrybuty podczas tworzenia obiektu
        yield self
      end
      start_client
      query_system_stas(3,country_code, webapi_key)
      login
    end


    def password=(password)
      hash = Digest::SHA256.new.digest(password)
      @password = Base64.encode64(hash)
    end

    def call(operation_name, locals= {})
      client.call(operation_name, locals)
    end

    # Metoda pozwala na pobranie wartości jednego z wersjonowanych komponentów (drzewo kategorii oraz pola formularza sprzedaży)
    # oraz umożliwia podgląd klucza wersji dla wskazanego krajów.
    # country_id - 1 (Polska)
    # component -  3 (wersja spisu kategorii)
    # component -  4 (wersja formularza sprzedaży i jego pól)
    def query_system_stas(component, country_id, webapi_key)
      message =  {sysvar: component, country_id: country_id, webapi_key: webapi_key}
      response = client.call(:do_query_sys_status, message: message)
      @local_version = response.body[:do_query_sys_status_response][:ver_key]
    end

    def login
      #start_client
      message =  {user_login: user_login, user_hash_password: password, country_code: country_code, webapi_key: webapi_key, local_version: local_version}
      response = client.call(:do_login_enc, message: message)
      set_session_handle(response)
      self
    end

    def set_session_handle(login_response)
      @session_handle = login_response.body[:do_login_enc_response][:session_handle_part]
    end

    private

    def start_client
      @client = Savon.client do
        ssl_verify_mode :none
        wsdl END_POINT
        log  true
        log_level  :debug
        pretty_print_xml true
        strip_namespaces true
      end
    end
    end
  end
end