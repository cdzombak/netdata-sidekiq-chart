# `sidekiq.chart.sh`

Displays some basic Sidekiq metrics in Netdata.

## Requirements

- Netdata must be installed already

## Installation

### Debian/derivatives via apt repository

Install my Debian repository, if you haven't already:

```shell
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://dist.cdzombak.net/deb.key | sudo gpg --dearmor -o /etc/apt/keyrings/dist-cdzombak-net.gpg
sudo chmod 0644 /etc/apt/keyrings/dist-cdzombak-net.gpg
echo -e "deb [signed-by=/etc/apt/keyrings/dist-cdzombak-net.gpg] https://dist.cdzombak.net/deb/oss any oss\n" | sudo tee -a /etc/apt/sources.list.d/dist-cdzombak-net.list > /dev/null
sudo apt-get update
```

Then install `netdata-sidekiq-chart` via `apt-get`:

```shell
sudo apt-get install netdata-sidekiq-chart
```

### Manual

0. `apt-get install netdata-plugin-chartsd redis-tools`
1. Download [the latest release](https://github.com/cdzombak/netdata-sidekiq-chart/releases/latest) and copy `sidekiq.chart.sh` to `/usr/libexec/netdata/charts.d`
2. `chown root:netdata /usr/libexec/netdata/charts.d/sidekiq.chart.sh`
3. `chmod +x /usr/libexec/netdata/charts.d/sidekiq.chart.sh`

## License

`netdata-sidekiq-chart` is licensed under the LGPL-3.0 License. See the [LICENSE](LICENSE) file for details.

## Author

Chris Dzombak
- [dzombak.com](https://dzombak.com)
- [github.com/cdzombak](https://github.com/cdzombak)

Originally based on [`sidekiq.chart.sh` by codl@codl.fr](https://gist.github.com/codl/0b2e425d6181a1f279b5137881f7141d).
