module kubevault.dev/prometheus-exporter

go 1.15

require (
	github.com/go-kit/log v0.1.0
	github.com/hashicorp/vault/api v1.1.1
	github.com/prometheus/client_golang v1.11.0
	github.com/prometheus/common v0.28.0
	github.com/prometheus/statsd_exporter v0.21.0
	gopkg.in/alecthomas/kingpin.v2 v2.2.6
)
