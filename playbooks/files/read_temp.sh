#!/bin/bash

export LD_LIBRARY_PATH=/opt/vc/lib

systemd-cat -t temp /opt/vc/bin/vcgencmd measure_temp
