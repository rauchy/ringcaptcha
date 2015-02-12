require 'json'

module Ringcaptcha
  module APIStub
    def self.api(app_key, path, params = {})
      return Response.new(json.symbolize_keys!)
    end
  end
end
