module BehaviourNodeGraph
  module Comparison
    MAP = {
        gt: [false, false, true],
        ge: [false, true, true],
        eq: [false, true, false],
        le: [true, true, false],
        lt: [true, false, false],
    }.freeze
  end

  Comparer = BehaviourNodeGraph.define_simple_node(:lhs, :rhs, :target, :operator) do
    comparison = (context.values[lhs] <=> context.values[rhs]) + 1
    context.values[target] = Comparison::MAP[operator.to_sym][comparison]
  end
  Comparer.inputs = [:lhs, :rhs]
  Comparer.outputs = [:result]
  Comparer.properties = [:operator]
end
