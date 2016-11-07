module BehaviourNodeGraph
  module Graphing
    def add_node_to_graph(graph)
      unless graph[id]
        new_instructions = Instructions.new
        graph[id] = new_instructions
        yield new_instructions
      end
    end
  end
end
