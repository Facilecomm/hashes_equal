# frozen_string_literal: true

require 'test_helper'

class SboTestAssertionsHashDiffDisplayerTest < Minitest::Test
  def test_raises_if_expectation_is_not_a_hash
    assert_raises HashDiffDisplayer::ExpectationMustBeHash do
      HashDiffDisplayer.new(
        expected: '',
        actual: {}
      )
    end
  end

  # test 'raises if actual value is not a Hash' do
  #   assert_raises HashDiffDisplayer::ActualValueMustBeAHash do
  #     HashDiffDisplayer.new(
  #       expected: {},
  #       actual: ''
  #     )
  #   end
  # end

  # test 'missing key' do
  #   @expected_hash = { a: 1 }
  #   @actual_hash = {}
  #   assert_displayable_diff(
  #     missing_value_message('a', 1)
  #   )
  # end

  # test 'spurious key' do
  #   @expected_hash = {}
  #   @actual_hash = { a: 1 }
  #   assert_displayable_diff(
  #     spurious_value_message('a', 1)
  #   )
  # end

  # test 'disagreement' do
  #   @expected_hash = { a: 0 }
  #   @actual_hash = { a: 1 }
  #   assert_displayable_diff(
  #     value_disagreement_message('a', 0, 1)
  #   )
  # end

  # test 'both spurious and missing key' do
  #   @expected_hash = { a: 1 }
  #   @actual_hash = { b: 2 }
  #   assert_displayable_diff(
  #     [
  #       missing_value_message('a', 1),
  #       spurious_value_message('b', 2)
  #     ].join("\n")
  #   )
  # end

  # test 'both spurious and disagreement' do
  #   @expected_hash = { a: 1 }
  #   @actual_hash = { a: 0, b: 2 }
  #   assert_displayable_diff(
  #     [
  #       value_disagreement_message('a', 1, 0),
  #       spurious_value_message('b', 2)
  #     ].join("\n")
  #   )
  # end

  # test 'both missing and disagreement' do
  #   @expected_hash = { a: 0, b: 1 }
  #   @actual_hash = { a: 2 }
  #   assert_displayable_diff(
  #     [
  #       missing_value_message('b', 1),
  #       value_disagreement_message('a', 0, 2)
  #     ].join("\n")
  #   )
  # end

  # test 'raises if hash diff uses unexpected operator' do
  #   @expected_hash = { a: 0, b: 1 }
  #   @actual_hash = { a: 2 }
  #   diff_displayer = HashDiffDisplayer.new(
  #     expected: expected_hash,
  #     actual: actual_hash
  #   )
  #   # '*' is not a valid Hashdiff operator
  #   diff_displayer.stubs(
  #     perform_diff_computation: [['*', 'b', 1]]
  #   )
  #   error = assert_raises HashDiffDisplayer::UnprocessableHashdiff do
  #     diff_displayer.call
  #   end
  #   assert_equal(
  #     '["*", "b", 1]',
  #     error.message
  #   )
  # end

  private

  attr_reader :expected_hash, :actual_hash, :actual_diff

  def assert_displayable_diff(expected_diff)
    compute_diff
    assert_equal(
      ANSI.white { "\n" + expected_diff },
      actual_diff
    )
  end

  def compute_diff
    @actual_diff = HashDiffDisplayer.new(
      expected: expected_hash,
      actual: actual_hash
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
