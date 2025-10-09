#!/bin/bash

_has_function "k9s" || return 0

_absname -v __K9S_FUNCTION_FILE -- "${BASH_SOURCE[0]}"

k9s() {
    _maybe_local "k9s"
    local K9S_CONFIG_DIR="$IAM_HOME/config/k9s"
    [ -z "$__K9S_FUNCTION_FILE" ] || {
        _ensure_config "$K9S_CONFIG_DIR" "$__K9S_FUNCTION_FILE"
        unset __K9S_FUNCTION_FILE
    }
    env K9S_CONFIG_DIR="$K9S_CONFIG_DIR" k9s "$@"
}

return 0

# shellcheck disable=all
{

---- config.yaml
k9s:
  liveViewAutoRefresh: true
  refreshRate: 2
  apiServerTimeout: 15s
  maxConnRetry: 5
  readOnly: false
  noExitOnCtrlC: false
  portForwardAddress: localhost
  ui:
    enableMouse: false
    headless: false
    logoless: true
    crumbsless: false
    splashless: false
    reactive: true
    noIcons: false
    defaultsToFullScreen: false
    useFullGVRTitle: false
  skipLatestRevCheck: true
  disablePodCounting: false
  shellPod:
    image: busybox:1.35.0
    namespace: default
    limits:
      cpu: 100m
      memory: 100Mi
  imageScans:
    enable: false
    exclusions:
      namespaces: []
      labels: {}
  logger:
    tail: 100
    buffer: 5000
    sinceSeconds: -1
    textWrap: false
    disableAutoscroll: false
    showTime: false
  thresholds:
    cpu:
      critical: 90
      warn: 70
    memory:
      critical: 90
      warn: 70
  defaultView: ""

---- plugins.yaml
plugins:
  lnav_pods:
    shortCut: Ctrl-L
    description: lnav logs (current)
    scopes:
    - po
    command: lnav
    background: false
    args:
    - -e
    - "kubectl logs $NAME -n $NAMESPACE --all-containers --max-log-requests 10 --context $CONTEXT -f --since 5m"
  lnav_pods_all:
    shortCut: Shift-L
    description: lnav logs (all)
    scopes:
    - po
    command: lnav
    background: false
    args:
    - -e
    - "kubectl logs $NAME -n $NAMESPACE --all-containers --max-log-requests 10 --context $CONTEXT -f"
  lnav_containers:
    shortCut: Ctrl-L
    description: lnav logs (current)
    scopes:
    - containers
    command: lnav
    background: false
    args:
    - -e
    - "kubectl logs $POD -c $NAME -n $NAMESPACE --context $CONTEXT -f --since 5m"
  lnav_containers_all:
    shortCut: Shift-L
    description: lnav logs (all)
    scopes:
    - containers
    command: lnav
    background: false
    args:
    - -e
    - "kubectl logs $POD -c $NAME -n $NAMESPACE --context $CONTEXT -f"
----
}
