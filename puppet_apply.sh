#!/bin/bash

# Apply Puppet manifests
puppet apply \
    --test \
    --confdir=. \
    --ssldir=/tmp/puppet_ssl \
    --templatedir=./templates \
    $@ \
    ./site.pp

# Or you can use ERB directly:
# $ erb -r ostruct -T '-' 'ini_data={"aaa" => "bbb", "ccc" => {"ddd" => "eee"}}' ./templates/test.ini.erb
