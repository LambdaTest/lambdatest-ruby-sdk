# frozen_string_literal: true

require_relative "lib/lambdatest/selenium/driver/version"

# Brand switch: by default this builds lambdatest-selenium-driver exactly as before.
# Build with BRAND=testmuai to produce the same gem as testmuai-selenium-driver.
# Only the gem name and listing metadata change; the code and require paths stay the same.
brand = ENV.fetch("BRAND", "lambdatest").downcase
raise ArgumentError, "Unknown BRAND '#{brand}'. Use lambdatest (default) or testmuai." unless %w[lambdatest testmuai].include?(brand)
testmuai = brand == "testmuai"

Gem::Specification.new do |spec|
  spec.name = testmuai ? "testmuai-selenium-driver" : "lambdatest-selenium-driver"
  spec.version = Lambdatest::Selenium::Driver::VERSION
  spec.authors = testmuai ? ["TestMu AI"] : ["LambdaTest"]
  spec.email = ["key@lambdatest.com"]

  spec.summary = testmuai ? "TestMu AI (formerly LambdaTest) SmartUI Selenium driver for Ruby" : "Ruby Selenium Driver"
  spec.description = testmuai ? "TestMu AI (formerly LambdaTest) SmartUI Selenium driver for Ruby. Same SDK as lambdatest-selenium-driver." : "Ruby Selenium SDK for testing with Smart UI"
  spec.homepage = testmuai ? "https://www.testmuai.com" : "https://www.lambdatest.com"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/LambdaTest/lambdatest-ruby-sdk"
  spec.metadata["changelog_uri"] = "https://github.com/LambdaTest/lambdatest-ruby-sdk/lambdatest-selenium-driver/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[sig/ bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency testmuai ? 'testmuai-sdk-utils' : 'lambdatest-sdk-utils', '>= 1.0.2'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
