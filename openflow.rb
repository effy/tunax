
## ofp_type ##

# Immutable messages.
OFPT_HELLO = 0            # Symmetric message
OFPT_ERROR = 1            # Symmetric message
OFPT_ECHO_REQUEST = 2     # Symmetric message
OFPT_ECHO_REPLY = 3       # Symmetric message
OFPT_VENDOR = 4           # Symmetric message

# Switch configuration messages.
OFPT_FEATURES_REQUEST = 5     # Controller/switch message
OFPT_FEATURES_REPLY = 6       # Controller/switch message
OFPT_GET_CONFIG_REQUEST = 7   # Controller/switch message
OFPT_GET_CONFIG_REPLY = 8     # Controller/switch message
OFPT_SET_CONFIG = 9           # Controller/switch message

# Asynchronous messages.
OFPT_PACKET_IN = 10           # Async message
OFPT_FLOW_REMOVED = 11        # Async message
OFPT_PORT_STATUS = 12         # Async message

# Controller command messages.
OFPT_PACKET_OUT = 13          # Controller/switch message
OFPT_FLOW_MOD = 14            # Controller/switch message
OFPT_PORT_MOD = 15            # Controller/switch message

# Statistics messages.
OFPT_STATS_REQUEST = 16       # Controller/switch message
OFPT_STATS_REPLY = 17         # Controller/switch message

# Barrier messages.
OFPT_BARRIER_REQUEST = 18     # Controller/switch message
OFPT_BARRIER_REPLY = 19       # Controller/switch message

# Queue Configuration messages.
OFPT_QUEUE_GET_CONFIG_REQUEST = 20  # Controller/switch message
OFPT_QUEUE_GET_CONFIG_REPLY = 21    # Controller/switch message

## opf_header ##

class OFPHeader
    def set(*args)
        @version, @type, @len, @xid = args
        @msg = args.pack("CCnN")
    end

    def msg=(value)
    	@msg = value[0,8]
	@version, @type, @len, @xid = @msg.unpack("CCnN")
    end

    def msg
        @msg
    end

    def version
        @version
    end

    def type
    	@type
    end

    def len
    	@len
    end

    def xid
	@xid
    end
end
