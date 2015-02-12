require 'ringcaptcha/api'
require 'ringcaptcha/api_stub'

#
# Ringcaptcha API Integration
#
# see https://bitbucket.org/ringcaptcha/ringcaptcha-docs/src/437ce808904ad6879c31399cfb8e3c8aee9d91d0/api/

module Ringcaptcha
  class << self
    attr_accessor :app_key, :api_key, :secret_key
  end

  # returns {status: "SUCCESS",phone: "+XXXXXXXXX",country: "XX",area: "XX",block: "XXXX",subscriber: "XXXX"}
  def self.normalize(phone, app_key: @app_key)
    check_keys!(app_key: app_key)
    return api('normalize', phone: phone)
  end

  def self.captcha(locale: 'en_us', app_key: @app_key)
    check_keys!(app_key: app_key)
    return api(app_key, 'captcha', locale: locale)
  end

  def self.code(phone, token: nil, locale: 'en_us', service: 'sms', app_key: @app_key)
    check_keys!(app_key: app_key)

    params = {
      phone: phone,
      token: token,
      locale: locale
    }.delete_if { |k, v| v.nil? }

    return api(app_key, "code/#{service}", params)
  end

  def self.verify(token, code, app_key: @app_key)
    check_keys!(app_key: app_key)
    return api(app_key, 'verify', token: token, code: code)
  end

  def self.check_keys!(app_key: @app_key)
    raise "please set Ringcaptcha.api_key and Ringcaptcha.app_key" if app_key.blank? || @api_key.blank?
  end
end
