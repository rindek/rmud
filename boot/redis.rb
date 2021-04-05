# frozen_string_literal: true
App.boot(:redis) do |app|
  start do
    use :bundler

    register(:redis, Redis.new(host: App[:settings].redis_host))
  end
end
