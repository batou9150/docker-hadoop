#!/bin/bash

confd -onetime -backend env -confdir /etc/confd-livy/

exec $@
