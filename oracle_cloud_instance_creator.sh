#!/bin/bash

# To verify that the authentication with Oracle cloud works
echo "Checking Connection with this request: "
oci iam compartment list
if [ $? -ne 0 ]; then
    echo "Connection to Oracle cloud is not working. Check your setup and config again!"
    exit 1
fi

# Don't go too low or you run into 429 TooManyRequests
requestInterval=60 # seconds

# ----------------------ENDLESS LOOP TO REQUEST AN ARM INSTANCE---------------------------------------------------------

while true; do

    oci compute instance launch --no-retry  \
    --auth api_key \
    --profile "DEFAULT" \
    --display-name big-arm \
    --compartment-id "$TENANCY_ID" \
    --image-id "$IMAGE_ID" \
    --subnet-id "$SUBNET_ID" \
    --availability-domain "$AVAILABILITY_DOMAIN" \
    --shape 'VM.Standard.A1.Flex' \
    --shape-config "{'ocpus'4,'memoryInGBs':24}" \
    --boot-volume-size-in-gbs "50" \
    --ssh-authorized-keys-file "$PATH_TO_PUBLIC_SSH_KEY"

    sleep $requestInterval
done
