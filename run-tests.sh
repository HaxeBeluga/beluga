#!/bin/bash

cd haxelib
haxe beluga.hxml
cd ..
haxelib run beluga setup_project templateTest
cd templateTest
haxe templateTest.hxml
cd ../test
haxe BelugaTest.hxml