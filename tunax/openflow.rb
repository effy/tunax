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
	@raw = [self.version, self.type, self.length, self.xid].pack("CCnN") if @raw == nil
	@raw
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
	@raw = self.header.pack + self.payload if @raw == nil
	@raw
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
	#TODO proc ports
	new(message.header, *fields)
    end
end
