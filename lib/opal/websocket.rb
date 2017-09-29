require 'opal'
require "opal/array_buffer"
require "opal/websocket/version"

if RUBY_ENGINE == 'opal'

module Opal
  class WebSocket
    include Native

    CONNECTING = 0
    OPEN = 1
    CONNECTING = 2
    CLOSED = 3

    def initialize(url)
      super `new WebSocket(url)`
    end

    def binary_type=(type)
      case type
      when :arraybuffer
        `self.native.binaryType = 'arraybuffer'`
      when :blob
        `self.native.binaryType = 'blob'`
      else
        raise 'binary_type must be set as type :blob or :arraybuffer'
      end
    end

    def onmessage
      add_event_listener('message') {|event| yield MessageEvent.new(event) if self.open? }
    end

    def onopen
      add_event_listener('open') {|event| yield Native(event) }
    end

    def onclose
      add_event_listener('close') {|event| yield Native(event) }
    end

    def onerror
      add_event_listener('error') {|event| yield Native(event) }
    end

    def open?
      `self.native.readyState == #{OPEN}`
    end

    alias_native :close
    alias_native :send
    alias_native :add_event_listener, :addEventListener

    class MessageEvent
      include Native

      native_reader :origin
      native_reader :source
      native_reader :ports

      def data
        ArrayBuffer.new(`new Uint8Array(self.native.data)`)
      end

      def last_event_id
        `self.native.lastEventId`
      end
    end
  end
end
