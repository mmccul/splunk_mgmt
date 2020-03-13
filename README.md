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

## Index access

To enable access to indexes, I create dedicated roles that do not inherit anything, just authorize one or more indexes.  Since an individual can be a member of multiple roles, the permissions are additive, it is easier to manage and works well with an AD or LDAP or SAML integrated system.

# Maintenance

One thing that turned out to be key to the success of this methodology is periodically looking
for stuff in local.  Something might slip in during an emergency and not get into git.
