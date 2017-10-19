#!/bin/bash

svn st | grep '^?' | awk '{ print $2}' | while read f; do svn add $f; done
