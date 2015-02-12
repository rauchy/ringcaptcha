require 'ostruct'

module Ringcaptcha
  class Response < OpenStruct
    def error?
      self.status == "ERROR"
    end

    def success?
      self.status == "SUCCESS"
    end
  end
end
