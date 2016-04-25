module BehaviourNodeGraph
  class NodeCollection
    attr_reader :id, :children
    attr_accessor :context

    def initialize(id, children)
      @id = id
      @children = children
    end

  end
end