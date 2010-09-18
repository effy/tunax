#!/usr/bin/ruby

require 'openflow'

#create header from ofp_header members
h1 = OFPHeader.new(0, OFPT_ECHO_REQUEST, 8, 12345)

#get header raw data
h1_data = h1.raw_data

p h1_data

#load ofp_header members from raw data
h2 = OFPHeader.new(h1_data)

p h2.version, h2.type, h2.length, h2.xid
