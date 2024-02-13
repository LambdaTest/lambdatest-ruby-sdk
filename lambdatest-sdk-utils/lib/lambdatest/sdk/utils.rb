# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

require_relative "utils/version.rb"
require_relative "utils/logger.rb"

module Lambdatest
  module Sdk
    module Utils
      @logger = Lambdatest::Sdk::Utils.get_logger(get_pkg_name)

      def self.is_smartui_enabled?
        begin
          make_api_call("/healthcheck", method: :get, data: nil)
          return true
        rescue => exception
           @logger.debug("#{exception.message}")
          return false
        end
      end

      def self.fetch_dom_serializer
        make_api_call('/domserializer', method: :get,data: nil)
      end

      def self.post_snapshot(snapshot,pkg_name,options={})
        uri = URI("#{get_smart_ui_server_address}/snapshot")
        data = JSON.generate({
          snapshot: {
            **snapshot,
            options: options
          },
          testType: pkg_name
        })
        make_api_call('/snapshot', method: :post, data: data)
      end

      def self.make_api_call(endpoint, method: :get, data: nil)
        uri = URI("#{get_smart_ui_server_address}#{endpoint}")

        response = case method
                   when :get
                     Net::HTTP.get_response(uri)
                   when :post
                     Net::HTTP.post(uri, data, 'Content-Type' => 'application/json')
                   end

        unless response.is_a? Net::HTTPSuccess
            raise StandardError, "Failed with HTTP error code: #{response.code}"
        end

        response.is_a?(Net::HTTPSuccess) ? response.body : nil
      end
    end
  end
end
