#
#  TUNAX OpenFlow secure channel listener
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

# OpenFlow secure channel
#
class OFSecureChannel < Rev::TCPSocket

    # called from OFSecureChannelListener
    def initialize(*args) #:nodoc:
    	@buffer = ''
	@features = nil
	@on_message_handler = nil
	socket, @on_securechannel_connect_handler, @on_securechannel_close_handler = args.slice(0,3)
	super socket
    end

    # sends OpenFlow message (OFPMessage) via this secure channel.
    def send_message(message)
    	write message.pack
    end

    def send_features_request
	send_message(OFPMessage.create_from_fields(OFP_VERSION, OFPTypes::OFPT_FEATURES_REQUEST, OFPMessage.next_xid, ""))
    end

    # called from OFSecureChannelListener
    # sets or gets the handler that handles received OpenFlow messages.
    attr_accessor :on_message_handler #:nodoc:

    # OpenFlow protocol version of the secure channel
    def version
	@features.header.version
    end
    
    # Datapath ID of the OpenFlow switch
    def datapath_id
	@features.datapath_id
    end

    protected

    def on_read(data)
    	@buffer << data

	while @buffer.length >= 8
	    message = OFPMessage.create_from(@buffer)
	    break if message == nil
	    @buffer.slice!(0, message.length)
	    on_message(message)
	end
    end

    def on_message(message)
	case message.header.type
	when OFPTypes::OFPT_HELLO
	    send_message(message)
	    return if @features
	when OFPTypes::OFPT_ECHO_REQUEST
	    message.header.type = OFPTypes::OFPT_ECHO_REPLY
	    send_message(message)
	    return if @features
	when OFPTypes::OFPT_FEATURES_REPLY
    	    old_features = @featuers
	    @features = OFPSwitchFeatures.create_from(message)
	    @on_securechannel_connect_handler.call(self) if old_features == nil
	end

	if @features
	    @on_message_handler.call(self, message) if @on_message_handler
	else
	    send_features_request
	end
    end

    def on_close
	@on_securechannel_close_handler.call(self)
	@features = nil
    end
end

# OpenFlow secure channel listener
#
class OFSecureChannelListener < Rev::TCPServer
    def initialize(host='0.0.0.0', port=6633, ofp_handler=nil)
	@securechannels = {}
	@on_message_handler = ofp_handler.method(:on_message)
	super(host, port, OFSecureChannel, method(:on_securechannel_connect), method(:on_securechannel_close))
    end

    protected

    def on_securechannel_close(securechannel)
	@securechannels.delete securechannel.datapath_id
    end

    def on_securechannel_connect(securechannel)
	securechannel.on_message_handler = @on_message_handler
	@securechannels[securechannel.datapath_id] = securechannel
    end
end

