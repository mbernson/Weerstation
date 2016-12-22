#include "DHT.h"
#include <ArduinoJson.h>

#define DHTPIN 6
#define DHTTYPE DHT22

DHT dht(DHTPIN, DHTTYPE);

StaticJsonBuffer<500> jsonBuffer;

struct dht22result {
  float humidity;
  float temperature;
};

typedef enum {
  temperature,
  humidity,
  windspeed,
  winddirection,
  rain
} sensorType;

void setup() {
  Serial.begin(9600);

  dht.begin();
}

void loop() {
  delay(5000);

  jsonBuffer = StaticJsonBuffer<500>();
  JsonObject& root = jsonBuffer.createObject();  
  JsonArray& sensors = root.createNestedArray("sensors");
  sensors.add(readSensorData(temperature));
  sensors.add(readSensorData(windspeed));
  sensors.add(readSensorData(winddirection));
  sensors.add(readSensorData(rain));

  root.printTo(Serial);
  Serial.print("\n");
}

bool isValid(float sensorData) {
  return !(isnan(sensorData));
}

bool dht22IsValid(struct dht22result result) {
  return !(isnan(result.humidity) || isnan(result.temperature));
}

struct dht22result readdht22() {
  return { dht.readHumidity(), dht.readTemperature() } ;
}

JsonObject& readSensorData(sensorType type) {
  JsonObject& sensor = jsonBuffer.createObject();

  switch(type) {
    case temperature:
    case humidity:
    {
      sensor["name"] = "dht22";
      JsonObject& values = sensor.createNestedObject("values");
      struct dht22result result = readdht22();
      if(dht22IsValid(result)) {
        sensor["status"] = "ok";
        values["humidity"] = result.humidity;
        values["temperature"] = result.temperature;   
      } else {
        sensor["status"] = "failed";
      }  
      break;
    }
    case windspeed:
    {
      sensor["name"] = "windspeed";
      JsonObject& values = sensor.createNestedObject("values");
      
      // TODO get sensordata
        float result = 1.1;
      //
      
      if(isValid(result)) {
        sensor["status"] = "ok";
        values["windspeed"] = result;
      } else {
        sensor["status"] = "failed";
      } 
      break;
    }
    case winddirection:
    {
      sensor["name"] = "winddirection";
      JsonObject& values = sensor.createNestedObject("values");
      
      // TODO get sensordata
        float result = 1.2;
      //
      
      if(isValid(result)) {
        sensor["status"] = "ok";
        values["winddirection"] = result;
      } else {
        sensor["status"] = "failed";
      } 
      break;
    }
    case rain:
    {
      sensor["name"] = "rain";
      JsonObject& values = sensor.createNestedObject("values");
      
      // TODO get sensordata
        float result = 1.3;
      //
      
      if(isValid(result)) {
        sensor["status"] = "ok";
        values["rain"] = result;
      } else {
        sensor["status"] = "failed";
      } 
      break;
    }
  }

  return sensor;
}
