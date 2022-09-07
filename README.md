# ansible-test

## First install

Ubuntu 20.04
```bash
sudo apt install -y python3-venv virtualbox virtualbox-dkms virtualbox-ext-pack vagrant
./bin/init.sh
```

MacOS
```bash
brew install python3
brew install virtualbox
brew install vagrant
./bin/init.sh
```

## day to day
```bash
# activate python virtual env
source venv/bin/activate

# test playbook
cd playbook
molecule destroy

molecule converge -- --diff
molecule verify
molecule lint
curl localhost:59090/metrics

# log into the VM
molecule login

# cleanup
molecule destroy
```



## Goal
For now, we have a basic Prometheus server running, using default port 9090

We want our ansible to be able to customize the port Prometheus is using.

## Step1: github fork & init

* Fork https://github.com/skeetmtp/ansible-test2 project on github

* git clone your fork locally

* Test it

```bash
./bin/init.sh

# activate python virtual env
source venv/bin/activate

# test playbook
cd playbook
molecule destroy

molecule converge -- --diff
```

* Check ```curl http://localhost:59090/metrics | grep "promhttp_metric_handler_requests_total"``` dot not output any error

## Step2: introduce ```prometheus_port``` var

* Add a ```prometheus_port``` var in playbook/roles/prometheus/defaults/main.yml with default value ```9090```

* Override ```prometheus_port``` var in playbook/group_vars/all.yml with value ```9091```

* Update ansible code to use ```prometheus_port``` instead of hard coded ```9090``` value

* !!! Be sure systemd daemon is reloaded when service config is updated

* ```molecule converge -- --diff```

* Check ```curl http://localhost:59091/metrics | grep "promhttp_metric_handler_requests_total"``` dot not output any error

* If you need to debug/investigate use ```molecule login``` then ```sudo -i```, ex of helpfull commands:
  - ```systemctl status prometheus```
  - ```journalctl -u prometheus```
  - ```systemctl restart prometheus```
  - ...

* git commit & push your changes

* Create a Pull Request with this change
