#!/bin/bash

logfile="ci4gpu.log"
function now() {
    echo "[$(date +"%Y-%m-%d_%H:%M:%S")]"
}

now >> $logfile
echo "CI4GPU - connection succesful" >> $logfile
echo "Preparing system" >> $logfile

module load cuda10.1
alias gpurun="srun -N 1 -C TitanX --gres=gpu:1"

now >> $logfile
echo "Compiling saxpy" >> $logfile
nvcc saxpy.cu -o saxpy > $logfile 2>&1

echo "Sending saxpy to gpu" >> $logfile
gpurun saxpy > $logfile 2>&1