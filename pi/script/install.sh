set -e

# install requirements
sudo apt-get install curl git mercurial make binutils bison gcc build-essential

# install gvm
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
echo '[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"' >> ~/.profile
source /home/pi/.gvm/scripts/gvm

# install go
gvm install go1.4 -B
gvm use go1.4 
export GOROOT_BOOTSTRAP=$GOROOT 
gvm install go1.5 -B
gvm use go1.5 --default

# add the apt.adafruit.com package repository to your Pi
curl -sLS https://apt.adafruit.com/add | sudo bash
# install node.js using apt-get
sudo apt-get install node

# fetch and install influxdb
go get github.com/influxdb/influxdb
# install
cd $GOPATH/src/github.com/influxdb
go get -u -f -t ./...
go build ./...

# getting the source
go get github.com/grafana/grafana
# building the backend
cd $GOPATH/src/github.com/grafana/grafana
go run build.go setup
$GOPATH/bin/godep restore
go run build.go build
# build the front-end assets
npm install
sudo npm install -g grunt-cli
grunt
