# encoding: utf-8

module BazarkaAllegro
  module Types
    class Listing
      LISTING_TYPES = {
        0 => "3",
        1 => "5",
        2 => "7",
        3 => "10",
        4 => "14",
        5 => "30"
      }

      ADDITIONAL_OPTIONS = {
        1 => "Pogrubienie",
        2 => "Miniaturka",
        4 => "Podświetlenie",
        8 => "Wyroznienie",
        16 => "Strona kategorii",
        32 => "Strona glowna allegro",
        64 => "Znak wodny"
      }

      SHIPMENT_COSTS_COVERAGE = {
          0 => "Seller",
          1 => "Buyer"
      }

      UNIT_OF_MEASURES = {
          0 => "Sztuk",
          1 => "Kompletow",
          2 => "Par"
      }

      # To co dostajemy w odpowiedzi od allegro
      FORM_TYPE = {
        1 => 'string',
        2 => 'integer',
        3 => 'float',
        4 => 'combobox',
        5 => 'radiobutton',
        6 => 'checkbox',
        7 => 'image (base64Binary)',
        8 => 'text (textarea)',
        9 => 'datetime (Unix time)',
        13 => 'date'
      }

      BAZARKA_FORM_TYPE = {
          1 => 'input',
          2 => 'input',
          3 => 'input',
          4 => 'select',
          5 => 'select',
          6 => 'input',
          7 => 'image',
          8 => 'textarea',
          9 => 'datetime',
          13 => 'date'
      }

    end
  end
end