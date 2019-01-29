#!/bin/sh

set -e

gcloud auth activate-service-account --key-file=/keyFile

echo "checking for existing cloud nat"

if eval "gcloud compute routers nats describe $name --project $projectId --router $router" >/dev/null 2>&1
then
  echo "found exiting cloud nat"
  exit
else
  echo "existing cloud nat not found"
fi

echo "creating cloud nat..."
cloudNatCreateCmd="gcloud compute routers nats create $name"
cloudNatCreateCmd=$(printf "%s --project %s" "$cloudNatCreateCmd" "$projectId")
cloudNatCreateCmd=$(printf "%s --router %s" "$cloudNatCreateCmd" "$router")

# handle opts
if [ "$async" = "true" ]; then
  cloudNatCreateCmd=$(printf "%s --async" "$cloudNatCreateCmd")
fi
if [ "$autoAllocateNatExternalIps" = "true" ]; then
  cloudNatCreateCmd=$(printf "%s --auto-allocate-nat-external-ips" "$cloudNatCreateCmd")
fi
if [ "$description" != " " ]; then
  cloudNatCreateCmd=$(printf "%s --description %s" "$cloudNatCreateCmd" "$description")
fi
if [ "$icmpIdleTimeout" != " " ]; then
  cloudNatCreateCmd=$(printf "%s --icmp-idle-timeout %s" "$cloudNatCreateCmd" "$icmpIdleTimeout")
fi
if [ "$minPortsPerVm" != "-1" ]; then
  cloudNatCreateCmd=$(printf "%s --min-ports-per-vm %s" "$cloudNatCreateCmd" "$minPortsPerVm")
fi
if [ "$natExternalIpPool" != " " ]; then
  cloudNatCreateCmd=$(printf "%s --nat-external-ip-pool %s" "$cloudNatCreateCmd" "$natExternalIpPool")
fi
if [ "$natAllSubnetIpRanges" = "true" ]; then
  cloudNatCreateCmd=$(printf "%s --nat-all-subnet-ip-ranges" "$cloudNatCreateCmd")
fi
if [ "$natCustomSubnetIpRanges" != " " ]; then
  cloudNatCreateCmd=$(printf "%s --nat-custom-subnet-ip-ranges %s" "$cloudNatCreateCmd" "$natCustomSubnetIpRanges")
fi
if [ "$natPrimarySubnetIpRanges" = "true" ]; then
  cloudNatCreateCmd=$(printf "%s --nat-primary-subnet-ip-ranges" "$cloudNatCreateCmd")
fi
if [ "$tcpEstablishedIdleTimeout" != " " ]; then
  cloudNatCreateCmd=$(printf "%s --tcp-established-idle-timeout %s" "$cloudNatCreateCmd" "$tcpEstablishedIdleTimeout")
fi
if [ "$tcpTransitoryIdleTimeout" != " " ]; then
  cloudNatCreateCmd=$(printf "%s --tcp-transitory-idle-timeout %s" "$cloudNatCreateCmd" "$tcpTransitoryIdleTimeout")
fi
if [ "$udpIdleTimeout" != " " ]; then
  cloudNatCreateCmd=$(printf "%s --udp-idle-timeout %s" "$cloudNatCreateCmd" "$udpIdleTimeout")
fi

eval "$cloudNatCreateCmd"