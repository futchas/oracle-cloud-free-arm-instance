# Oracle Cloud Free ARM Instance
A bash script to create an ARM instance on Oracle Cloud using their official OCI command line tool (CLI).

Oracle's free tier offers a generous ARM instance with 4 cors and 24gb of memory. Compared to most other services, that is a pretty good free plan to start with. The only problem is that the resources are very limited for users in the free plan. If you want to create an instance through their website, you usually run into an error: **Out of Capacity**. It means that there aren't enough free resources available. Instead of clicking endless times in the browser, we can automate the instance creation request.

**Inspired by** following PowerShell Windows solution: https://github.com/HotNoob/Oracle-Free-Arm-VPS-PS/tree/main

**Differences**:
- I am using Bash and Linux
- API key to authenticate without time limit as opposed to sessions limited to 1 hour
- Script allows additional customizations like boot volume disk size and a SSH key to connect to the instance
- Script was simplified and shows the whole error response (see [screenshot](screenshot.png))
- More documentation and step by step explanation

## Setup 
1. Install the Oracle cloud CLI for Linux/Unix: https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm#InstallingCLI__linux_and_unix
2. Login to your Oracle Cloud account in the browser: https://cloud.oracle.com/
3. Go to Profile -> My Profile (User information OCID) and copy the **user ocid** somewhere
4. Go to Profile -> Tenancy (Tenancy information OCID) and copy the value into the [.env file](.env) in the variable `TENANCY_ID`
5. Go to Profile -> My profile -> API keys 
   - Click on "Add API key" and download the private and public key
6. Configure OCI by running following command in your terminal: `oci setup config`
   - In the console prompt fill in the **user ocid (step 3**) and **tenancy ocid (step 4)**
   - Select your region number (e.g. type in `24` for `eu-frankfurt-1`)
   - Press `n` to use the existing key previously generated
   - Provide the path to the private key file previously downloaded in step 5
   - Config should be written now and we already added the API key in step 5
   - **Note**: In case you are asked for a profile name: Type in "DEFAULT"

7. Execute following command to get a list of possible images. Select one and copy it into the [.env](.env) variable `IMAGE_ID`:
```
oci compute image list --all -c "$TENANCY_ID" --auth api_key | jq -r '.data[] | select(.["display-name"] | contains("aarch64")) | "\(.["display-name"]): \(.id)"'
```
8. To get a list of possible Subnets, which you can save in the [.env](.env) variable `SUBNET_ID`:
```
oci network subnet list -c "$TENANCY_ID" --auth api_key | jq -r '.data[] | "\(.["display-name"]): \(.id)"'
```
9. Copy the availability domain into the [.env](.env) variable `AVAILABILITY_DOMAIN`:
```
oci iam availability-domain list -c "$TENANCY_ID" --auth api_key | jq -r '.data[].name'
```
10. Lastly change the variable `PATH_TO_PUBLIC_SSH_KEY` in the [.env](.env) file. That;s the path to a public SSH key on your machine to connect to the ARM instance once it's created
   - Either download it from the Oracle Cloud instance creation website or [generate an ssh key yourself](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key)  
Finally, we are done with the setup (hardest part)

## Customize (optional)
Inside the file `/oracle_cloud_instance_creator.sh` you will find a section to change following parameters:

CPU cores, memory in gb, boot volume disk space, path to public SSH key, interval of the creation request

## Run script 
- Open the terminal and go to the path of this repo
- make sure the creator script can be executed 
```
chmod +x oracle_cloud_instance_creator.sh
```
- Run the script with:
```
./oracle_cloud_instance_creator.sh
```
Every minute (default `requestInterval`) the script will request an instance. The console will print a JSON `ServerError` response until the instance creation was successful. The creation could take days or in some cases weeks/months. You could run it on your machine, but I'd recommend to create a simple free AMD instance first and run it there in the background.
