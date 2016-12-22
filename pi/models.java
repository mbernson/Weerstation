class SensorResult {
    List<Sensor> sensors;
}

class Sensor {
    String name;
    SensorStatus status;
    Map<String, String> values;
    // temperature: "23.5"

    enum SensorStatus {
        OK, FAILED
    };
}
