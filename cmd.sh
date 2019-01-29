#!/bin/sh

set -e

gcloud auth activate-service-account --key-file=/keyFile

echo "checking for existing cloud nat"

if eval "gcloud compute routers nats describe $name --project $projectId" >/dev/null 2>&1
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
if [ "$description" != " " ]; then
  cloudNatCreateCmd=$(printf "%s --description" "$description")
fi

eval "$cloudNatCreateCmd"