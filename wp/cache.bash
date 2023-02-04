#!/bin/bash
# Sets wp cache plugins on or off
# args [on|off]

if [ "$1" = "on" ]; then
#wp plugin deactivate $(wp plugin list --status=active --field=name | grep -E '^(w3-total-cache|wp-fastest-cache|cachify|litespeed-cache|cache-enabler|hyper-cache|sg-cachepress|swift-performance-lite|comet-cache|gator-cache|wp-optimize|autoptimize)$')

fi