# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in sbo_test_assertions.gemspec
gemspec

gem 'minitest', '~> 5.0'
gem 'rake', '~> 12.0'

source 'https://github.com/Facilecomm/sbo_assertable' do
  gem(
    'sbo_assertable',
    git: 'https://github.com/Facilecomm/sbo_assertable',
    require: false,
    ref: '5e732e4b79c81045c80bffdc5ab18e8d906c9f52'
  )
end

group :test do
  gem(
    'sbo_coverage_helper',
    git: 'https://github.com/Facilecomm/sbo_coverage_helper',
    require: false,
    ref: '7ad5214e2c34d9b6b8c29a6a7d6a22caad429db8'
  )
end
