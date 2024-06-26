# frozen_string_literal: true

require_relative "lib/simple_fcm/version"

Gem::Specification.new do |spec|
  spec.name = "simple_fcm"
  spec.version = SimpleFCM::VERSION
  spec.authors = ["Chris Gaffney"]
  spec.email = ["chris@collectiveidea.com"]

  spec.summary = "Firebase Cloud Messaging V1 API Client"
  spec.description = <<~DESCRIPTION
    SimpleFCM is a minimal client for sending push notifications using the the
    Firebase Cloud Messaging V1 API.
  DESCRIPTION
  spec.homepage = "https://github.com/deadmanssnitch/simple_fcm"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blog/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end

  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2.0"
  spec.add_dependency "googleauth", "~> 1.0"
end
