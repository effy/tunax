
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

## ofp_header ##
=begin
//Header on all OpenFlow packets.
struct ofp_header {
    uint8_t version;    /* OFP_VERSION. */
    uint8_t type;       /* One of the OFPT_ constants. */
    uint16_t length;    /* Length including this ofp_header. */
    uint32_t xid;       /* Transaction id associated with this packet.
                           Replies use the same id as was in the request
                           to facilitate pairing. */
};
=end

class OFPHeader < Struct.new(:version, :type, :length, :xid)
    def self.create_from(data)
	new(*data.unpack("CCnN"))
    end

    def pack
	[self.version, self.type, self.length, self.xid].pack("CCnN")
    end
end

class OFPMessage < Struct.new(:header, :payload)
    def self.create_from(data)
	header = OFPHeader.create_from(data)
	data.length < header.length ? nil : new(header, data[8,header.length-8])
    end

    def pack
	self.header.pack + self.payload
    end

    def length
	self.header.length + self.payload.length
    end
end

