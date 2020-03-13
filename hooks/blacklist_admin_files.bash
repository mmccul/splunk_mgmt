#!/usr/bin/env bash

#
# Pre-receive hook that will block any new commits that contain files ending
# with a filename suggesting it could contain administrative content
#
# This is a trivially modified version of https://github.com/github/platform-samples/blob/master/pre-receive-hooks/block_file_extensions.sh
#
# More details on pre-receive hooks and how to apply them can be found on
# https://help.github.com/enterprise/admin/guides/developer-workflow/managing-pre-receive-hooks-on-the-github-enterprise-appliance/
#

zero_commit="0000000000000000000000000000000000000000"

# Do not traverse over commits that are already in the repository
# (e.g. in a different branch)
# This prevents funny errors if pre-receive hooks got enabled after some
# commits got already in and then somebody tries to create a new branch
# If this is unwanted behavior, just set the variable to empty
excludeExisting="--not --all"

while read oldrev newrev refname; do
  # echo "payload"
  echo $refname $oldrev $newrev

  # branch or tag get deleted
  if [ "$newrev" = "$zero_commit" ]; then
    continue
  fi

  # Check for new branch or tag
  if [ "$oldrev" = "$zero_commit" ]; then
    span=`git rev-list $newrev $excludeExisting`
  else
    span=`git rev-list $oldrev..$newrev $excludeExisting`
  fi

  for COMMIT in $span;
  do
    for FILE  in `git log -1 --name-only --pretty=format:'' $COMMIT`;
    do
      case $FILE in
      # *.zip|*.gz|*.tgz )
      *alert_actions.conf|*app.conf|*audit.conf|*authentication.conf|*authorize.conf|*checklist.conf|*commands.conf|*deployment.conf|*deploymentclient.conf|*distsearch.conf|*federated.conf|*health.conf|*indexes.conf|*inputs.conf|*instance.cfg.conf|*limits.conf|*outputs.conf|*restmap.conf|*server.conf|*serverclass.conf|*setup.xml.conf|*splunk-launch.conf|*times.conf|*web.conf )
        printf "No admin files are allowed to be submitted to this repo.  Undo your commit and remove\nthose files and try again.  If you really can't figure this out, contact your Splunk admin.\n"
       *passwords.conf )
         printf "Passwords, even encrypted, are not allowed to be submitted to git.  Undo your commit and\ntry again.\n"
        exit 1
        ;;
      esac
    done
  done
done
exit 0
