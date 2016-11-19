module BehaviourNodeGraph
  class NodeCollection
    include Graphing
    include ChildNodeExecution
    extend DefaultProperties

    OUTPUT_NODES = [:children].freeze

    attr_reader :id, :children, :context_type
    attr_accessor :context, :executor, :next_nodes

    def self.new_node(children, context_type = Context)
      new(SecureRandom.base64, children, context_type)
    end

    def self.output_nodes
      OUTPUT_NODES
    end

    def initialize(id, children = nil, context_type = Context)
      @id = id
      @children = children
      @context_type = context_type
    end

    def add_to_graph(graph)
      add_node_to_graph(graph) do |instructions|
        instructions.node_type = self.class
        instructions.id = id
        instructions.children = add_children_to_graph(graph, children)
        instructions.context_type = context_type unless context_type == Context
        add_next_nodes_to_graph(graph, instructions)
      end
    end

    def load_from_graph(graph, instructions, node_graph)
      @children = load_children_from_graph(graph, instructions, :children, node_graph)
      @context_type = instructions.context_type if instructions[:context_type]
      load_next_nodes_from_graph(graph, instructions, node_graph)
    end

    def act
      self.context ||= Context.new
      execute_nodes(children)
      execute_nodes(next_nodes)
    end

  end
end
