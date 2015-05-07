node default {
  ### Apache
  $apache_data = hiera('apache_data')

  file { '/tmp/test.apache' :
    ensure  => present,
    content => template('test.apache.erb'),
  }

  ### Erlang
  $erlang_data = hiera('erlang_data')

  file { '/tmp/test.erlang' :
    ensure  => present,
    content => template('test.erlang.erb'),
  }

  ### INI
  $ini_data = hiera('ini_data')

  file { '/tmp/test.ini' :
    ensure  => present,
    content => template('test.ini.erb'),
  }

  file { '/tmp/test.simple' :
    ensure  => present,
    content => template('test.ini_simple.erb'),
  }


  ### JSON
  $json_data = hiera('json_data')

  file { '/tmp/test.json' :
    ensure  => present,
    content => template('test.json.erb'),
  }

  ### Logstash
  $json_data = hiera('logstash_data')

  file { '/tmp/test.logstash' :
    ensure  => present,
    content => template('test.logstash.erb'),
  }

  ### TOML
  $toml_data = hiera('toml_data')

  file { '/tmp/test.toml' :
    ensure  => present,
    content => template('test.toml.erb'),
  }

  ### XML
  $xml_data = hiera('xml_data')

  file { '/tmp/test.xml' :
    ensure  => present,
    content => template('test.xml.erb'),
  }

  ### YAML
  $yaml_data = hiera('yaml_data')

  file { '/tmp/test.yaml' :
    ensure  => present,
    content => template('test.yaml.erb'),
  }
}
