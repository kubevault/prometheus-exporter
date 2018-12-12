

## Prerequisite

- Kubernetes v1.12 minimum
- `--allow-privileged` flag must be set to true for both the API server and the kubelet
- (If you use Docker) The Docker daemon of the cluster nodes must allow shared mounts
- Pre-installed vault. To install vault on kubernetes, follow this
- Pass --feature-gates=CSIDriverRegistry=true,CSINodeInfo=true to kubelet and kube-apiserver