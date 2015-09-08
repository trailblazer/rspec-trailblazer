# Trailblazer::Rspec

RSpec Matchers for Trailblazer

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'trailblazer-rspec'
```

And then execute:

    $ bundle

## Configuration

```ruby
# spec_helper.rb
RSpec.configure do |config|
  # Include Trailblazer::RSpec::Matchers for operation tests
  config.include Trailblazer::RSpec::Matchers, type: :operation
end
```

## Examples

```ruby
class Post < ActiveRecord::Base
  class Index < Trailblazer::Operation
    include Collection
    include CRUD
    model Post

    def model!(params)
      Post.where(forum_id: params[:forum_id])
    end
  end

  class Show < Trailblazer::Operation
    include CRUD
    model Post

    def model!(params)
      Post.find_by!(forum_id: params[:forum_id], id: params[:id])
    end
  end
end
```

```ruby
RSpec.describe Post::Index, type: :operation do
  it { is_expected.to be_a_trailblazer_operation }
  it { is_expected.to use_model Post }
  it do
    is_expected.to present_model.with_params(forum_id: 1).from_model(Post).wich_receive(:where).with(forum_id: 1)
  end
end

RSpec.describe Post::Show, type: :operation do
  it { is_expected.to be_a_trailblazer_operation }
  it { is_expected.to use_model Post }
  it do
    is_expected.to present_model.with_params(forum_id: 1, id: 11).from_model(Post).wich_receive(:find_by!).with(forum_id: 1, id: 11)
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/trailblazer/trailblazer-rspec.

