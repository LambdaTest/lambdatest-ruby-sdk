# frozen_string_literal: true
require "lambdatest/sdk/utils"

module Lambdatest
  module Selenium
    module Driver
      @pkg_name = "ruby-selenium-driver"
      @logger = Lambdatest::Sdk::Utils.get_logger(pkg_name)
      
      def self.smartui_snapshot(driver , snapshot_name, options = {})
        if snapshot_name.nil? || snapshot_name.empty?
          raise StandardError, "The `snapshotName` argument is required."
        end
  
        if driver.nil?
          raise StandardError, "The `driver` argument is required."
        end

        if !Lambdatest::Sdk::Utils.is_smartui_enabled?
          raise StandardError, "Cannot find SmartUI server."
        end

        begin
          response = JSON.parse(Lambdatest::Sdk::Utils.fetch_dom_serializer)
          driver.execute_script(response["data"]["dom"])

          # Serialize and capture the DOM
          snapshot = driver.execute_script("return {
             'dom' : SmartUIDOM.serialize(#{options.to_json}),
             'url' : document.URL
            }")

          # Post the dom to smartui endpoint
          snapshot['name'] = snapshot_name
          snapshot_reponse = Lambdatest::Sdk::Utils.post_snapshot(snapshot,pkg_name,options)

          res = JSON.parse(snapshot_reponse)
          if res && res['data'] && res['data']['warnings'] && res['data']['warnings'].length != 0
            res['data']['warnings'].each do |warning|
              @logger.warn(warning)
            end
          end

          @logger.info("Snapshot captured #{snapshot_name}")
        rescue => exception
          @logger.error("SmartUI snapshot failed #{snapshot_name}") 
          @logger.error("#{exception.message}") 
        end
      end
    end
  end
end