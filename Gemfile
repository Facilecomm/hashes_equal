# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in sbo_test_assertions.gemspec
gemspec

gem 'minitest', '~> 5.0'
gem 'rake', '~> 12.0'

group :test do
  gem(
    'sbo_coverage_helper',
    git: 'https://github.com/Facilecomm/sbo_coverage_helper',
    require: false,
    ref: '7ad5214e2c34d9b6b8c29a6a7d6a22caad429db8'
  )
end
