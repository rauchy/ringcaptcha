require 'json'
require 'ringcaptcha/response'
require 'ringcaptcha/instrumentation'

module Ringcaptcha
  module APIStub
    def self.call(api_key, app_key, path, params = {})
      Instrumentation.with_instrumentation(path, params) do
        call_ringcaptcha(api_key, app_key, path, params = {})
      end
    end

    def self.call_ringcaptcha(api_key, app_key, path, params = {})
      root = path.match(/^[^\/]*/).to_s

      parsed_json =
        case root
        when 'captcha'
          {
            site:          "po1e9umy6y7esi9aky2a",
            token:         "91f325f373364ec8ee9e3bd4f251e0b19d3905f9",
            type:          "SMS",
            lang:          nil,
            country:       "GB",
            server:        "\/\/api.ringcaptcha.com\/",
            status:        "NEW",
            attempt:       0,
            geolocation:   1,
            message:       null,
            expires_in:    900,
            features:      "GSICVD",
            countries:     "",
            retry_in:      0,
            support_email: "foo@bar.com"
          }
        when 'code'
          {
            status:     "SUCCESS",
            token:      "XXXXYYYYZZZZAAAABBBB",
            id:         "UUUUUUUUUUUUUUU",
            phone:      "+1234567890",
            service:    "SMS",
            retry_in:   60,
            expires_in: 900
          }
        when 'normalize'
          {
            status:     "SUCCESS",
            phone:      "+1234567890",
            country:    "US",
            area:       "234",
            block:      "567",
            subscriber: "890",
            type:       "MOBILE"
          }
        when 'verify'
          {
            status:       "SUCCESS",
            id:           "UUUUUUUUUUUUUUU",
            phone:        "+1234567890",
            geolocation:  0,
            phone_type:   "MOBILE",
            carrier:      "AT&T",
            threat_level: "LOW"
          }
        else
          raise 'I don\'t know how to stub this path'
        end

      return Response.new(parsed_json)
    end
  end
end
