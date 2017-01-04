module BazarkaAllegro
  module Hooks
    class Auction
      attr_reader :client

      def initialize(client)
        @client = client
      end

      # fields for form
      # Helpful for building forms
      def do_get_sell_form_fields_ext
        message = {country_code: client.country_code, local_version: client.local_version, webapi_key: client.webapi_key}
        client.call(:do_get_sell_form_fields_ext, message: message )
      end

      # items being sold now
      def do_get_my_sell_items(item_ids = nil)
        #message = {session_id: client.session_handle, item_ids: item_ids}
        message = {session_id: client.session_handle}
        client.call(:do_get_my_sell_items, message: message )

      end

      # items that did not sell
      def do_get_my_not_sold_items(item_ids = nil)
        item_ids.present? ? message = {session_id: client.session_handle, item_ids: item_ids} : message = {session_id: client.session_handle}
        #message = {session_id: client.session_handle}
        client.call(:do_get_my_not_sold_items, message: message )
      end

      # items that you sold
      def do_get_my_sold_items(item_ids = nil)
        message = {session_id: client.session_handle, item_ids: item_ids}
        #message = {session_id: client.session_handle}
        #@sold_items = client.call(:do_get_my_sold_items, message: message ).body[:do_get_my_sold_items_response][:sell_items_list]
        @sold_items = client.call(:do_get_my_sold_items, message: message )
      end

      # validates and returns validated item description
      def do_check_item_description(description)
        message = {session_id: client.session_handle, description_content: description}
        client.call(:do_check_item_description, message: message )
      end

      # sprawdza czy wystawiana aukcja jest poprawna oraz zwraca koszty wystawienia
      def do_check_new_auction_ext(fields = {})
        message = {session_handle: client.session_handle, fields: fields}
        client.call(:do_check_new_auction_ext, message: message )
      end

      # wystawia nowa aukcje
      def do_new_auction_ext(fields = {})
        #puts fields
        message = {session_handle: client.session_handle, fields: fields, item_template_id: 0, local_id: 123, item_template_create: {item_template_option: 0, item_template_name: ''}}
        #puts message
        client.call(:do_new_auction_ext, message: message )
      end

     # zmiana liczny przedmiotow dostepnych na początku aukcji
      def do_change_quantity_item(item_id, quantity)
        message = {session_handle: client.session_handle, item_id: item_id, new_item_quantity: quantity}
        client.call(:do_change_quantity_item, message: message)
      end

     #  aktualizacja aukcji
      def do_change_item_fields(item_id, fields)
        message = { session_id: client.session_handle, item_id: item_id, fields_to_modify: fields}
        client.call(:do_change_item_fields, message: message )
      end

      # Konczy aukcje przed czasem
      # items_id - id aukcji
      #
      def do_finish_item(item_id)
        message = {session_handle: client.session_handle, finish_item_id: item_id}
        client.call(:do_finish_item, message: message)
      end

      #nowe funkcje

      #pobierz komentarze
      #komentarze wystawione przez uzytkownika
      def do_get_feedback_from(user_id)
        m={session_handle: client.session_handle, feedbackFrom: user_id, feedbackTo: 0}
        client.call(:do_get_feedback, message: m)
      end

      #komentarze ktore zostały wwystawione uzytkownikowi
      def do_get_feedback_to(user_id)
        m={session_handle: client.session_handle, feedbackFrom: 0, feedbackTo: user_id}
        client.call(:do_get_feedback, message: m)
      end

      #dodaj opis do aukcji
      def do_add_desc_to_items(items_ids=[], description="")
        m={session_handle: client.session_handle, itemsIdArray: {item: items_ids}, itDescription: description}
        client.call(:do_add_desc_to_items, message: m)
      end


      # pobiera informac
      def do_get_items_info(items_id_array, get_desc = 1, get_image_url = 1, get_attribs = 1, get_postage_options = 1, get_company_info = 0)
        message = {
            session_handle: client.session_handle,
            items_id_array: { item: items_id_array},
            get_desc: get_desc,
            get_image_url: get_image_url,
            get_attribs: get_attribs,
            get_postage_options: get_postage_options,
            get_company_info: get_company_info
        }

        client.call(:do_get_items_info, message: message)
      end
    end
  end
end