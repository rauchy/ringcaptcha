require 'json'

module Ringcaptcha
  module APIStub
    def self.call(app_key, path, params = {})
      path = path[0...path.index('/')]

      parsed_json =
        case path
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
        end

      return Response.new(parsed_json)
    end
  end
end
