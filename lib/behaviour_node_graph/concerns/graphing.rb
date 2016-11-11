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

    def add_next_nodes_to_graph(graph, instructions)
      if next_nodes
        instructions.next_nodes = add_children_to_graph(graph, next_nodes)
      end
    end

    def add_children_to_graph(graph, children)
      children.map do |node|
        node.add_to_graph(graph)
        node.id
      end
    end
  end
end
