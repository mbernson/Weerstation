from flask import Flask, Response
from flask import request
from influxdb import InfluxDBClient
import json

# TODO: Store config somewhere else
client = InfluxDBClient('localhost', 8086, 'weerstation', 'weerstation', 'weerstation')
app = Flask(__name__)

allowed_sensors = ['rain', 'windspeed', 'winddirection', 'temperature', 'humidity']

@app.route("/status")
def status(sensorname):
    response = {
        'sensors': []
    }
    for sensor in allowed_sensors:
        result = client.query('select %s, %s from %s order by time desc limit 1;' % (sensorname, 'time', sensorname))
        point = result.get_points()[0]

    return Response(json.dumps(response), mimetype='application/json')

@app.route("/sensor/<sensorname>")
def hello(sensorname):
    if sensorname not in allowed_sensors:
        return json.dumps({'error': 'Sensor not allowed'}), 400

    limit = int(request.args.get('limit', '100'))
    if limit < 1 or limit > 100: limit = 100

    result = client.query('select %s, %s from %s order by time desc limit %i;' % (sensorname, 'time', sensorname, limit))

    response = {
        'points': list(result.get_points())
    }
    return Response(json.dumps(response), mimetype='application/json')

if __name__ == "__main__":
    app.run(host='0.0.0.0')
