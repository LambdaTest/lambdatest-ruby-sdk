
module Lambdatest
    module Sdk
      module Utils
        def self.get_pkg_name
          "@lambdatest/lambdatest-sdk-utils".freeze
        end
  
        def self.get_smart_ui_server_address
          unless ENV.fetch('SMARTUI_SERVER_ADDRESS')
            raise 'SmartUI server address not found'
          end
          ENV.fetch('SMARTUI_SERVER_ADDRESS')
        end
      end
    end
  end
    