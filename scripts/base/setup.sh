#!/bin/sh

if [ ! -d config ]
  then
    mkdir config
fi

if [ ! -d config/active ]
  then
    mkdir config/active
fi

if [ ! -d config/staging ]
  then
    mkdir config/staging
fi

if [ ! -d config/sync ]
  then
    mkdir config/sync
fi
