
module Lambdatest
    module Sdk
      module Utils
        def self.get_pkg_name
          "@lambdatest/ruby-selenium-driver".freeze
        end
  
        def self.get_smart_ui_server_address
          ENV.fetch('SMARTUI_SERVER_ADDRESS', 'http://localhost:8080')
        end
      end
    end
  end
    