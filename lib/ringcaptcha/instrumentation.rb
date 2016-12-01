require 'active_support'

module Ringcaptcha
  module Instrumentation
    def self.with_instrumentation(path, params)
      if Ringcaptcha.use_instrumentation
        instrument(path, params) do
          yield
        end
      else
        yield
      end
    end

    private

    # Adds ActiveSupport notification support to allow you to subscribe to these messages and print
    # more customized log messages
    #
    # Examples
    #
    #   ActiveSupport::Notifications.subscribe('request.ringcaptcha') do |name, starts, ends, _, data|
    #     ringcaptcha_path = data[:path]
    #     ringcaptcha_body = data[:response_values]
    #     duration = ends - starts
    #     # Your log message
    #   end
    def self.instrument(path, params)
      data = {
          path: path,
          params: params
      }

      ActiveSupport::Notifications.instrument('request.ringcaptcha', data) do
        begin
          data[:response_values] = yield
        rescue => exception
          # Note with ActiveSupport 5.0 this is not needed, as the whole exception object is added by default to the data:
          # http://api.rubyonrails.org/v5.0.0.1/classes/ActiveSupport/Notifications/Instrumenter.html#method-i-instrument
          data[:error] = exception
          raise exception
        end
      end
    end
  end
end