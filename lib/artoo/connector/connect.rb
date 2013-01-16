module Artoo
  module Connector
    # The Connect class is the base class that represents how to  
    # connect to a specific group of hardware devices. Examples 
    # would be an Arduino, a Sphero, or an ARDrone.
    #
    # Derive a class from this class, in order to implement communication
    # with a new type of hardware device.
    class Connect
      include Celluloid

      attr_reader :parent, :port

      def initialize(params={})
        @parent = params[:parent]
        @port = params[:port]
        @connected = false
      end

      def connect
        @connected = true
      end

      def disconnect
        @connected = false
        true
      end

      def connected?
        @connected == true
      end
    end
  end
end