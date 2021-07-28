module kubevault.dev/prometheus-exporter

go 1.15

require (
	github.com/fatih/color v1.10.0 // indirect
	github.com/go-kit/log v0.1.0
	github.com/golang/protobuf v1.5.2 // indirect
	github.com/hashicorp/vault/api v1.1.1
	github.com/matttproud/golang_protobuf_extensions v1.0.2-0.20181231171920-c182affec369 // indirect
	github.com/niemeyer/pretty v0.0.0-20200227124842-a10e7caefd8e // indirect
	github.com/prometheus/client_golang v1.11.0
	github.com/prometheus/common v0.28.0
	github.com/prometheus/statsd_exporter v0.21.0
	github.com/stretchr/testify v1.7.0 // indirect
	golang.org/x/crypto v0.0.0-20210220033148-5ea612d1eb83 // indirect
	golang.org/x/time v0.0.0-20210220033141-f8bda1e9f3ba // indirect
	gopkg.in/alecthomas/kingpin.v2 v2.2.6
	gopkg.in/check.v1 v1.0.0-20200227125254-8fa46927fb4f // indirect
	gopkg.in/yaml.v3 v3.0.0-20210107192922-496545a6307b // indirect
	kmodules.xyz/client-go dd0503cf99cf3b6abb635d8945a8d7d8fed901d9
	kmodules.xyz/custom-resources 83db827677cf5651491478fa85707d62416cf679
	kmodules.xyz/resource-metadata dcc1abc08aa00646b9474f7702b45c798b3ce66c
	kmodules.xyz/webhook-runtime e489faf01981d2f3afa671989388c7b6f22b6baa
)

replace github.com/satori/go.uuid => github.com/gofrs/uuid v4.0.0+incompatible

replace helm.sh/helm/v3 => github.com/kubepack/helm/v3 v3.6.1-0.20210518225915-c3e0ce48dd1b

replace k8s.io/apiserver => github.com/kmodules/apiserver v0.21.2-0.20210716212718-83e5493ac170
