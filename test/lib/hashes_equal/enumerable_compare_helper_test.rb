# frozen_string_literal: true

require 'test_helper'
require 'hashes_equal/enumerable_compare_helper'

class EnumerableCompareHelperTest < Minitest::Test
  include HashesEqual::EnumerableCompareHelper

  def test_raises_if_expectation_is_not_a_hash
    assert_raises enum_diff_displayer_klass::ExpectationMustBeEnumerable do
      assert_enumerable_equal(
        '',
        {}
      )
    end
  end

  def test_raises_if_actual_value_is_not_a_hash
    assert_raises enum_diff_displayer_klass::ActualValueMustBeEnumerable do
      assert_enumerable_equal(
        {},
        ''
      )
    end
  end

  def test_missing_key
    @expected_enum = { a: 1 }
    @actual_enum = {}

    assert_enumerable_mismatch(
      message: missing_value_message('a', 1)
    )
  end

  def test_compare_arrays_missing_key
    @expected_enum = ('a'..'e').to_a
    @actual_enum = %w[a b c d]

    assert_enumerable_mismatch(
      message: missing_value_message('[4]', 'e')
    )
  end

  THEORETICAL_BEATLES = [
    { firstname: 'John', lastname: 'Lennon' },
    { firstname: 'Paul', lastname: 'McCartney' },
    { firstname: 'Ringo', lastname: 'Starr' },
    { firstname: 'George', lastname: 'Harrison' }
  ].freeze

  ALTERNATIVE_BEATLES = [
    { firstname: 'John', lastname: 'Lennon' },
    { firstname: 'Paul', lastname: 'McCartney' },
    { firstname: 'Ringo', lastname: 'Starr' },
    { firstname: 'George', lastname: 'Harrison' }
  ].freeze

  # rubocop:disable Metrics/MethodLength
  def test_disagreement_in_arrays
    expected_beatles = THEORETICAL_BEATLES
    actual_beatles = ALTERNATIVE_BEATLES

    begin
      assert_enumerable_equal(
        expected_beatles,
        actual_beatles
      )
    rescue Minitest::Assertion => e
      assert_equal(
        "-#{expected_beatles}",
        e.message.split("\n").last(2).first
      )
      assert_equal(
        "+#{actual_beatles}",
        e.message.split("\n").last
      )
    end
  end
  # rubocop:enable Metrics/MethodLength

  def test_missing_key_non_verbose
    @expected_enum = { a: 1 }
    @actual_enum = {}

    error = assert_raises Minitest::Assertion do
      assert_enumerable_equal(
        expected_enum,
        actual_enum,
        verbose: false
      )
    end
    assert_equal(
      ANSI.white { "\n" + missing_value_message('a', 1) },
      error.message
    )
  end

  def test_spurious_key
    @expected_enum = {}
    @actual_enum = { a: 1 }
    assert_enumerable_mismatch(
      message: spurious_value_message('a', 1)
    )
  end

  def test_compare_arrays_spurious_key
    @expected_enum = ('a'..'d').to_a
    @actual_enum = ('a'..'e').to_a

    assert_enumerable_mismatch(
      message: spurious_value_message('[4]', 'e')
    )
  end

  def test_disagreement
    @expected_enum = { a: 0 }
    @actual_enum = { a: 1 }
    assert_enumerable_mismatch(
      message: value_disagreement_message('a', 0, 1)
    )
  end

  ######################################################
  # We would probably prefer to get to a disagreement
  # but this what we get from Hashdiff
  # Let us see if this is fixable within Hashdiff
  # https://github.com/liufengyun/hashdiff/issues/81
  # and if not consider fixing it in the present gem
  def test_compare_arrays_disagreement
    @expected_enum = ('a'..'e').to_a
    @actual_enum = ('a'..'d').to_a + ['z']

    assert_enumerable_mismatch(
      message: [
        missing_value_message('[4]', 'e'),
        spurious_value_message('[4]', 'z')
      ].join("\n")
    )
  end
  #########################################################

  def test_both_spurious_and_missing_key
    @expected_enum = { a: 1 }
    @actual_enum = { b: 2 }
    assert_enumerable_mismatch(
      message: [
        missing_value_message('a', 1),
        spurious_value_message('b', 2)
      ].join("\n")
    )
  end

  def test_both_spurious_and_disagreement
    @expected_enum = { a: 1 }
    @actual_enum = { a: 0, b: 2 }
    assert_enumerable_mismatch(
      message: [
        value_disagreement_message('a', 1, 0),
        spurious_value_message('b', 2)
      ].join("\n")
    )
  end

  def test_both_missing_and_disagreement
    @expected_enum = { a: 0, b: 1 }
    @actual_enum = { a: 2 }
    assert_enumerable_mismatch(
      message: [
        missing_value_message('b', 1),
        value_disagreement_message('a', 0, 2)
      ].join("\n")
    )
  end

  def test_match
    @expected_enum = { a: 0, b: 1 }
    @actual_enum = { a: 0, b: 1 }

    assert_hashes_match
  end

  def test_deep_match
    @expected_enum = {
      a: 0,
      b: {
        c: {
          d: 1
        }
      }
    }
    @actual_enum = @expected_enum.dup

    assert_hashes_match
  end

  def test_disagreement_in_the_deep
    @expected_enum = {
      a: { b: 1, c: 2 }
    }
    @actual_enum = {
      a: { b: 1, c: 3 }
    }
    assert_enumerable_mismatch(
      message: value_disagreement_message('a.c', 2, 3)
    )
  end

  private

  attr_reader :expected_enum, :actual_enum, :actual_diff

  def enum_diff_displayer_klass
    HashesEqual::EnumerableDiffDisplayer
  end

  def assert_enumerable_mismatch(message:)
    assert_enumerable_equal(
      expected_enum,
      actual_enum
    )
  rescue Minitest::Assertion => e
    assert_equal(
      (ANSI.white { "\n" + message } + '.').split("\n"),
      e.message.split("\n")[0..-3]
    )
  end

  def assert_hashes_match
    assert_enumerable_equal(
      expected_enum,
      actual_enum
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
    @actual_diff = assert_enumerable_equal(
      expected_enum,
      actual_enum
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
