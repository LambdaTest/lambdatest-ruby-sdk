
module Lambdatest
  module Sdk
    module Utils
      def self.get_pkg_name
        "@lambdatest/lambdatest-sdk-utils".freeze
      end

      def self.get_smart_ui_server_address
        # Check if SMARTUI_SERVER_ADDRESS is set in the environment, otherwise default to localhost:49152
        ENV.fetch('SMARTUI_SERVER_ADDRESS', 'http://localhost:49152')
      end
    end
  end
end
