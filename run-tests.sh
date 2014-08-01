#!/bin/bash

cd template
haxe template.hxml
cd ../test
haxe BelugaTest.hxml && sudo cp -r ./bin/php/* /var/www/html/