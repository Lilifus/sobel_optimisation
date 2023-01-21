#!/bin/bash

define=("BASELINE" "UNROLLED" "SSE" "SQRTLESS" "THREADS" "ALL")
opti=("-march=native -O1" "-march=native -O1 -funroll-loops" "-march=native -O1 -ftree-vectorize" "-march=native -Ofast")
mkdir -p datas
IFS=%
for j in ${opti[@]}
do
    for i in ${define[@]} 
    do
        make -B DEFINE=$i OFLAGS=$j >/dev/null;
        echo $i$j;
        ./sobel in/input.raw out/output.raw 2>datas/$(echo $i$j|sed 's/ //g')_stderr.dat 1>datas/$(echo $i$j|sed 's/ //g').dat;
        # gnuplot -c option.gp $(echo $i|sed 's/ //g')
    done
    # gnuplot -c version.gp $(echo $i|sed 's/ //g')
done
clangopti=("-march=native -O1" "-march=native -Ofast")
for j in ${clangopti[@]}
do
    for i in ${define[@]} 
    do
        make -B CC=clang DEFINE=$i OFLAGS=$j >/dev/null;
        echo $i$j;
        ./sobel in/input.raw out/output.raw 2>datas/clang$(echo $i$j|sed 's/ //g')_stderr.dat 1>datas/clang$(echo $i$j|sed 's/ //g').dat;
        # gnuplot -c clangoption.gp $(echo $i|sed 's/ //g')
    done
    # gnuplot -c clangversion.gp $(echo $i|sed 's/ //g')
done
unset IFS
