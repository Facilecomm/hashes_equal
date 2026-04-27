# frozen_string_literal: true

require 'ansi'
require 'assertable'
require 'hashdiff'

module HashesEqual
  class GenericDiffDisplayer
    include Assertable

    class UnprocessableHashdiff < ArgumentError; end

    def initialize(expected:, actual:, diff_options: {})
      @expected = expected
      @actual = actual
      @diff_options = diff_options
      assert_send :expected
      assert_send :actual
      assert_send :diff_options
      check_args
    end

    def call
      diff # compute it

      ANSI.white do
        formatted_diff
      end
    end

    def diff
      @diff ||= compute_diff
    end

    private

    attr_reader :expected, :actual, :diff_options

    def check_args
      # Add specific checks if needed
    end

    def compute_diff
      perform_diff_computation.tap do |res|
        assert_kind_of Array, res
      end
    end

    def perform_diff_computation
      Hashdiff.diff(expected, actual, diff_options)
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
      [
        "spurious value #{ANSI.red { exp_val.inspect }}",
        "for #{key} was not expected"
      ].join(' ')
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
