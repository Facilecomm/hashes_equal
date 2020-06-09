# frozen_string_literal: true

require 'assertable'
require 'hashdiff'
require 'hashes_equal/generic_diff_displayer'

module HashesEqual
  class HashDiffDisplayer < GenericDiffDisplayer
    class ExpectationMustBeHash < ArgumentError; end
    class ActualValueMustBeAHash < ArgumentError; end

    private

    def check_args
      super
      raise ExpectationMustBeHash unless expected.is_a?(Hash)
      raise ActualValueMustBeAHash unless actual.is_a?(Hash)
    end
  end
end
