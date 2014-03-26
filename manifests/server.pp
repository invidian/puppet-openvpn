# == Define: openvpn::server
#
# This define creates the openvpn server instance and ssl certificates
#
#
# === Parameters
#
# [*country*]
#   String.  Country to be used for the SSL certificate
#
# [*province*]
#   String.  Province to be used for the SSL certificate
#
# [*city*]
#   String.  City to be used for the SSL certificate
#
# [*organization*]
#   String.  Organization to be used for the SSL certificate
#
# [*email*]
#   String.  Email address to be used for the SSL certificate
#
# [*compression*]
#   String.  Which compression algorithim to use
#   Default: comp-lzo
#   Options: comp-lzo or '' (disable compression)
#
# [*dev*]
#   String.  Device method
#   Default: tun
#   Options: tun (routed connections), tap (bridged connections)
#
# [*user*]
#   String.  Group to drop privileges to after startup
#   Default: nobody
#
# [*group*]
#   String.  User to drop privileges to after startup
#   Default: depends on your $::osfamily
#
# [*ipp*]
#   Boolean.  Persist ifconfig information to a file to retain client IP
#     addresses between sessions
#   Default: false
#
# [*local*]
#   String.  Interface for openvpn to bind to.
#   Default: $::ipaddress_eth0
#   Options: An IP address or '' to bind to all ip addresses
#
# [*logfile*]
#   String.  Logfile for this openvpn server
#   Default: false
#   Options: false (syslog) or log file name
#
# [*port*]
#   Integer.  The port the openvpn server service is running on
#   Default: 1194
#
# [*proto*]
#   String.  What IP protocol is being used.
#   Default: tcp
#   Options: tcp or udp
#
# [*status_log*]
#   String.  Logfile for periodic dumps of the vpn service status
#   Default: "${name}/openvpn-status.log"
#
# [*server*]
#   String.  Network to assign client addresses out of
#   Default: None.  Required in tun mode, not in tap mode
#
# [*server_bridge*]
#   String. Server configuration to comply with existing DHCP server
#   Default: None.
#
# [*push*]
#   Array.  Options to push out to the client.  This can include routes, DNS
#     servers, DNS search domains, and many other options.
#   Default: []
#
# [*route*]
#   Array.  Add route to routing table after connection is established.
#     Multiple routes can be specified.
#   Default: []
#
# [*keepalive*]
#   String.  Add keepalive directive (ping and ping-restart) to server.
#     Should match the form "n m".
#   Default: None
#
# [*ssl_key_size*]
#   String. Length of SSL keys (in bits) generated by this module.
#   Default: 1024
#
# [*topology*]
#   String. Define the network topology type
#   Default: net30
#
# [*c2c*]
#   Boolean.  Enable client to client visibility
#   Default: false
#
# [*tcp-nodelay*]
#   Boolean, Enable/Disable.
#   Default: false
#
# [*ccd-exclusive*]
#   Boolean, Enable/Disable.
#   Default: false
#
# [*pam*]
#   Boolean, Enable/Disable.
#   Default: false
#
# [*management*]
#   Boolean.  Enable management interface
#   Default: false
#
# [*management_ip*]
#   String.  IP address where the management interface will listen
#   Default: localhost
#
# [*management_port*]
#   String.  Port where the management interface will listen
#   Default: 7505
#
# [*up*]
#   String,  Script which we want to run when openvpn server starts
#
# [*ldapenabled*]
#   Boolean. If ldap is enabled, do stuff
#   Default: false
#
# [*userascommon*]
#   Boolean. If true then set username-as-common-name
#   Default: false
#
# [*ldapserver*]
#   String. FQDN of LDAP server
#   Default: None
#
# [*ldapbinddn*]
#   String. LDAP DN to bind as
#   Default: None
#
# [*ldapbindpass*]
#   String. LDAP password for ldapbinddn
#   Default: None
#
# [*ldapubasedn*]
#   String. Place in the LDAP tree to look for users
#   Default: None
#
# [*ldapgbasedn*]
#   String. Place in the LDAP tree to look for groups
#   Default: None
#
# [*ldapgmember*]
#   Boolean. If defined use group block in ldap.conf
#   Default: false
#
# [*ldapfilter*]
#   String. Group SearchFilter for LDAP accounts
#   Default: None
#
# [*ldapmemberatr*]
#   String. Attribute for MemberAttribute. Used with ldapfilter
#   Default: None
#
# === Examples
#
#   openvpn::client {
#     'my_user':
#       server      => 'contractors',
#       remote_host => 'vpn.mycompany.com'
#    }
#
# * Removal:
#     Manual process right now, todo for the future
#
#
# === Authors
#
# * Raffael Schmid <mailto:raffael@yux.ch>
# * John Kinsella <mailto:jlkinsel@gmail.com>
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
# === License
#
# Copyright 2013 Raffael Schmid, <raffael@yux.ch>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
define openvpn::server(
  $country,
  $province,
  $city,
  $organization,
  $email,
  $compression = 'comp-lzo',
  $dev = 'tun0',
  $user = 'nobody',
  $group = false,
  $ipp = false,
  $ip_pool = [],
  $local = $::ipaddress_eth0,
  $logfile = false,
  $port = '1194',
  $proto = 'tcp',
  $status_log = "${name}/openvpn-status.log",
  $server = '',
  $server_bridge = '',
  $push = [],
  $route = [],
  $keepalive = '',
  $ssl_key_size = 1024,
  $topology = 'net30',
  $c2c = false,
  $tcp_nodelay = false,
  $ccd_exclusive = false,
  $pam = false,
  $management = false,
  $management_ip = 'localhost',
  $management_port = 7505,
  $up = '',
  $ldapenabled = false,
  $userascommon = false,
  $ldapserver = '',
  $ldapbinddn = '',
  $ldapbindpass = '',
  $ldapubasedn = '',
  $ldapgbasedn = '',
  $ldapgmember = false,
  $ldapfilter = '',
  $ldapmemberatr = '',
) {

  include openvpn
  Class['openvpn::install'] ->
  Openvpn::Server[$name] ~>
  Class['openvpn::service']

  if $ldapenabled == true {
    Package {'openvpn-auth-ldap'}:
      ensure => installed,
  }

  $tls_server = $proto ? {
    /tcp/   => true,
    default => false
  }

  $group_to_set = $group ? {
    false   => $openvpn::params::group,
    default => $group
  }

  file {
    [ "/etc/openvpn/${name}",
      "/etc/openvpn/${name}/client-configs",
      "/etc/openvpn/${name}/download-configs" ]:
        ensure  => directory;
  }

  exec {
    "copy easy-rsa to openvpn config folder ${name}":
      command => "/bin/cp -r ${openvpn::params::easyrsa_source} /etc/openvpn/${name}/easy-rsa",
      creates => "/etc/openvpn/${name}/easy-rsa",
      notify  => Exec["fix_easyrsa_file_permissions_${name}"],
      require => File["/etc/openvpn/${name}"];
  }

  exec {
    "fix_easyrsa_file_permissions_${name}":
      refreshonly => true,
      command     => "/bin/chmod 755 /etc/openvpn/${name}/easy-rsa/*";
  }

  file {
    "/etc/openvpn/${name}/easy-rsa/revoked":
      ensure  => directory,
      require => Exec["copy easy-rsa to openvpn config folder ${name}"];
  }

  file {
    "/etc/openvpn/${name}/easy-rsa/vars":
      ensure  => present,
      content => template('openvpn/vars.erb'),
      require => Exec["copy easy-rsa to openvpn config folder ${name}"];
  }

  file {
    "/etc/openvpn/${name}/easy-rsa/openssl.cnf":
      require => Exec["copy easy-rsa to openvpn config folder ${name}"];
  }

  if $openvpn::params::link_openssl_cnf == true {
    File["/etc/openvpn/${name}/easy-rsa/openssl.cnf"] {
      ensure => link,
      target => "/etc/openvpn/${name}/easy-rsa/openssl-1.0.0.cnf"
    }
  }

  exec {
    "generate dh param ${name}":
      command  => '. ./vars && ./clean-all && ./build-dh',
      cwd      => "/etc/openvpn/${name}/easy-rsa",
      creates  => "/etc/openvpn/${name}/easy-rsa/keys/dh${ssl_key_size}.pem",
      provider => 'shell',
      require  => File["/etc/openvpn/${name}/easy-rsa/vars"];

    "initca ${name}":
      command  => '. ./vars && ./pkitool --initca',
      cwd      => "/etc/openvpn/${name}/easy-rsa",
      creates  => "/etc/openvpn/${name}/easy-rsa/keys/ca.key",
      provider => 'shell',
      require  => [ Exec["generate dh param ${name}"],
                    File["/etc/openvpn/${name}/easy-rsa/openssl.cnf"] ];

    "generate server cert ${name}":
      command  => '. ./vars && ./pkitool --server server',
      cwd      => "/etc/openvpn/${name}/easy-rsa",
      creates  => "/etc/openvpn/${name}/easy-rsa/keys/server.key",
      provider => 'shell',
      require  => Exec["initca ${name}"];
  }

  file {
    "/etc/openvpn/${name}/keys":
      ensure  => link,
      target  => "/etc/openvpn/${name}/easy-rsa/keys",
      require => Exec["copy easy-rsa to openvpn config folder ${name}"];
  }

  exec {
    "create crl.pem on ${name}":
      command  => ". ./vars && KEY_CN='' KEY_OU='' KEY_NAME='' openssl ca -gencrl -out /etc/openvpn/${name}/crl.pem -config /etc/openvpn/${name}/easy-rsa/openssl.cnf",
      cwd      => "/etc/openvpn/${name}/easy-rsa",
      creates  => "/etc/openvpn/${name}/crl.pem",
      provider => 'shell',
      require  => Exec["generate server cert ${name}"];
  }

  file {
    "/etc/openvpn/${name}/easy-rsa/keys/crl.pem":
      ensure  => link,
      target  => "/etc/openvpn/${name}/crl.pem",
      require => Exec["create crl.pem on ${name}"];
  }

  if $::osfamily == 'Debian' {
    concat::fragment {
      "openvpn.default.autostart.${name}":
        content => "AUTOSTART=\"\$AUTOSTART ${name}\"\n",
        target  => '/etc/default/openvpn',
        order   => 10;
    }
  }

  file {
    "/etc/openvpn/${name}.conf":
      owner   => root,
      group   => root,
      mode    => '0444',
      content => template('openvpn/server.erb');
  }
  if $ldapenabled == true {
    file {
      '/etc/openvpn/auth/ldap.conf':
        ensure  => present,
        content => template('openvpn/ldap.erb');
    }
  }
}
