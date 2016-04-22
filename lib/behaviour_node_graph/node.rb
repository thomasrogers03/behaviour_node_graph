module BehaviourNodeGraph
  module Node
    attr_reader :id

    def initialize(id, *args)
      @id = id
      super(*args)
    end

    def add_to_graph(graph)
      graph[id] = Instructions.new(to_h.merge(id: id, node_type: self.class))
    end
  end
end
