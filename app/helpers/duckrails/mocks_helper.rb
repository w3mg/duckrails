module Duckrails
  module MocksHelper
    def available_mime_types
      Mime::EXTENSION_LOOKUP.map{ |a| a[1].to_s }.uniq
    end

    def available_body_types
      [ [t(Duckrails::Mock::BODY_TYPE_EMBEDDED_RUBY), Duckrails::Mock::BODY_TYPE_EMBEDDED_RUBY],
        [t(Duckrails::Mock::BODY_TYPE_STATIC), Duckrails::Mock::BODY_TYPE_STATIC] ]
    end

    def available_http_methods
      [:get, :post, :put, :patch, :delete, :options]
    end
  end
end
