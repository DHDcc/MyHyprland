#!/bin/bash

city="Paris"

curl -s "wttr.in/$city?format=%l+%c|+%C+%t\n" 2>/dev/null
