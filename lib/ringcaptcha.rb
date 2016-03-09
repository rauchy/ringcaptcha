require 'ringcaptcha/api'
require 'ringcaptcha/api_stub'

#
# Ringcaptcha API Integration
#
# see https://bitbucket.org/ringcaptcha/ringcaptcha-docs/src/437ce808904ad6879c31399cfb8e3c8aee9d91d0/api/

module Ringcaptcha
  class << self
    attr_accessor :api_key

    # returns {status: "SUCCESS",phone: "+XXXXXXXXX",country: "XX",area: "XX",block: "XXXX",subscriber: "XXXX"}
    def normalize(app_key, phone)
      return api(app_key).call(@api_key, app_key, 'normalize', phone: phone)
    end

    def captcha(app_key, locale: 'en_us')
      return api(app_key).call(@api_key, app_key, 'captcha', locale: locale)
    end

    def code(app_key, phone, token: nil, locale: 'en_us', service: 'sms')
      params = {
        phone: phone,
        token: token,
        locale: locale
      }.delete_if { |k, v| v.nil? }

      return api(app_key).call(@api_key, app_key, "code/#{service}", params)
    end

    def verify(app_key, token, code)
      return api(app_key).call(@api_key, app_key, 'verify', token: token, code: code)
    end

    def ping
      [Ringcaptcha::API.service_up?, nil]
    rescue StandardError => e
      [false, e]
    end

    private

    def api(app_key)
      raise "please set Ringcaptcha.api_key" if @api_key.blank?

      if app_key.start_with?('test')
        Ringcaptcha::APIStub
      else
        Ringcaptcha::API
      end
    end
  end
end
