module BazarkaAllegro
  module Hooks
  class Search
    attr_reader :client

    def initialize(client)
      @client = client
    end


    def search_query(search_string, options = {})
      message = { webapi_key: client.webapi_key, country_id: client.country_code }.merge(options)

      unless search_string.blank?
        message[:filter_options] ||= {}
        message[:filter_options][:item] ||= []

        message[:filter_options][:item] << {
            filter_id: 'search',
            filter_value_id: [
                { item: search_string }
            ]
        }
      end

      client.call(:do_get_items_list, message: message).body
    end

  end
    end
end
