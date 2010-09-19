#!/usr/bin/ruby

require 'rubygems'
require 'rev'
require 'openflow'

class OFSecureChannel < Rev::TCPSocket
    def initialize(*args)
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
	puts "type:#{message.header.msgtype}"
    	case message.header.msgtype
	when OFPT_HELLO
	    write message.data
	when OFPT_ECHO_REQUEST
	    reply_hdr = OFPHeader.new(message.header.version, OFPT_ECHO_REPLY, message.header.length, message.header.xid)
	    reply_msg = OFPMessage.new(reply_hdr, message.payload)
	    write reply_msg.data
	when OFPT_PACKET_IN
	    puts message.payload.unpack("H*")
	end
    end
end

HOST = '0.0.0.0'
PORT = 6633

server = Rev::TCPServer.new(HOST, PORT, OFSecureChannel)
server.attach(Rev::Loop.default)

Rev::Loop.default.run

