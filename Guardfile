# frozen_string_literal: true

require 'byebug'

# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# Uncomment and set this to only include directories you want to watch
def check_dir_existence(dir)
  return dir if Dir.exist?(dir)

  UI.warning("Directory #{dir} does not exist")
  false
end

directories(
  %w[lib test].select do |dir|
    check_dir_existence(dir)
  end
)

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

guard :minitest, all_on_start: false do
  # with Minitest::Unit
  watch(%r{^test/(.*)/?test_(.*)\.rb$})
  watch(%r{^test/(.*)/?(.*)_test\.rb$})
  watch(%r{^lib/(.*/)?([^/]+)\.rb$}) { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r{^lib/(.+)\.rb$}) { |m| "test/lib/#{m[1]}_test.rb" }
  watch(%r{^test/test_helper\.rb$}) { 'test' }

  # Rails 4
  watch(%r{^lib/(.+)\.rb$}) do |m|
    "test/lib/#{m[1]}_test.rb"
  end
  watch(%r{^test/.+_test\.rb$})
  # watch(%r{^test/test_helper\.rb$}) { 'test' }
end
