class WrappingInput
  def initialize(input)
    @input = input || Hash
  end
end

module Timestamps
  class InputWithTimestamp < WrappingInput
    def [](value)
      v = @input[value]
      now = Time.now

      if v[:created_at]
        v.merge(updated_at: now)
      else
        v.merge(created_at: now, updated_at: now)
      end
    end
  end

  module ClassInterface
    def build(relation, options = {})
      super(relation, options.merge(input: InputWithTimestamp.new(input)))
    end
  end

  def self.included(klass)
    super
    klass.extend ClassInterface
  end
end

ROM.plugins do
  adapter :sql do
    register :timestamps, Timestamps, type: :command
  end
end
