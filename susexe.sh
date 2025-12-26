#!/bin/bash

SEARCH_PATHS=(
    /home
    /tmp
    /var/tmp
    /opt
)

find "${SEARCH_PATHS[@]}" \
    -type f \
    -perm /111 \
    -printf '%p | %f | %TY-%Tm-%Td %TH:%TM:%TS\n' 2>/dev/null
