require 'active_support/core_ext'
require 'json'
require 'net/http'
require 'uri'
require 'ringcaptcha/response'

module Ringcaptcha
  module API
    def self.call(api_key, app_key, path, params = {})
      uri = URI.parse("https://api.ringcaptcha.com")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new("/#{app_key}/#{path}")
      request.add_field('Content-Type', 'application/x-www-url-encoded')
      request.set_form_data params.merge!(api_key:api_key)

      response = do_http_request(http, request)

      json = JSON.parse(response.body)
      return Response.new(json.symbolize_keys!)
    end

    def self.do_http_request(http, request)
      attempts = 0
      begin
        return http.request(request)
      rescue EOFError => e
        attempts = attempts + 1
        if attempts < 3
          sleep(attempts**2)
          retry
        else
          raise e
        end
      end
    end

    def self.service_up?
      uri = URI.parse("https://api.ringcaptcha.com")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      response = http.request(Net::HTTP::Get.new("/status"))

      response.is_a?(Net::HTTPSuccess) && response.body == "WE ARE ALIVE ;-)"
    end
  end
end