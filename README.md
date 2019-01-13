# Rspec::Trailblazer

RSpec Matchers for Trailblazer

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-trailblazer'
```

And then execute:

    $ bundle

## Configuration

```ruby
# spec_helper.rb
RSpec.configure do |config|
  # Include RSpec::Trailblazer::Operation::Matchers for operation tests
  config.include RSpec::Trailblazer::Operation::Matchers, type: :operation
end
```

## Examples

```ruby
class Post < ActiveRecord::Base
  class Form < Reform::Form
    property :title
    property :description
  end

  class Create < Trailblazer::Operation
    step Policy::Pundit(Post::Policy, :create?)
    failure :log_access_denied, fail_fast: true

    step Model(Post, :new)
    step Contract::Build(constant: Form)
    step Contract::Validate(key: :post)
    step Contract::Persist()

    def log_access_denied(ctx, **)
      ctx[:error_msg] = I18n.t('errors.access_denied')
    end
  end
end
```

```ruby
describe Post::Create, type: :operation do
  # You can define default parameters for an operation using `let(:default_params)`.
  # These values can be overriden by using `with` helper.
  let(:default_params) do
    {
      current_user: create(:admin),
      params: { post: { title: 'First Blog', body: 'With some body' } }
    }
  end

  it 'fails if user is not authorized' do
    expect(described_class).to be_failure.with(current_user: create(:non_admin)) do |result|
      expect(result[:error_msg]).to eq I18n.t('errors.access_denied')
    end
  end

  it 'fails if title is blank' do
    expect(described_class).to be_failure
      .with(params: { post: { title: nil } }).have_invalid_properties(:title)
  end

  it 'is successful' do
    expect(described_class).to be_successful do |result|
      expect(result[:model].title).to eq 'First Blog'
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/trailblazer/rspec-trailblazer.

