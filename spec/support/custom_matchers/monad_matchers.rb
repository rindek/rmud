# frozen_string_literal: true

# For everything successful we can match it's value
RSpec::Matchers.define :hold do |expected|
  match do |actual|
    return false unless actual.success?

    expect(actual.value!.inspect).to eq expected.inspect
  end
  failure_message do |actual|
    "expected that #{actual} would be successful and contain an #{expected}"
  end
  diffable
end

RSpec::Matchers.define :cause do |expected|
  match do |actual|
    return false unless actual.failure?

    expect(actual.failure).to eq expected
  end
  failure_message do |actual|
    "expected that #{actual} would be failed and contain an #{expected}"
  end
end

RSpec::Matchers.define :be_failed do |_expected|
  match do |actual|
    expect(actual).to be_a Dry::Monads::Result::Failure
  end
  failure_message do |actual|
    "expected FAILURE instead #{actual}"
  end
end

RSpec::Matchers.define :be_successful do |_expected|
  match do |actual|
    expect(actual).to be_a Dry::Monads::Result::Success
  end
  failure_message do |actual|
    "expected SUCCESS instead #{actual}"
  end
end
