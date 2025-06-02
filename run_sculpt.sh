windows sucks:
to run sculpt

"C:\Program Files\Coreform Cubit 2025.1\bin\sculpt" -mpi "C:\Program Files\Coreform Cubit 2024.8\bin\mpiexec" -j 16 -i sculpt_parallel.i

epu

"C:\Program Files\Coreform Cubit 2025.1\bin\epu" -p 16 sculpt_parallel.diatom_result




#!/bin/bash

numprocs=36

case "$1" in
     "s" )
        echo "running sculpt";
        rm sculpt_parallel.diatom_result.e.*
        sculpt -mpi /mnt/data0/Noah/bin/software/cubit/Coreform-Cubit-2024.3/bin/mpiexec -j $numprocs -i sculpt_parallel.i 2>&1 > sculpt_parallel.log &;;
     "e" )
        echo "running epu";
        rm sculpt_parallel.diatom_result.e
        epu -p $numprocs sculpt_parallel.diatom_result;;
     *) echo >&2 "Invalid option: $@"; echo >&2 "use s for sculpt and e for epu"; exit 1;;
esac

