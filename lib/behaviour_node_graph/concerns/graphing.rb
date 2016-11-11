module BehaviourNodeGraph
  module Graphing
    def add_node_to_graph(graph)
      unless graph[id]
        new_instructions = Instructions.new
        graph[id] = new_instructions
        yield new_instructions
      end
    end

    private

    def add_children_to_graph(graph, children)
      children.map do |node|
        node.add_to_graph(graph)
        node.id
      end
    end
  end
end
