#!/usr/bin/env bash

cd Lambda/Auth

rm *.zip

for f in $(ls); do
    zip -9 $f.zip $f/*
done