module Snowden::Backends
  #@api private
  SNOWDEN_BACKEND_HASH = {}

  class HashBackend
    #Creates a new redis backend
    #
    # @param namespace [String] the string this backend is namespaced under.
    # @param hash     [Hash] a Hash object instance to save values in.
    def initialize(namespace="", hash=SNOWDEN_BACKEND_HASH)
      @namespace = namespace
      @hash      = hash
    end

    #Saves a value in this index
    #
    # @param key   [String] the string key to save the value under.
    # @param value [String] the value to save.
    def save(key, value)
      @hash[namespaced_key(key)] ||= []
      @hash[namespaced_key(key)] << value
      nil
    end

    #Finds a value in this index
    #
    # @param key [String] the string key to search the index for.
    # @return [ [String] ] a list of strings that matched the namespaced key.
    def find(key)
      @hash.fetch(namespaced_key(key), [])
    end

    private

    def namespaced_key(key)
      [@namespace, key]
    end
  end
end
