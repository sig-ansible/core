#!/bin/bash

#
# Note this script has a minor modification from the one one Oracle gives based on
# Lance Hoover's contribution here:
#   https://ecommunities.ellucian.com/thread/44677
#

# Check for the kernel version
KERN=`uname -r | awk -F. '{ printf("%d.%d\n",$1,$2); }'`
# Find out the HugePage size
HPG_SZ=`grep Hugepagesize /proc/meminfo | awk {'print $2'}`
# Start from 1 pages to be on the safe side and guarantee 1 free HugePage
NUM_PG=1
# Cumulative number of pages required to handle the running shared memory segments
for SEG_BYTES in `ipcs -m | awk {'print $5'} | grep "[0-9][0-9]*"`
do
   MIN_PG=`echo "$SEG_BYTES/($HPG_SZ*1024)" | bc -q`
   if [ $MIN_PG -gt 0 ]; then
      NUM_PG=`echo "$NUM_PG+$MIN_PG+1" | bc -q`
   fi
done
# Finish with results
case $KERN in
    '3.10') printf "Recommended setting: vm.nr_hugepages = $NUM_PG\n$NUM_PG" ;;
    '4.1') printf "Recommended setting: vm.nr_hugepages = $NUM_PG\n$NUM_PG" ;;
    '4.14') printf "Recommended setting: vm.nr_hugepages = $NUM_PG\n$NUM_PG" ;;
    *)
        echo "Kernel version $KERN is not supported by this script (yet)."
        exit 1
        ;;
esac
