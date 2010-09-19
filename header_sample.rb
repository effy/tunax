#!/usr/bin/ruby

require 'openflow'

#create header from ofp_header members
h1 = OFPHeader.new(0, OFPT_ECHO_REQUEST, 8, 12345)

#get opf_header
header_data = h1.data

#you may send this header to switch
p header_data

#load ofp_header (from switch)
h2 = OFPHeader.create_from(header_data)

p h2.version, h2.msgtype, h2.length, h2.xid
