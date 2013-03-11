import time
from serial import Serial

s = Serial(port = '/dev/ttyACM0', baudrate = 9600)
#s.open()
s.write('\r')
print 'init!'
time.sleep(1)
count = 0
while 1:
    print count
    s.write('0 Off 1\r\n') # Switch first power bar
    s.write('1 Off 1\r\n') # Switch second power bar
    print 'Off'
    time.sleep(1)
    s.write('0 On 1,10,20\r\n')
    s.write('1 On 1,10,20\r\n')
    print 'On'
    time.sleep(1)
    count += 1
