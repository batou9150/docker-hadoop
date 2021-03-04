#!/bin/bash
. ./functions.sh

configure

download

exec $@
