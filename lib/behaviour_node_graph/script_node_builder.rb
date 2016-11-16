module BehaviourNodeGraph
  module ScriptNodeBuilder
    def self.extended(base)
      base.node_cache = LruRedux::TTL::ThreadSafeCache.new(100, 5 * 60)
    end

    attr_accessor :node_cache

    def fetch(code)
      node_cache[script_sha(code)] ||= build(code)
    end

    private

    def script_sha(code)
      Digest::SHA1.base64digest(code)
    end
  end
end
