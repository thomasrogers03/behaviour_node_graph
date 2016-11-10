module BehaviourNodeGraph
  class Executor

    def initialize(context)
      @context = context
    end

    def execute(node)
      execute_internal([node]) if node
    end

    private

    def execute_internal(next_nodes)
      if next_nodes
        next_nodes.each do |node|
          node.context = @context
          node.act
          execute_internal(node.next_nodes)
        end
      end
    end

  end
end
