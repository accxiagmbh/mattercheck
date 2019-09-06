# mattercheck

[Check_MK](https://checkmk.com/) is a comprehensive Solution for IT Monitoring of applications, servers, and networks.
Checkmk is available as a Raw Edition, which is 100% open-source, and as an Enterprise Edition.   OMD or Open Monitoring Distribution is a bundle that includes Nagios & all the required plugins needed for monitoring.

This repo icludes a [Check_MK Python Script](https://checkmk.com/cms_notifications.html#scripts) to post Check_MK/OMD status messages to a specifed Mattermost channel via an incoming webhook. 

## Installation
1. Save the script on your Check_MK/OMD-Server in the notification folder (Default is `local/share/check_mk/notifications`)
2. Ensure that your scripts are executable (chmod +x ...). They will then be found automatically and made available for selection to the notification rules.
3. Configure your Check_MK instance to use the script as notification. 

### License 
Script provided under the Apache 2.0 License as it is by Accxia GmbH
