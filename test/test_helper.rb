# frozen_string_literal: true

require 'byebug'

def running_from_guard?
  ARGV == %w[--guard]
end

A_LOT = 500

def many_tests?
  ARGV.count > A_LOT
end

unless running_from_guard?
  require 'simplecov'
  SimpleCov.start do
    enable_coverage :branch
    SimpleCov.minimum_coverage_by_file 100
  end

  SimpleCov.at_exit do
    SimpleCov.result.format!
  end
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'hashes_equal'

require 'minitest/autorun'
require 'byebug'
require 'mocha/minitest'
require 'minitest/reporters'

Mocha.configure do |config|
  config.stubbing_non_existent_method = :prevent
  config.stubbing_method_unnecessarily = :prevent
end

def minitest_reporter_klass_to_use
  return Minitest::Reporters::SpecReporter if running_from_guard?
  return Minitest::Reporters::SpecReporter unless many_tests?

  Minitest::Reporters::ProgressReporter
end

Minitest::Reporters.use!(
  [
    minitest_reporter_klass_to_use.new(color: true)
  ],
  ENV,
  Minitest.backtrace_filter
)
