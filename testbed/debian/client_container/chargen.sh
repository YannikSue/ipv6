#!/bin/bash

strg=""; for n in {32..126}; do  c=`printf '%x' $n | xxd -r -p`; strg=${strg}${c}; done;
strg=${strg}${strg}; n=0; while :; do m=n%95; echo "${strg:m:72}"; n=$((n+1)); sleep .1; done;
