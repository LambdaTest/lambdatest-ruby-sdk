# frozen_string_literal: true
require "lambdatest/sdk/utils"

module Lambdatest
  module Selenium
    module Driver
      @logger = Lambdatest::Sdk::Utils.get_logger
      
      def self.smartui_snapshot(driver , snapshot_name, options = {})
        begin
          if snapshot_name.nil? || snapshot_name.empty?
            raise StandardError, "The `snapshotName` argument is required."
          end
  
          if driver.nil?
            raise StandardError, "The `driver` argument is required."
          end

          if !Lambdatest::Sdk::Utils.is_smartui_enabled?
            raise StandardError, "SmartUI Server is not enabled."
          end

          response = JSON.parse(Lambdatest::Sdk::Utils.fetch_dom_serializer)
          driver.execute_script(response["data"]["dom"])

          # Serialize and capture the DOM
          snapshot = driver.execute_script("return {
             'dom' : SmartUIDOM.serialize(#{options.to_json}),
             'url' : document.URL
            }")

          # Post the dom to smartui endpoint
          snapshot['name'] = snapshot_name
          snapshot_reponse = Lambdatest::Sdk::Utils.post_snapshot(snapshot,options)

          @logger.info("Snapshot captured #{snapshot_name}")

          res = JSON.parse(snapshot_reponse)
          if res && res['data'] && res['data']['warnings'] && res['data']['warnings'].length != 0
            res['data']['warnings'].each do |warning|
              @logger.warn(warning)
            end
          end
        rescue => exception
          @logger.error("Could not take snapshot #{snapshot_name} error #{exception.message}") 
        end
      end
    end
  end
end