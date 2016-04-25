module BehaviourNodeGraph
  class NodeCollection
    attr_reader :id, :children

    def initialize(id, children)
      @id = id
      @children = children
    end

  end
end