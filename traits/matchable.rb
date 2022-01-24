module Traits
  module Matchable
    def match?(input)
      all_possibilities.include?(input)
    end

    private

    def all_possibilities
      arr = []

      arr << [self.adjectives + [self.name]].join(" ")

      self.adjectives.each_index do |ind|
        self.adjectives.permutation(ind + 1).each { |perm| arr << [perm + [self.name]].join(" ") }
      end

      arr << self.name
      arr.uniq
    end
  end
end
