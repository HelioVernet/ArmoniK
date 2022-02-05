pushd $(dirname "${BASH_SOURCE[0]}")
pushd $(pwd -P)/../../armonik
ARMONIK_PATH=$(pwd -P)

# Armonik monitoring namespace in the Kubernetes
export ARMONIK_MONITORING_NAMESPACE=armonik-monitoring
popd
popd
env | grep --color=always ARMONIK