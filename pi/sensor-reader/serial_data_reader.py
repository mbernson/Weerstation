import serial, time
import json
from influxdb import InfluxDBClient

device = '/dev/ttyUSB0'
baudrate = 9600
location = 'hildebrandpad'

# TODO: Store config somewhere else
client = InfluxDBClient('localhost', 8086, 'weerstation', 'weerstation', 'weerstation')

def parse_sensor_results(data):
    """Converts sensor results from `data` to influxdb formatted points"""
    for sensor in data["sensors"]:
        if sensor["status"] != "ok":
            print("skipping because status is not ok!")
            print("status: %s" % sensor["status"])
            # TODO: Notify the admin
        else:
            # Exception for HpA due to bad formatting
            if sensor["name"] == "barometer":
                fixed_pressure = sensor["values"]["pressure"] * 10
                sensor["values"]["pressure"] = fixed_pressure

            yield {
                "measurement": sensor["name"],
                "tags": { "location": location },
                "fields": sensor["values"]
            }

def serial_data(port, baudrate):
    """Reads serial data forever from `port`"""
    ser = serial.Serial(port, baudrate)
    while True:
        yield ser.readline()
    ser.close()


# Main loop

while True:
    try:
        for line in serial_data(device, baudrate):
            print(line)
            data = json.loads(line.strip())
            points = list(parse_sensor_results(data))
            if client.write_points(points):
                print("saved some data")
            else:
                print("failed to save data")
            print(points)
    except serial.serialutil.SerialException:
        print("Serial device not found. Retrying in 5 seconds...")
        time.sleep(5)
