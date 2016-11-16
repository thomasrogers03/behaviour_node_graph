module BehaviourNodeGraph
  module ScriptNodeBuilder
    def self.extended(base)
      base.node_cache = LruRedux::TTL::ThreadSafeCache.new(100, 5 * 60)
    end

    attr_accessor :node_cache
  end
end
