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

	puts @buffer.unpack("H*")
	
	while @buffer.length >= 8
	    header = OFPHeader.new
	    header.load_from(@buffer)
	    break if @buffer.length < header.length
	    on_message(header, @buffer[8,header.length-8])
	    @buffer.slice!(0, header.length)
	end
    end

    def on_message(header, payload)
	puts "type:", header.type

    	case header.type
	when OFPT_HELLO
	    write header.header
	when OFPT_ECHO_REQUEST
	    reply_header = OFPHeader.new
	    reply_header.init_with(header.version, OFPT_ECHO_REPLY, 8, header.xid)
	    write reply_header.header
	end
    end
end

HOST = '0.0.0.0'
PORT = 6633

server = Rev::TCPServer.new(HOST, PORT, OFSecureChannel)
server.attach(Rev::Loop.default)

Rev::Loop.default.run
