#!/usr/bin/env bash

cd Lambda/Auth

for f in $(ls); do
    zip -9 $f.zip $f/*
done