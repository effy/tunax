#!/usr/bin/ruby

require 'openflow'

h1 = OFPHeader.new
h1.set(0, OFPT_ECHO_REQUEST, 8, 12345) #create header
puts h1.msg.unpack('H*') #get header(binary)

h2 = OFPHeader.new
h2.msg = h1.msg #set header(binary)
p h2.version, h2.type, h2.length, h2.xid #obtain each member of the header
