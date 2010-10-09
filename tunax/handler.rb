#
#  TUNAX OpenFlow protocol message handler
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

class OFPHandler
    def on_message(securechannel, message)
    	case message.header.type
	when OFPTypes::OFPT_ERROR
	    on_error(securechannel, message)
	when OFPTypes::OFPT_ECHO_REPLY
	    on_echo_reply(securechannel, message)
	when OFPTypes::OFPT_VENDOR
	    on_vendor(securechannel, message)
	when OFPTypes::OFPT_FEATURES_REPLY
	    on_features_reply(securechannel, message)
	when OFPTypes::OFPT_GET_CONFIG_REPLY
	    on_get_config_reply(securechannel, message)
	when OFPTypes::OFPT_PACKET_IN
	    on_packet_in(securechannel, message)
	when OFPTypes::OFPT_FLOW_REMOVED
	    on_flow_removed(securechannel, message)
	when OFPTypes::OFPT_PORT_STATUS
	    on_port_status(securechannel, message)
	when OFPTypes::OFPT_STATS_REPLY
	    on_stats_reply(securechannel, message)
	when OFPTypes::OFPT_BARRIER_REPLY
	    on_barrier_reply(securechannel, message)
	when OFPT_QUEUE_GET_CONFIG_REPLY
	    on_queue_get_config_reply(securechannel, message)
	else
	    raise
	end
    end

    def on_echo_reply(securechannel, message)
    end

    def on_vendor(securechannel, message)
    end
    
    def on_features_reply(securechannel, message)
    end

    def on_get_config_reply(securechannel, message)
    end

    def on_packet_in(securechannel, message)
	puts message.payload.unpack("H*")
    end
    
    def on_flow_removed(securechannel, message)
    end

    def on_port_status(securechannel, message)
    end
    
    def on_stats_reply(securechannel, message)
    end

    def on_barrier_reply(securechannel, message)
    end

    def on_queue_get_config_reply(securechannel, message)
    end
end


