module Payments
  class Version #:nodoc:
    @major = 0
    @minor = 9
    @tiny  = 4
    @build = 'dev'

    class << self
      attr_reader :major, :minor, :tiny, :build

      def to_s
        [@major, @minor, @tiny, @build].compact.join('.')
      end
    end
  end
end