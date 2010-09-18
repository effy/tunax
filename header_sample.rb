#!/usr/bin/ruby

require 'openflow'

#create header from ofp_header members
h1 = OFPHeader.new
h1.init_with(0, OFPT_ECHO_REQUEST, 8, 12345)

#get opf_header
header = h1.header

#you may send this header to switch
p header

#load ofp_header (from switch)
h2 = OFPHeader.new
h2.load_from(header)

p h2.version, h2.type, h2.length, h2.xid
