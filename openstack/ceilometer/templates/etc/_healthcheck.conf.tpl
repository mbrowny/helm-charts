{{- define "healthcheck_conf_tpl" -}}
export OS_REGION_NAME={{.Values.cluster_region}}
export OS_USER_DOMAIN_NAME=cc3test
export OS_PROJECT_NAME=billing_test
export OS_PROJECT_DOMAIN_NAME=cc3test
export OS_IDENTITY_API_VERSION=3
export OS_AUTH_URL={{.Values.keystone_api_endpoint_protocol_public}}://{{.Values.keystone_api_endpoint_host_public}}:{{.Values.keystone_api_port_public}}/v3
export OS_USERNAME=billing_project_usr
export OS_PASSWORD={{.Values.cc3test_billing_project_usr_password}}
export OS_CACERT=/etc/ssl/certs/ca-certificates.crt
export HANA_METRICS_URL={{.Values.ceilometer_target}}
export HANA_METRICS_USERNAME={{.Values.ceilometer_target_username}}
export HANA_METRICS_PASSWORD={{.Values.ceilometer_target_password}}
{{- end -}}
