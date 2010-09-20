#!/usr/bin/ruby

require 'rubygems'
require 'rev'
require 'openflow'
require 'msgpack/rpc'

OFP_HOST = '0.0.0.0'
OFP_PORT = 6633
QUEUE_HOST = 'localhost'
QUEUE_PORT = 6666

class OFSecureChannel < Rev::TCPSocket
    def initialize(*args)
	@msg_queue = MessagePack::RPC::Client.new(QUEUE_HOST,QUEUE_PORT)
    	@buffer = ''
	super
    end

    def on_read(data)
    	@buffer << data

	while @buffer.length >= 8
	    message = OFPMessage.create_from(@buffer)
	    break if message == nil
	    on_message(message)
	    @buffer.slice!(0, message.length)
	end
    end

    def on_message(message)
	puts "type:#{message.header.type}"
    	case message.header.type
	when OFPT_HELLO
	    write message.pack
	when OFPT_ECHO_REQUEST
	    reply_hdr = OFPHeader.new(message.header.version, OFPT_ECHO_REPLY, message.header.length, message.header.xid)
	    reply_msg = OFPMessage.new(reply_hdr, message.payload)
	    write reply_msg.pack
	when OFPT_PACKET_IN
	    puts message.payload.unpack("H*")
	end
    end

    def on_queue_pull(future)
    end
end

server = Rev::TCPServer.new(OFP_HOST, OFP_PORT, OFSecureChannel)
server.attach(Rev::Loop.default)

Rev::Loop.default.run

