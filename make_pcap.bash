#!/bin/bash

while getopts n:d: flag
do
    case "${flag}" in
        n) num_sigs=${OPTARG};;
        d) duration=${OPTARG};;
    esac
done

echo "Num Sigs: ${num_sigs}"
echo "Duration: ${duration}"

echo "Precomputing Signatures..."
python3.8 src/python/edu/princeton/tango/controlplane/precompute_sigs.py temp.pickle ${duration} ${num_sigs}

echo "Marshalling into Pcap..."
python3.8 src/python/edu/princeton/tango/controlplane/create_pcap.py --file temp.pickle --seqblksz $((${num_sigs}/32)) --tsblksz ${duration}

