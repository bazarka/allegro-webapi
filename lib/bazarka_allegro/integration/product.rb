module BazarkaAllegro
  module Integration
    module Product
      def self.included(base)
        base.after_update  :update_allegro, if: :is_connect_with_allegro?
        base.before_destroy :delete_from_allegro, if: :is_connect_with_allegro?
      end

      def update_allegro
        Rails.logger.info "-----------------Update Allegro-----------------" if Rails.env == "development"
        extension_for_product = self.extension_for_products.where(key: 'allegro').first
        if self.quantity.to_i <  extension_for_product.allegro_quantity.to_i
          extension_for_product.update(allegro_quantity: self.quantity)
        end
        product = ProductAllegro.new(self.store)
        Rails.logger.info "-----------------Update Allegro quantity #{self.quantity}-----------------"  if Rails.env == "development"
        product.update_item_quantity(self)

      end


      # wysylamy cos na allegro, jesli sie poprawnie nie wysle przechwytujemy error
      # dodajemy go do produktu
      def send_to_allegro
        product = ProductAllegro.new(self.store)
        item_id = product.add_item(options)
        if item_id
          return item_id
        else
          errors.add :auction_id, product.errors
        end
        nil
      end

      # weryfikujemy czy dany produkt przjedzie validacje allegro
      # możemy podać jako parametr obiekt extension_for_product wtedy nie pobiera go z bazy danych
      def verify_in_allegro(extension = nil)
        product = ProductAllegro.new(self.store)
        if extension.nil?
          product.verify_add_item(options)
        else
          product.verify_add_item(options(extension))
        end
        product
      end

      def delete_from_allegro
        product = ProductAllegro.new(self.store)
        response = product.do_finish_item(self.extension_for_products.where(key: 'allegro').first.allegro_id)
        Rails.logger.info "------ delete_from_allegro ----------- #{response.to_hash}-----------------" if Rails.env == "development"
        self.extension_for_products.where(key: 'allegro').first.destroy
        product
      end


      private
      def is_connect_with_allegro?
         self.store.allegro.present? and self.store.allegro == '1'  and self.extension_for_products.where(key: :allegro).where(published: true).present?
      end

      # tworzymy opcje na podstawie produktu i extension_for_products
      # jeśli przekażemy jako parametr extension_for_product to wtedy nie pobieramy już go z bazy
      def options(extension = nil)
        #store = self.store
        if extension.nil?
          extension_for_product = self.extension_for_products.where(key: :allegro).first
        else
          extension_for_product = extension
        end
        #extension = store.extensions.where(key: :allegro).first


        hash ={}
        extension_for_product.details.each do |k,v|
          if v.present?
            hash.merge!(k => v)
          end
        end
        hash.merge!( 'attribute_1' => hash['attribute_1'].to_s.gsub("{{product_name}}",self.name),
                     'attribute_24' => self.description_allegro(extension_for_product.allegro_template_id),
                      'attribute_8' => self.price )

        # jeśli śledzimy ilość w bazarce to bierzemy liczbę z produktu
        # jeśli nie śledzimy to bierzemy 999
        if self.inventory == 'tracks_this_products'
          hash.merge!('attribute_5' => self.quantity)
          # sprawdzamy czy to jest obiekt zapisany w bazie danych czy nie
          # jeśli nie jest w bazie to nie robimy update bo to zpisuje w bazie danych
          if extension_for_product.id.present?
            extension_for_product.update(allegro_quantity: self.quantity)
          else
            extension_for_product.allegro_quantity = self.quantity
          end
        else
          hash.merge!('attribute_5' => 999)
          # sprawdzamy czy to jest obiekt zapisany w bazie danych czy nie
          # jeśli nie jest w bazie to nie robimy update bo to zpisuje w bazie danych
          if extension_for_product.id.present?
            extension_for_product.update(allegro_quantity: 999)
          else
            extension_for_product.allegro_quantity = 999
          end
        end
        # usuniecie ceny wywoławczej oraz ceny minimalnej
        hash.delete('attribute_6')
        hash.delete('attributetype_6')
        hash.delete('attribute_7')
        hash.delete('attributetype_7')

        # Pobieramy 8 obrazków z nazu
        images = self.image_products.order(:sort).limit(8)
        # obrazki w allegro mają nr od 16 do 23 więc robimy pętle
        16.upto(23) do |x|
          if hash["attribute_#{x}"].to_i == 1 and images[x-16].present?
            hash["attribute_#{x}"] = Base64.encode64(open(images[x-16].image.url()).read)
          else
            hash["attribute_#{x}"] = nil
          end
        end

        return hash

      end
    end
  end
end