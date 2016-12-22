import serial, time
import json

device = '/dev/ttyUSB0'
baudrate = 9600

def serial_data(port, baudrate):
    ser = serial.Serial(port, baudrate)

    while True:
        yield ser.readline()

    ser.close()

for line in serial_data(device, baudrate):
	print(line)
