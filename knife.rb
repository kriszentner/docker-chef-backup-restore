log_level                :info
log_location             STDOUT
node_name                'admin'
client_key               '/root/.chef/admin.pem'
validation_client_name   'chef-validator'
validation_key           '/root/.chef/validation.pem'
chef_server_url          'https://mychefserver.contoso.com:443/organizations/myorg'
syntax_check_cache_path  '/root/.chef/syntax_check_cache'
trusted_certs_dir        '/etc/chef/trusted_certs'
