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