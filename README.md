# splunk_mgmt
A collection of tools and scripts to manage a Splunk installation better

# Contents

* .gitignore
  - You'll want to ensure you don't ever submit local files
* hooks/
  - To prevent people from submitting admin files
* forcecmd/
  - To allow users to automatically push their code to prod without giving them an interactive shell.

# Organizing your apps

What I have done is create one repo per app, each repo being its own directory structure.
Ensure that repos do not ever get local files, that's to allow system specific overrides.

Make separate repos for administrative configuration that have no write access to non-administrative staff, and no dashboards that anyone who isn't an admin has any business viewing, nevermind modifying.  

# Authorization

Key to this model is a very extensive authorize.conf  Do not assign the default roles (user, power, admin) to anyone.  Define a new set of roles to approximate what you need.

I typically use a perms_user that approximates the user role, but has no index access.  A separate role enables dashboard edits and creation of saved searches -- but is only deployed to the development search head so people can use the GUI to create saved searches.  (Others may not be that gentle).  Similarly, permissions related to dashboard creation and editing, etc. are all disabled on production.  Even the perms_admin role, do not enable making changes via GUI for the most part.  They need to make changes by config file.  

How to do this?  Take every single capability from the docs and run through this and ask yourself, is this something that should be allowed or does it encourage changes in the GUI instead of checking the changes into git?  

An example might be:
```
[role_perms_user]
export_results_is_visible = enabled
get_metadata = enabled
get_typeahead = enabled
list_inputs = enabled
pattern_detect = enabled
request_remote_tok = enabled
rest_apps_view = enabled
rest_properties_get = enabled
run_collect = enabled
run_mcollect = enabled
search = enabled
srchDiskQuote = 250
srchJobsQuota = 12

[role_perms_power]
importRoles = perms_user
accelerate_datamodel = enabled
edit_search_schedule_window = enabled
accelerate_search = enabled
input_file = enabled
output_file = enabled
srchIndexesAllowed = test

[role_perms_admin]
importRoles = perms_user, perms_power
srchIndexesAllowed = *
change_authentication = enabled
admin_all_objects = enabled
edit_encryption_key_provider = enabled
edit_watchdog = enabled
edit_health = enabled
edit_httpauths = enabled
edit_search_schedule_priority = enabled
license_edit = enabled
license_view_warnings = enabled
web_debug = enabled
refresh_application_licenses = enabled
list_health = enabled
list_introspection = enabled
rest_properties_get = enabled
run_debug_comands = enabled
list_workload_pools = enabled
edit_workload_pools = enabled
search_process_config_refresh = enabled
```

In the above example, the **perms_power** role is given access to index=test so that they can evaluate new inputs under testing.  THe exact permissions granted will vary depending on your needs, the important thing is to go through the entire list.  For example, if you use dbconnect, you need more permissions just for that.

## Index access

To enable access to indexes, I create dedicated roles that do not inherit anything, just authorize one or more indexes.  Since an individual can be a member of multiple roles, the permissions are additive, it is easier to manage and works well with an AD or LDAP or SAML integrated system.

# Maintenance

One thing that turned out to be key to the success of this methodology is periodically looking
for stuff in local.  Something might slip in during an emergency and not get into git.
