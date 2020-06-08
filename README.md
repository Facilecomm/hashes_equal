# HashesEqual

Provides a MiniTest style assertion `assert_hashes_equal` allowing you to compare two hashes (Hash), with an output that is a bit friendlier on the eye, than what you would get with an `assert_equal`. This is typically useful if you dislike spending time looking for a small difference between two large hashes.

```ruby
require 'hashes_equal/hash_compare_helper'

class HashCompareHelperTest < Minitest::Test
  include HashesEqual::HashCompareHelper

  def test_disagreement_in_the_deep
    expected_hash = {
      a: {
        b: 1,
        c: 2
      }
    }
    actual_hash = {
      a: {
        b: 1,
        c: 3
      }
    }
    assert_hashes_equal(
      expected_hash,
      actual_hash
    )
  end
end
```
```bash
  test_disagreement_in_the_deep                                 FAIL (0.00s)
        
        values for a.c differ
        	expected: 2
        	actual: 3.
        Expected: {:a=>{:b=>1, :c=>2}}
          Actual: {:a=>{:b=>1, :c=>3}}
        hashes_equal/lib/hashes_equal/hash_compare_helper.rb:13:in `assert_hashes_equal'
```

Underneath, [Hashdiff](https://github.com/liufengyun/hashdiff) is used to perform the comparison.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hashes_equal'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install hashes_equal

## Usage

```ruby
require 'hashes_equal/hash_compare_helper'

class HashCompareHelperTest < Minitest::Test
  include HashesEqual::HashCompareHelper

  def test_disagreement_in_the_deep
    expected_hash = {
      a: {
        b: 1,
        c: 2
      }
    }
    actual_hash = {
      a: {
        b: 1,
        c: 3
      }
    }
    assert_hashes_equal(
      expected_hash,
      actual_hash
    )
  end
end
```
```bash
  test_disagreement_in_the_deep                                 FAIL (0.00s)
        
        values for a.c differ
        	expected: 2
        	actual: 3.
        Expected: {:a=>{:b=>1, :c=>2}}
          Actual: {:a=>{:b=>1, :c=>3}}
        hashes_equal/lib/hashes_equal/hash_compare_helper.rb:13:in `assert_hashes_equal'
```

## Development

Run `bundle exec rake test` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Facilecomm/hashes_equal. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/hashes_equal/blob/master/CODE_OF_CONDUCT.md).

## Credit
Original idea and initial version of the code by [Robert Dober](https://github.com/RobertDober).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the HashesEqual project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Facilecomm/hashes_equal/blob/master/CODE_OF_CONDUCT.md).
