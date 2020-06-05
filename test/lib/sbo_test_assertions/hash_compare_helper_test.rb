# frozen_string_literal: true

require 'test_helper'
require 'sbo_test_assertions/hash_compare_helper'

class HashCompareHelperTest < Minitest::Test
  include SboTestAssertions::HashCompareHelper

  def test_raises_if_expectation_is_not_a_hash
    assert_raises SboTestAssertions::HashDiffDisplayer::ExpectationMustBeHash do
      assert_hashes_equal(
        '',
        {}
      )
    end
  end

  def test_raises_if_actual_value_is_not_a_hash
    assert_raises SboTestAssertions::HashDiffDisplayer::ActualValueMustBeAHash do
      assert_hashes_equal(
        {},
        ''
      )
    end
  end

  def test_missing_key
    @expected_hash = { a: 1 }
    @actual_hash = {}

    assert_hashes_mismatch(
      message: missing_value_message('a', 1)
    )
  end

  def test_spurious_key
    @expected_hash = {}
    @actual_hash = { a: 1 }
    assert_hashes_mismatch(
      message: spurious_value_message('a', 1)
    )
  end

  def test_disagreement
    @expected_hash = { a: 0 }
    @actual_hash = { a: 1 }
    assert_hashes_mismatch(
      message: value_disagreement_message('a', 0, 1)
    )
  end

  def test_both_spurious_and_missing_key
    @expected_hash = { a: 1 }
    @actual_hash = { b: 2 }
    assert_hashes_mismatch(
      message: [
        missing_value_message('a', 1),
        spurious_value_message('b', 2)
      ].join("\n")
    )
  end

  def test_both_spurious_and_disagreement
    @expected_hash = { a: 1 }
    @actual_hash = { a: 0, b: 2 }
    assert_hashes_mismatch(
      message: [
        value_disagreement_message('a', 1, 0),
        spurious_value_message('b', 2)
      ].join("\n")
    )
  end

  def test_both_missing_and_disagreement
    @expected_hash = { a: 0, b: 1 }
    @actual_hash = { a: 2 }
    assert_hashes_mismatch(
      message: [
        missing_value_message('b', 1),
        value_disagreement_message('a', 0, 2)
      ].join("\n")
    )
  end

  private

  attr_reader :expected_hash, :actual_hash, :actual_diff

  def assert_hashes_mismatch(message:)
    assert_hashes_equal(
      expected_hash,
      actual_hash
    )
  rescue Minitest::Assertion => e
    assert_equal(
      (ANSI.white { "\n" + message } + '.').split("\n"),
      e.message.split("\n")[0..-3]
    )
  end

  def assert_hashes_match
    assert_hashes_equal(
      expected_hash,
      actual_hash
    )
  end

  def assert_displayable_diff(expected_diff)
    compute_diff
    assert_equal(
      ANSI.white { "\n" + expected_diff },
      actual_diff
    )
  end

  def compute_diff
    @actual_diff = assert_hashes_equal(
      expected_hash,
      actual_hash
    ).call
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
