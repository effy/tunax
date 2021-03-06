#!/usr/bin/ruby

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

require 'rubygems'
require 'rev'
require 'tunax'

listener = OFSecureChannelListener.new('0.0.0.0',6633,OFPHandler.new)
listener.attach(Rev::Loop.default)

Rev::Loop.default.run

