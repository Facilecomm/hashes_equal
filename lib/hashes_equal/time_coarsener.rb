# frozen_string_literal: true

require 'ansi'
require 'assertable'
require 'hashdiff'

module HashesEqual
  class TimeCoarsener
    include Assertable

    class InvalidTimeGranularity < ArgumentError; end

    VALID_TIME_GRANULARITY = %i[
      sec
      usec
    ].freeze

    def initialize(time_granularity)
      @time_granularity = time_granularity
      assert_send :time_granularity
      check_valid_granularity_for_time_aware_comparison
    end

    # Either an enumerable or a Time object
    def call(object_to_convert)
      @object_to_convert = object_to_convert
      assert_send :object_to_convert

      convert_object(object_to_convert)
    end

    private

    attr_reader :object_to_convert, :time_granularity

    def convert_object(object)
      return convert_hash(object) if object.is_a?(Hash)
      return convert_enumerable(object) if object.is_a?(Enumerable)
      return convert_time(object) if object.is_a?(Time)

      object
    end

    def convert_hash(hash_to_convert)
      hash_to_convert.transform_values do |value|
        convert_object(value)
      end
    end

    def convert_enumerable(enumerable_to_convert)
      enumerable_to_convert.map do |value|
        convert_object value
      end
    end

    def convert_time(time_to_convert)
      send(coarsening_method_name, time_to_convert)
    end

    def coarsen_to_sec(time_to_convert)
      Time.at(
        time_to_convert.to_i
      )
    end

    def coarsen_to_usec(time_to_convert)
      Time.at(
        time_to_convert.to_i, time_to_convert.usec, :usec
      )
    end

    def coarsening_method_name
      "coarsen_to_#{time_granularity}"
    end

    def check_valid_granularity_for_time_aware_comparison
      return if VALID_TIME_GRANULARITY.include?(time_granularity.to_sym)

      raise(
        InvalidTimeGranularity,
        [
          "#{time_granularity.inspect} is not a valid time_granularity.",
          "Valid values are: #{VALID_TIME_GRANULARITY.inspect}"
        ].join(' ')
      )
    end
  end
end
