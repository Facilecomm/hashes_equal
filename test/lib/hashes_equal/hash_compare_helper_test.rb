# frozen_string_literal: true

require 'test_helper'
require 'hashes_equal/hash_compare_helper'

class HashCompareHelperTest < Minitest::Test
  include HashesEqual::HashCompareHelper

  def test_raises_if_expectation_is_not_a_hash
    assert_raises hash_diff_displayer_klass::ExpectationMustBeHash do
      assert_hashes_equal(
        '',
        {}
      )
    end
  end

  def test_raises_if_actual_value_is_not_a_hash
    assert_raises hash_diff_displayer_klass::ActualValueMustBeAHash do
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

  def test_missing_key_non_verbose
    @expected_hash = { a: 1 }
    @actual_hash = {}

    error = assert_raises Minitest::Assertion do
      assert_hashes_equal(
        expected_hash,
        actual_hash,
        verbose: false
      )
    end
    assert_equal(
      ANSI.white { "\n" + missing_value_message('a', 1) },
      error.message
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

  def test_match
    @expected_hash = { a: 0, b: 1 }
    @actual_hash = { a: 0, b: 1 }

    assert_hashes_match
  end

  def test_deep_match
    @expected_hash = {
      a: 0,
      b: {
        c: {
          d: 1
        }
      }
    }
    @actual_hash = @expected_hash.dup

    assert_hashes_match
  end

  def test_disagreement_in_the_deep
    @expected_hash = {
      a: { b: 1, c: 2 }
    }
    @actual_hash = {
      a: { b: 1, c: 3 }
    }
    assert_hashes_mismatch(
      message: value_disagreement_message('a.c', 2, 3)
    )
  end

  def test_plain_disagreement
    @expected_hash = { a: 0 }
    @actual_hash = { a: 1 }
    assert_hashes_mismatch(
      message: value_disagreement_message('a', 0, 1)
    )
  end

  def test_approximate_match
    @expected_hash = { a: 0, b: 1 }
    @actual_hash = { a: 0, b: 1.00000001 }

    assert_hashes_almost_match
  end

  def test_approximate_match_with_specific_tolerance
    @expected_hash = { a: 0, b: 1 }
    @actual_hash = { a: 0, b: 1.00001 }

    assert_hashes_almost_match(tolerance: 0.001)
  end

  def test_approximate_mismatch_above_tolerance
    @expected_hash = { a: 0, b: 1 }
    @actual_hash = { a: 0, b: 1.1 }

    refute_approximate_match(
      tolerance: 0.001,
      message: value_disagreement_message(:b, 1, 1.1)
    )
  end

  def test_tolerance_must_be_a_numeric_value
    @expected_hash = { a: 0, b: 1 }
    @actual_hash = { a: 0, b: 1.1 }

    assert_raises invalid_tolerance_error do
      assert_hashes_almost_equal(
        expected_hash,
        actual_hash,
        tolerance: 'not_a_number_at_all'
      )
    end
  end

  def test_tolerance_must_be_non_negative
    @expected_hash = { a: 0, b: 1 }
    @actual_hash = { a: 0, b: 1.1 }

    assert_raises invalid_tolerance_error do
      assert_hashes_almost_equal(
        expected_hash,
        actual_hash,
        tolerance: -0.00001
      )
    end
  end

  def test_rounded_match
    @expected_hash = { a: 0, b: 1 }
    @actual_hash = { a: 0, b: 0.99999999 }

    assert_rounded_hashes_match(precision: 4)
  end

  def test_rounded_mismatch
    @expected_hash = { a: 0, b: 1 }
    @actual_hash = { a: 0, b: 1.1 }

    refute_rounded_match(
      precision: 4,
      message: value_disagreement_message(:b, 1, 1.1)
    )
  end

  def test_precision_must_be_an_integer
    @expected_hash = { a: 0, b: 1 }
    @actual_hash = { a: 0, b: 0.99999999 }

    assert_raises invalid_precision_error do
      assert_rounded_hashes_match(precision: 'not_a_number_at_all')
    end
  end

  def test_precision_must_be_non_negative
    @expected_hash = { a: 0, b: 1 }
    @actual_hash = { a: 0, b: 0.99999999 }

    assert_raises invalid_precision_error do
      assert_rounded_hashes_match(precision: -1)
    end
  end

  def test_rounded_match_with_zero_precision
    @expected_hash = { a: 0, b: 1 }
    @actual_hash = { a: 0, b: 1.1 }

    assert_rounded_hashes_match(precision: 0)
  end

  def test_rounded_mismatch_with_precision_one
    @expected_hash = { a: 0, b: 1 }
    @actual_hash = { a: 0, b: 1.1 }

    refute_rounded_match(
      precision: 1,
      message: value_disagreement_message(:b, 1, 1.1)
    )
  end

  private

  attr_reader :expected_hash, :actual_hash, :actual_diff

  def invalid_tolerance_error
    approx_hash_diff_displayer_klass::ToleranceMustBeNonNegativeNumeric
  end

  def invalid_precision_error
    rounded_hash_diff_displayer_klass::PrecisionMustBeNonNegativeInteger
  end

  def hash_diff_displayer_klass
    HashesEqual::HashDiffDisplayer
  end

  def approx_hash_diff_displayer_klass
    HashesEqual::HashAlmostDiffDisplayer
  end

  def rounded_hash_diff_displayer_klass
    HashesEqual::HashRoundedDiffDisplayer
  end

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

  def assert_hashes_almost_match(tolerance: 0.0001)
    assert_hashes_almost_equal(
      expected_hash,
      actual_hash,
      tolerance: tolerance
    )
  end

  def assert_rounded_hashes_match(precision: 4)
    assert_rounded_hashes_equal(
      expected_hash,
      actual_hash,
      precision: precision
    )
  end

  def refute_approximate_match(message:, tolerance: 0.0001)
    assert_hashes_almost_match(
      tolerance: tolerance
    )
  rescue Minitest::Assertion => e
    assert_equal(
      ansi_format_message(message).split("\n"),
      e.message.split("\n")[0..3]
    )
  end

  def refute_rounded_match(message:, precision: 4)
    assert_rounded_hashes_match(
      precision: precision
    )
  rescue Minitest::Assertion => e
    assert_equal(
      ansi_format_message(message).split("\n"),
      e.message.split("\n")[0..3]
    )
  end

  def ansi_format_message(message)
    ANSI.white { "\n" + message }
  end

  # def assert_displayable_diff(expected_diff)
  #   compute_diff
  #   assert_equal(
  #     ANSI.white { "\n" + expected_diff },
  #     actual_diff
  #   )
  # end

  # def compute_diff
  #   @actual_diff = assert_hashes_equal(
  #     expected_hash,
  #     actual_hash
  #   ).call
  # end

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
