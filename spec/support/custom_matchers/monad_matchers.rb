# frozen_string_literal: true

# For everything successful we can match it's value
RSpec::Matchers.define :hold do |expected|
  match do |actual|
    return false unless actual.success?

    expect(actual.value!.inspect).to eq expected.inspect
  end
  failure_message { |actual| "expected that #{actual} would be successful and contain an #{expected}" }
  diffable
end

RSpec::Matchers.define :cause do |expected|
  match do |actual|
    return false unless actual.failure?

    expect(actual.failure).to eq expected
  end
  failure_message { |actual| "expected that #{actual} would be failed and contain an #{expected}" }
end

RSpec::Matchers.define :be_failed do |_expected|
  match { |actual| expect(actual).to be_a Dry::Monads::Result::Failure }
  failure_message { |actual| "expected FAILURE instead #{actual}" }
end

RSpec::Matchers.define :be_successful do |_expected|
  match { |actual| expect(actual).to be_a Dry::Monads::Result::Success }
  failure_message { |actual| "expected SUCCESS instead #{actual}" }
end
