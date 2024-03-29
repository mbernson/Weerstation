#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BMP085_U.h>
#include <DHT.h>
#include <DHT_U.h>
#include <ArduinoJson.h>

#define DHTPIN 13 //digital
#define DHTTYPE DHT22

#define HALLPIN 3 //digital

#define IRPIN_1 5 //digital
#define IRPIN_2 6 //digital
#define IRPIN_3 7 //digital

DHT dht(DHTPIN, DHTTYPE);
Adafruit_BMP085_Unified barometer = Adafruit_BMP085_Unified(10085);

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
  pressure
} sensorType;

volatile byte revolutions;
unsigned int rpm;
unsigned long timeold;

JsonObject& readSensorData(sensorType type);

int ir_bit_1, ir_bit_2, ir_bit_3;

void setup() {
  Serial.begin(9600);

  dht.begin();
  barometer.begin();
  
  attachInterrupt(digitalPinToInterrupt(HALLPIN), magnet_detect, RISING);//Initialize the intterrupt pin (Arduino digital pin 3)
  revolutions = 0;
  rpm = 0;
  timeold = 0;

  pinMode(IRPIN_1, INPUT);     
  digitalWrite(IRPIN_1, HIGH); 
  
  pinMode(IRPIN_2, INPUT);     
  digitalWrite(IRPIN_2, HIGH); 

  pinMode(IRPIN_3, INPUT);     
  digitalWrite(IRPIN_3, HIGH); 
}

void loop() {

  jsonBuffer = StaticJsonBuffer<500>();
  JsonObject& root = jsonBuffer.createObject();  
  JsonArray& sensors = root.createNestedArray("sensors");
  sensors.add(readSensorData(temperature));
  sensors.add(readSensorData(windspeed));
  sensors.add(readSensorData(winddirection));
  sensors.add(readSensorData(pressure));

  root.printTo(Serial);
  Serial.print("\n");
  
  delay(5000);
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

void magnet_detect() {
  revolutions++;
}

int getWindDirection() {
  ir_bit_1 = (digitalRead(IRPIN_1) == 1) ? ir_bit_1 = 1 : ir_bit_1 = 0;
  ir_bit_2 = (digitalRead(IRPIN_2) == 1) ? ir_bit_2 = 2 : ir_bit_2 = 0;
  ir_bit_3 = (digitalRead(IRPIN_3) == 1) ? ir_bit_3 = 4 : ir_bit_3 = 0;

  return ir_bit_1 + ir_bit_2 + ir_bit_3;
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
      
      if (revolutions >= 5) { 
        rpm = 30*1000/(millis() - timeold) * revolutions;
        timeold = millis();
        revolutions = 0;

        sensor["status"] = "ok";
        values["windspeed_rpm"] = rpm;
      } else {
        sensor["status"] = "waiting";
      } 
      break;
    }
    case winddirection:
    {
      sensor["name"] = "winddirection";
      JsonObject& values = sensor.createNestedObject("values");

      int result = getWindDirection();
      
      if(isValid(result)) {
        sensor["status"] = "ok";
        values["winddirection"] = result;
      } else {
        sensor["status"] = "failed";
      } 
      break;
    }
    case pressure:
    {
      sensor["name"] = "barometer";
      JsonObject& values = sensor.createNestedObject("values");
      sensors_event_t event;
      barometer.getEvent(&event);
      if (event.pressure) {
        sensor["status"] = "ok";
        values["pressure"] = event.pressure / 10;
        float temperature;
        barometer.getTemperature(&temperature);
        values["temperature"] = temperature;
      }
      break;
    }
  }

  return sensor;
}
