module Opal
  class ArrayBuffer
    include Native

    native_reader :buffer
    native_reader :length

    def to_s
      result = ""
      arr = []
      %x(
        for (var i = 0; i < self.native.length; i ++) {
          arr.push(self.native[i]);
          result += String.fromCharCode(self.native[i]);
        }
      )
      result
    end
  end
end
