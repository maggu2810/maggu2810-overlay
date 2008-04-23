#!/bin/bash
find | grep -v \.svn | xargs -I° svn add °
