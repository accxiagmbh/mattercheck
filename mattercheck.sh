#!/usr/bin/python
import os, sys
import requests
import json

#edit these variables
mattermost_hook = "/hooks/yoursecret"
if "NOTIFY_PARAMETER_1" in os.environ:
    channel = "#" + os.environ['NOTIFY_PARAMETER_1']
else:
    channel = '#channel_you_like_to_post_in'
    bot_name = "the_bot_name_goes_here"

mattermost_domain = "https://mattermost.yourdomain.tld"
headers = {"Content-type": "application/json", "Accept": "text/plain"}
message = "*" + os.environ['NOTIFY_NOTIFICATIONTYPE'] + "* "
plaintext = message
message += "\n" + os.environ['NOTIFY_HOSTNAME'] + " "
plaintext += os.environ['NOTIFY_HOSTNAME'] + " "

color_emoji_json = """{
    "_comment": "NOTIFY_NOTIFICATIONTYPE",
    "DOWNTIMESTART": { "color": "#439FE0", "emoji": ":moon:" },
    "DOWNTIMEEND": { "color": "#33cccc", "emoji": ":sunrise:" },
    "ACKNOWLEDGEMENT": { "color": "#8f006b", "emoji": ":flags:" },
    "_comment": "NOTIFY_SERVICESTATE",
    "CRITICAL": { "color": "danger", "emoji": ":fire:" },
    "WARNING": { "color": "warning", "emoji": ":warning:" },
    "UNKNOWN": { "color": "#cccccc", "emoji": ":question:" },
    "OK": { "color": "good", "emoji": ":ok:" },
    "_comment": "NOTIFY_HOSTSTATE warning and unknown already defined will reuse for consistence",
    "DOWN": { "color": "danger", "emoji": ":fire:" },
    "UP": { "color": "good", "emoji": ":ok:" },
    "_comment": "when we can not find a matching style",
    "parseerror": { "color": "#aaaaaa", "emoji": ":octocat:" }
}"""

def event_style():
    styles = json.loads(color_emoji_json)
    if 'NOTIFY_NOTIFICATIONTYPE' in os.environ:
        if os.environ['NOTIFY_NOTIFICATIONTYPE'] in styles: return styles[os.environ['NOTIFY_NOTIFICATIONTYPE']]
    else: return styles['parseerror']
    if 'NOTIFY_WHAT' in os.environ:
        if os.environ['NOTIFY_WHAT'] == 'SERVICE':
            if 'NOTIFY_SERVICESTATE' in os.environ:
                if os.environ['NOTIFY_SERVICESTATE'] in styles: return styles[os.environ['NOTIFY_SERVICESTATE']]
                else: return styles['parseerror'] 
            else: return styles['parseerror'] 
        else: 
            if 'NOTIFY_HOSTSTATE' in os.environ:
                if os.environ['NOTIFY_HOSTSTATE'] in styles: return styles[os.environ['NOTIFY_HOSTSTATE']]
                else: return styles['parseerror'] 
            else: return styles['parseerror']
    else: return styles['parseerror'] 
    return styles['parseerror']


if os.environ['NOTIFY_WHAT'] == 'SERVICE':
    message += "  " + os.environ['NOTIFY_SERVICEDESC'] + " is *"
    plaintext += os.environ['NOTIFY_SERVICEDESC'] + " - *"
    message += os.environ['NOTIFY_SERVICESTATE'] + "* \n`"
    message += os.environ['NOTIFY_SERVICEOUTPUT'] + "` \n"
    message += os.environ['NOTIFY_SERVICEACKCOMMENT']
    plaintext += os.environ['NOTIFY_SERVICESTATE'] + "* - "
    plaintext += os.environ['NOTIFY_SERVICEOUTPUT']
    if os.environ['NOTIFY_NOTIFICATIONAUTHOR'] != '':
        message += "\nTriggered by *" + os.environ['NOTIFY_NOTIFICATIONAUTHOR'] + "* - _" + os.environ['NOTIFY_NOTIFICATIONCOMMENT']  + "_"
    if os.environ['NOTIFY_NOTIFICATIONTYPE'] == 'ACKNOWLEDGEMENT':
        plaintext += " - " + os.environ['NOTIFY_SERVICEACKCOMMENT']

else:
    message += "is *" + os.environ['NOTIFY_HOSTSTATE'] + "* "
    plaintext += "is *" + os.environ['NOTIFY_HOSTSTATE'] + "* - "
    message += os.environ['NOTIFY_HOSTACKCOMMENT']
    if os.environ['NOTIFY_NOTIFICATIONAUTHOR'] != '':
        message += "\nTriggered by *" + os.environ['NOTIFY_NOTIFICATIONAUTHOR'] + "* - _" + os.environ['NOTIFY_NOTIFICATIONCOMMENT']  + "_"

event_style = event_style()

attachment = { "fallback": plaintext, "color": event_style['color'],  "text":  message, "mrkdwn_in": ["text"]}
data = {"channel": channel, "username": bot_name, "attachments": [attachment], "icon_emoji": event_style['emoji']}

conn = requests.post(mattermost_domain+mattermost_hook,data = json.dumps(data))

print(conn.status_code)



#Copyright [2019] [Accxia GmbH]

#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at

#    http://www.apache.org/licenses/LICENSE-2.0

#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.
