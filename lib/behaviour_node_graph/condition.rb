module BehaviourNodeGraph
  class Condition
    include Graphing
    include ChildNodeExecution
    extend DefaultProperties

    INPUTS = [:condition].freeze
    OUTPUTS = [].freeze
    OUTPUT_NODES = [:true, :false].freeze

    attr_reader :id, :true_nodes, :false_nodes, :condition_source, :next_nodes
    attr_accessor :context, :executor

    def self.new_node(condition_source, true_nodes, false_nodes)
      new(SecureRandom.base64, condition_source, true_nodes, false_nodes)
    end

    def self.inputs
      INPUTS
    end

    def self.output_nodes
      OUTPUT_NODES
    end

    def initialize(id, condition_source = nil, true_nodes = nil, false_nodes = nil)
      @id = id
      @true_nodes = true_nodes
      @false_nodes = false_nodes
      @condition_source = condition_source
    end

    def add_to_graph(graph)
      add_node_to_graph(graph) do |instructions|
        instructions.node_type = self.class
        instructions.id = id

        instructions.true_nodes = add_children_to_graph(graph, true_nodes)
        instructions.false_nodes = add_children_to_graph(graph, false_nodes)

        instructions.condition_source = condition_source
      end
    end

    def load_from_graph(graph, instructions, node_graph)
      @true_nodes = load_children_from_graph(graph, instructions, :true_nodes, node_graph)
      @false_nodes = load_children_from_graph(graph, instructions, :false_nodes, node_graph)
      @condition_source = instructions.condition_source
    end

    def act
      @next_nodes = context.values[condition_source] ? @true_nodes : @false_nodes
      super
    end

  end
end
