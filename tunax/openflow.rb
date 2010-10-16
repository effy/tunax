#
#  TUNAX OpenFlow protocol ver.1.0 constants and structures
#
#  Copyright 2010 Toshio Koide
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

OFP_VERSION = 0x01
OFP_MAX_ETH_ALEN = 6
OFP_MAX_PORT_NAME_LEN = 16


# OpenFlow Message Types
#
class OFPTypes
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
end

class OFPErrors
    # ofp_error_type
    OFPET_HELLO_FAILED = 0     # Hello protocol failed.
    OFPET_BAD_REQUEST = 1      # Request was not understood.
    OFPET_BAD_ACTION = 2       # Error in action description.
    OFPET_FLOW_MOD_FAILED = 3  # Problem modifying flow entry.
    OFPET_PORT_MOD_FAILED = 4  # Port mod request failed.
    OFPET_QUEUE_OP_FAILED = 5  # Queue operation failed.

    # ofp_hello_failed_code
    OFPHFC_INCOMPATIBLE = 0    # No compatible version.
    OFPHFC_EPERM = 1           # Permissions error.

    # ofp_bad_request_code
    OFPBRC_BAD_VERSION = 0     # ofp_header.version not supported.
    OFPBRC_BAD_TYPE = 1        # ofp_header.type not supported.
    OFPBRC_BAD_STAT = 2        # ofp_stats_request.type not supported.
    OFPBRC_BAD_VENDOR = 3      # Vendor not supported (in ofp_vendor_header or ofp_stats_request or ofp_stats_reply).
    OFPBRC_BAD_SUBTYPE = 4     # Vendor subtype not supported.
    OFPBRC_EPERM = 5           # Permissions error.
    OFPBRC_BAD_LEN = 6         # Wrong request length for type.
    OFPBRC_BUFFER_EMPTY = 7    # Specified buffer has already been used.
    OFPBRC_BUFFER_UNKNOWN = 8  # Specified buffer does not exist.

    # ofp_bad_request_code
    OFPBRC_BAD_VERSION = 0
    OFPBRC_BAD_TYPE = 1
    OFPBRC_BAD_STAT = 2
    OFPBRC_BAD_VENDOR = 3
    OFPBRC_BAD_SUBTYPE = 4
    OFPBRC_EPERM = 5
    OFPBRC_BAD_LEN = 6
    OFPBRC_BUFFER_EMPTY = 7
    OFPBRC_BUFFER_UNKNOWN = 8

    # ofp_bad_action_code
    OFPBAC_BAD_TYPE = 0
    OFPBAC_BAD_LEN = 1
    OFPBAC_BAD_VENDOR = 2
    OFPBAC_BAD_VENDOR_TYPE = 3
    OFPBAC_BAD_OUT_PORT = 4
    OFPBAC_BAD_ARGUMENT = 5
    OFPBAC_EPERM = 6
    OFPBAC_TOO_MANY = 7
    OFPBAC_BAD_QUEUE = 8

    # ofp_flow_mod_failed_code
    OFPFMFC_ALL_TABLES_FULL = 0
    OFPFMFC_OVERLAP = 1
    OFPFMFC_EPERM = 2
    OFPFMFC_BAD_EMERG_TIMEOUT = 3
    OFPFMFC_BAD_COMMAND = 4
    OFPFMFC_UNSUPPORTED = 5
    
    # ofp_port_mod_failed_code
    OFPPMFC_BAD_PORT = 0     # Specified port does not exist.
    OFPPMFC_BAD_HW_ADDR = 1  # Specified hardware address is wrong.

    # ofp_queue_op_failed_code
    OFPQOFC_BAD_PORT = 0
    OFPQOFC_BAD_QUEUE = 1
    OFPQOFC_EPERM = 2
end

# Struct of Openflow protocol header
#
# To create a new instance, use new(version, type, length, xid) or create_from(data)
#
class OFPHeader < Struct.new(:version, :type, :length, :xid)

    # creates a new instance from binary data of OpenFlow header
    def self.create_from(data)
	new(*data.unpack("CCnN"))
    end

    # returns the binary data of this OpenFlow header
    def pack
	self.to_a.pack("CCnN")
    end

    # :version

    # :type

    # :length

    # :xid

    # :to_a
end

# Openflow protocol message (including header)
#
# To create a new instance, use new(header, payload) or create_from(data)
#
class OFPMessage < Struct.new(:header, :payload)

    @@xid = rand(0xFFFFFFFF)

    # creates a new instance from binary data of OpenFlow message
    def self.create_from(data)
	header = OFPHeader.create_from(data)
	data.length < header.length ? nil : new(header, data[8,header.length-8])
    end

    # creates a new instance with header fields
    def self.create_from_fields(version, type, xid, payload)
	new(OFPHeader.new(version, type, 8+payload.length, xid), payload)
    end

    def self.next_xid
	@@xid = (@@xid + 1) & 0xFFFFFFFF
    end

    # returns the binary data of this OpenFlow message
    def pack
	self.header.pack + self.payload
    end

    # returns length of the message
    def length
	self.header.length + self.payload.length
    end

    # returns the instance of OFPHeader of the message
    # :header

    # returns the payload (binary data) of the message
    # :payload

    # returns the fields for this OpenFlow message as an array
    def to_a
	array = self.header.to_a
	array.push payload
    end
end

class OFPSwitchFeatures < Struct.new(:header, :datapath_id, :n_buffers, :n_tables, :capabilities, :actions, :ports)

    # creates a new instance from OFPMessage instance
    def self.create_from(message)
	fields = message.payload.unpack("NNNCxxxNN")
	fields[1] |= fields[0] << 32
	fields.shift

	#ports
	ports = []
	for i in 1..((message.header.length - 8 - 24) / 48) #8:ofp_header, 24:ofp_switch_features, 48:ofp_phy_port
	    ofp_phy_port_data = (message.payload[24+(i-1)*48, 48])
	    ports.push(OFPPhyPort.create_from(ofp_phy_port_data))
	end
	fields.push(ports)

	#create
	new(message.header, *fields)
    end

    def pack
	self.header.pack + self.payload
    end

    def payload
	ret = self.to_a.pack("NNNCxxxNN")
	for i in 0..ports.length-1
	    ret += ports[i].pack
	end
	ret
    end
end

class OFPPhyPort < Struct.new(:port_no, :hw_addr, :name, :config, :state, :curr, :advertised, :supported, :peer)
    # creates a new instance from binary data of OpenFlow physical port
    def self.create_from(data)
	new(*data.unpack("na6Z16NNNNNN"))
    end

    # returns the binary data of this OpenFlow physical port
    def pack
	self.to_a.pack("na6Z16NNNNNN")
    end
end
