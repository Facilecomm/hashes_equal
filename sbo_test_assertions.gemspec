# frozen_string_literal: true

require_relative 'lib/sbo_test_assertions/version'

Gem::Specification.new do |spec|
  spec.name          = 'sbo_test_assertions'
  spec.version       = SboTestAssertions::VERSION
  spec.authors       = ['Shippingbo']
  spec.email         = ['tech@facilecomm.com']

  spec.summary       = 'Extend MiniTest assertions'
  spec.description   = 'For example: assert_hashes_equal'
  spec.homepage      = 'https://github.com/Facilecomm/sbo_test_assertions'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')

  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files
  # in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'ansi', '~> 1.5'
  spec.add_dependency 'diffy', '~> 3.3' # des idees de genie
  spec.add_dependency 'hashdiff', '~> 1.0', '>= 1.0.1'

  spec.add_development_dependency 'bundler', '~> 2.1', '>= 2.1.4'
  spec.add_development_dependency 'byebug', '~> 11.1'
  spec.add_development_dependency 'guard', '~> 2.16'
  spec.add_development_dependency 'guard-minitest', '~> 2.4'
  spec.add_development_dependency 'minitest', '~> 5.11'
  spec.add_development_dependency 'minitest-reporters', '~> 1.4'
  spec.add_development_dependency 'mocha', '~> 1.11'
  spec.add_development_dependency 'pry', '~> 0.13'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop', '~> 0.85'
  spec.add_development_dependency 'rubocop-performance', '~> 1.5'
  spec.add_development_dependency 'simplecov', '~> 0.18.5'
end
