$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "rspec/trailblazer"

include RSpec::Trailblazer::Reform::Matchers

# Load the rails application
require "active_model/railtie"

Bundler.require

module Dummy
  class Application < Rails::Application
    config.eager_load = false
    config.active_support.deprecation = :stderr
  end
end

# Initialize the rails application
Dummy::Application.initialize!

require "active_record"
class Artist < ActiveRecord::Base
end

class Song < ActiveRecord::Base
  belongs_to :artist
end

class Album < ActiveRecord::Base
  has_many :songs
end

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
                                        :database => ":memory:"
ActiveRecord::Schema.verbose = false
load "#{File.dirname(__FILE__)}/support/schema.rb"

require "reform/form/dry"
class DryVForm < Reform::Form
  feature Reform::Form::Dry
end

class RailsForm < Reform::Form
  feature ActiveModel::Validations
end
