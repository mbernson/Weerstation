# Weerstation.Pi

## Installatie

```
git clone git@github.com:mbernson/Weerstation.Pi.git ~/weerstation.pi
sudo apt-get install supervisor
sudo ln -s /home/pi/weerstation.pi/sensor-reader/sensor-reader-supervisor.conf /etc/supervisor/conf.d/weerstation-sensor-reader.conf
sudo supervisorctl update
```