#!/bin/sh
mkdir -p /tmp/www/
cp ./index.html /tmp/www/
python3 -m http.server --directory /tmp/www/
