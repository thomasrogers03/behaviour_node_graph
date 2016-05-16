module BehaviourNodeGraph
  class Executor

    def initialize(context)
      @context = context
    end

    def execute(node)
      while node
        node.context = @context if node
        node.act
        node = node.next_node
      end
    end

  end
end
