source "https://rubygems.org"

# Specify your gem's dependencies in rspec-trailblazer.gemspec
gemspec

gem "pry"
gem "dry-validation", "< 1.0"
gem "reform", "2.3.0.rc1"
gem "reform-rails", "0.2.0.rc2"

rails_version = ENV.fetch("RAILS_VERSION", "5.2.0")

gem "activerecord", "~> #{rails_version}"
gem "railties", "~> #{rails_version}"
if rails_version.include?("6.0")
  gem "sqlite3", "~> 1.4"
else
  gem "sqlite3", "~> 1.3", "< 1.4"
end
puts "Rails version #{rails_version}"
