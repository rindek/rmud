module Repos
  class Container
    extend Dry::Initializer
    include Dry::Monads[:result, :maybe, :try]

    option :dataset, default: -> { raise "dataset must be set" }
    option :entity, default: -> { raise "entity must be set" }

    def find(id)
      find_by_id(id)
    end

    def all_ids
      dataset._container.keys.sort
    end

    def all(query = nil)
      (query.nil? ? all_ids : search(query)).then { |keys| keys.map { |key| dataset[key] } }
    end

    def first
      find(all_ids.first)
    end

    def search(query)
      dataset._container.keys.select { |key| File.fnmatch(query, key) }
    end

    def create(id:, input:, cache: false, &block)
      dataset.register(id, memoize: cache) do
        created = entity.new(input.merge(id: id))
        block.call(created) if block_given?
        created
      end
    end

    private

    def find_by_id(id)
      Some(dataset[id])
    rescue Dry::Container::Error
      None()
    end
  end
end
