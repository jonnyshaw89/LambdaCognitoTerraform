#!/usr/bin/env bash

find ./Lambda/* -maxdepth 2 -name package.json -execdir npm install \;

cd Lambda/Auth

rm *.zip

for f in $(ls); do
    zip -9 -r $f.zip $f/*
done