module Nicolive
  class Thread
    attr_reader :thread, :addr, :port

    def initialize(thread, addr, port)
      @thread = thread
      @addr = addr
      @port = port
    end
  end
end