module Engine
  module Lib
    class DictionaryLoader < Abstract
      include Import["repos.dict", "containers.dictionary"]

      def load!
        dict.for_each { |entity| dictionary.register(entity.nazwa, memoize: true) { entity } }
      end
    end
  end
end
