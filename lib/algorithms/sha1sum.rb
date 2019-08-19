require 'digest'

module Algorithms
  # Abstract Sha1Sum calculator
  class Sha1Sum
    attr_reader :value

    def sha1sum(value)
      sprintf("%10s %10s\n", value, sha1_hex(value))
    end

    # Subclasses must implement:
    def sha1_hex(value)
      raise 'Not implemented, abstract class'
    end

    protected

    # Helper method to convert bytes to a string
    def bytes_to_string(v)
      v.map { |b| b.to_s(16) }.join
    end
  end

  # Pure Ruby Implementation
  class Sha1Sum::Ruby < Sha1Sum
    def sha1_hex(value)
      bytes_to_string(Digest::SHA1.digest(value.to_s).bytes)
    end
  end

  # Shell out to sha1sum Implementation (expectged to be much slower due to the fork)
  class Sha1Sum::Fork < Sha1Sum
    def sha1_hex(value)
      `/usr/local/bin/bash -c "printf #{value} | /usr/local/bin/sha1sum"`.chomp.split(/ /).first
    end
  end
end
