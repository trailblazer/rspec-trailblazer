require 'hashie/extensions/deep_merge'

module RSpec::Trailblazer
  class Hash < ::Hash
    include Hashie::Extensions::DeepMerge
  end
end
