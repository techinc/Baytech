#!/usr/bin/ruby
#
# Control the Baytech RPC28A, using a serial converter or an Arduino
#
# Axel Roest, March 2010

require "serialport.so"


# constants
# change the port below to the USB-Serial dongle you have
PORT="/dev/tty.usbserial-FTC9WC13"
CMDON="On "
CMDOFF="Off "
SPEED=0.4

# connect the lights to the following outputss
outlet1=1
outlet2=2
outlet3=3

# how long to wait between on-off
EITANSLEEP=15

# commands
CMD1ON  = CMDON  + outlet1.to_s + "\r\n"
CMD1OFF = CMDOFF + outlet1.to_s + "\r\n"
CMD2ON  = CMDON  + outlet2.to_s + "\r\n"
CMD2OFF = CMDOFF + outlet2.to_s + "\r\n"
CMD12ON  = CMDON  + outlet1.to_s + "," + outlet2.to_s + "\r\n"
CMD12OFF = CMDOFF + outlet1.to_s + "," + outlet2.to_s + "\r\n"
CMD23ON  = CMDON  + outlet2.to_s + "," + outlet3.to_s + "\r\n"
CMD23OFF = CMDOFF + outlet2.to_s + "," + outlet3.to_s + "\r\n"

$sp = SerialPort.new(PORT, 9600, 8, 1, SerialPort::NONE)
$sp.write("\n")
11.times do
	puts $sp.gets
end

# turn everything off to start with
if (true) then
		puts "Off all\r\n"
		$sp.write(CMDOFF + "all \r\n")
		sleep SPEED
end

def fast_on_off
		$sp.write(CMDON + outlet1.to_s + "," +outlet2.to_s  + "\r\n")
		sleep SPEED
		puts "Off " + outlet1.to_s
		$sp.write(CMDOFF + outlet1.to_s + "," +outlet2.to_s  + "\r\n")
		sleep SPEED
end
	
def all_on_off_slow
	(1..20).each do |outlet| 
		puts "On " + outlet.to_s
		$sp.write(CMDON + outlet.to_s + "\r\n")
		sleep SPEED
		puts "Off " + outlet.to_s
		$sp.write(CMDOFF + outlet.to_s + "\r\n")
		sleep SPEED
	end
end

# uses sockets 1, 2, 3
def what_eitan_wants_3
	# turn 1 and 2 on
		$sp.write(CMD12ON)
		sleep EITANSLEEP
		$sp.write(CMD12OFF)
		sleep EITANSLEEP
		$sp.write(CMD23ON)
		sleep EITANSLEEP
		$sp.write(CMD23OFF)
		sleep EITANSLEEP
end

# uses sockets 1 and 2. Put the same set of lamps for the middle lamp
def what_eitan_wants_2
	# turn 1 and 2 on
		$sp.write(CMD1ON)
		sleep EITANSLEEP
		$sp.write(CMD1OFF)
		sleep EITANSLEEP
		$sp.write(CMD2ON)
		sleep EITANSLEEP
		$sp.write(CMD2OFF)
		sleep EITANSLEEP
end

while (true) do
	what_eitan_wants_2
	# what_eitan_wants_3
	#fast_on_off
	#all_on_off_slow
end
