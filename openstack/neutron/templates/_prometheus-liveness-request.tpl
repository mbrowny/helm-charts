{{- define "neutron.network-agent.liveness.query" -}}
import os
import requests

MODE = '{{ . }}'
if MODE not in ('network',  'bridge'):
    print(f'Supplied mode "{MODE}" is invalid.')
    exit(3)

PROMETHEUS = "http://prometheus-openstack.prometheus-openstack:9090"
BRIDGE_QUERY = """
    sum(openstack_subnets_with_dhcp_ip_allocation{network_host="%s"}) by (bridge, network_host)
    unless on(bridge, network_host)
    label_replace(neutron_agent_checks_linux_bridge_present, "network_host", "$1", "hostname", "(.*)")
"""
NETWORK_QUERY = """
    openstack_subnets_with_dhcp_ip_allocation{network_host="%s"}
        unless on(network_id, network_host)
    label_replace(label_replace(neutron_agent_checks_netns_present, "network_host", "$1", "hostname", "(.*)"), "network_id", "$1", "netns", "(.*)")
"""

query = NETWORK_QUERY if MODE == "network" else BRIDGE_QUERY

response = requests.get(PROMETHEUS + "/api/v1/query", params={"query":  query % os.uname()[1]}) 
if  response.status_code != 200:
    print(f"Error while running prometheus query: {response.json()}")
    exit(1)
data = response.json().get("data", {}).get("result", [])
if len(data) != 0:
    nets = [x["metric"]["network_id" if MODE == "network" else "bridge"] for x in data]
    print(f"{len(data)} unsynced {'network namespaces' if MODE == 'network' else 'bridges' }: {nets}")
    exit(2)
{{ end }}
