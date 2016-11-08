module BehaviourNodeGraph
  Counter = BehaviourNodeGraph.define_simple_node(:target, :increment) do
    context.values[target] = (context.values[target] || 0) + increment
  end
  Counter.properties = [:increment]
end
