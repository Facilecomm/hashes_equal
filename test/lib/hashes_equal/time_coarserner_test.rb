# frozen_string_literal: true

require 'test_helper'
require 'hashes_equal/time_coarsener'

class HashesEqualTimeCoarsernerTest < Minitest::Test
  def test_usec_coarsening_floors_out_nsec_but_keeps_usec
    time = Time.at(1_046_684_800, 123_456_789, :nsec)
    coarsened_time = coarsen_to_usec time

    assert_equal 123_456_789, time.nsec

    assert_equal 123_456, time.usec

    assert_equal 123_456_000, coarsened_time.nsec

    assert_equal 123_456, coarsened_time.usec
  end

  def test_sec_coarsening_floors_out_to_second
    time = Time.at(1_046_684_800, 123_456_789, :nsec)
    coarsened_time = coarsen_to_sec time

    assert_equal 123_456_789, time.nsec

    assert_equal 123_456, time.usec

    assert_equal(
      0,
      coarsened_time.nsec
    )

    assert_equal(
      0,
      coarsened_time.usec
    )
  end

  # rubocop:disable Metrics/AbcSize
  def test_usec_coarsening_floors_out_nsec_but_keeps_usec_with_hash
    time = Time.at(1_046_684_800, 123_456_789, :nsec)
    timed_hash = make_timed_hash time
    coarsened_timed_hash = coarsen_to_usec timed_hash

    assert_equal 123_456_789, time.nsec

    assert_equal 123_456, time.usec

    coarsened_time = coarsened_timed_hash[:donut_baking][:started_at]

    assert_equal 123_456_000, coarsened_time.nsec

    assert_equal 123_456, coarsened_time.usec

    # Other fields are still untouched
    assert_equal 180, coarsened_timed_hash[:donut_baking][:temperature_in_c]
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Metrics/AbcSize
  def test_sec_coarsening_floors_out_to_second_within_hash
    time = Time.at(1_046_684_800, 123_456_789, :nsec)
    timed_hash = make_timed_hash time
    coarsened_timed_hash = coarsen_to_sec timed_hash

    assert_equal 123_456_789, time.nsec

    assert_equal 123_456, time.usec

    coarsened_time = coarsened_timed_hash[:donut_baking][:started_at]

    assert_equal 0, coarsened_time.nsec

    assert_equal 0, coarsened_time.usec

    # Other fields are still untouched
    assert_equal 180, coarsened_timed_hash[:donut_baking][:temperature_in_c]
  end
  # rubocop:enable Metrics/AbcSize

  private

  def make_timed_hash
    {
      donut_baking: {
        started_at: time,
        temperature_in_c: 180
      }
    }
  end

  def coarsen_to_usec(enumerable_or_time)
    HashesEqual::TimeCoarsener.new(:usec).call(enumerable_or_time)
  end

  def coarsen_to_sec(enumerable_or_time)
    HashesEqual::TimeCoarsener.new(:sec).call(enumerable_or_time)
  end
end
