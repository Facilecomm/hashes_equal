# frozen_string_literal: true

require 'sbo_assertable/assertable'
require 'hashdiff'

module SboTestAssertions
  class HashDiffDisplayer
    include SboAssertable::Assertable

    class ExpectationMustBeHash < ArgumentError; end
    class ActualValueMustBeAHash < ArgumentError; end
    class UnprocessableHashdiff < ArgumentError; end

    def initialize(expected:, actual:)
      @expected = expected
      @actual = actual
      assert_send :expected
      assert_send :actual
      raise ExpectationMustBeHash unless expected.is_a?(Hash)
      raise ActualValueMustBeAHash unless actual.is_a?(Hash)
    end

    def call
      compute_diff
      ANSI.white do
        formatted_diff
      end
    end

    private

    attr_reader :expected, :actual, :diff

    def compute_diff
      @diff = perform_diff_computation
    end

    def perform_diff_computation
      Hashdiff.diff(expected, actual)
    end

    def formatted_diff
      "\n" + diff.map do |diff_element|
        format_element diff_element
      end.join("\n")
    end

    def format_element(diff_element)
      # exp_val is act_val in case of "+"
      type, key, exp_val, act_val = diff_element
      return missing_value_message(key, exp_val) if type == '-'
      return spurious_value_message(key, exp_val) if type == '+'
      return value_disagreement_message(key, exp_val, act_val) if type == '~'

      raise UnprocessableHashdiff, diff_element
    end

    def missing_value_message(key, exp_val)
      [
        "actual value for #{ANSI.red { key }} is missing, expected was",
        ANSI.green { exp_val.inspect }
      ].join("\n\t")
    end

    def spurious_value_message(key, exp_val)
      "spurious value #{ANSI.red { exp_val.inspect }} for #{key} was not expected"
    end

    def value_disagreement_message(key, exp_val, act_val)
      [
        "values for #{key} differ",
        "expected: #{ANSI.green { exp_val.inspect }}",
        "actual: #{ANSI.red { act_val.inspect }}"
      ].join("\n\t")
    end
  end
end
