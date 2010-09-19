#!/usr/bin/ruby

require 'openflow'

# create openflow message (echo requeest)
req_message = OFPMessage.new(OFPHeader.new(0,OFPT_ECHO_REQUEST,10,12345), "aa")

# retrieve message
data = req_message.data

# dump the message (in hex format)
puts data.unpack("H*")

# send message

# recv message

# create OFPMessage from received data
rep_message = OFPMessage.create_from(data)

# obtain fields
puts rep_message.header.msgtype, rep_message.header.xid, rep_message.payload

