# Weerstation.Arduino

Libraries needed:
* ArduinoJson
* Adafruit Unified Sensor
* DHT sensor library
* Adafruit BMP085 Unified
	
JSON send by Arduino
```json
{
	"sensors": [{
		"name": "dht22",
		"status": "ok",
		"values": {
			"humidity": 31.90,
			"temperature": 24.30
		}
	}, {
		"name": "windspeed",
		"status": "ok",
		"values": {
			"speed": 1.10
		}
	}, {
		"name": "winddirection",
		"status": "ok",
		"values": {
			"direction": 1.20
		}
	}]
}
```
