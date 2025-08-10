# CAUTION

Red Hat broke SSH forced commands, allowing someone to use sftp to overwrite the authorized_keys file, even if that isn't
supposed to be permitted by their authorized_keys contents.  This method is no longer safe on RHEL until that
vulnerability is fixed.

# Installation

Install this script into a common location and make it executable, e.g.
**/usr/local/bin/pulltrigger**

In ~splunk/.ssh/authorized_keys you prepend the key for the user with this forced command.
For example:

```
command="/usr/local/bin/pulltrigger" ssh-rsa AA...
```

If you were extra paranoid about disabling interactive login to account splunk, you need to
relax it.  This methodology does not permit interactive login.

# Usage
Assuming your instance is on a search head with FQDN *splunk.example.com*, and running as user
splunk:

    ssh splunk@splunk.example.com my_awesome_splunk_app

Just remember to look for the emoticon at the end.
