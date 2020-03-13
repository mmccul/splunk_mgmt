# Overview

A pre-receive hook blocks the push to the git server.  This hook was written for github, but
the concept would work on gitlab or other VCS systems.  Adjust the list of filenames as
appropriate for your needs.

The idea of this hook is to permit users to have selected repos that are in git to hold 
their dashboards, and user level configs, and have it fully backed up in git as the source
of record of the dashboards for rapid redeployment in case of a problem, as well as easy
rollback in case of bad modifications.

# Usage

Create a dedicated repo and add this hook (and all variations you need) in that repo.  Then
attach the hooks to each Splunk app depending on the nature of the repo.  A repo for people
to do XML dashboards, datamodels, and maybe a props.conf or KVstore is well served by this
sample.

# What about admin files?

Do not attach this hook to a repo intended to hold administrative configurations, but do not
open it up for anyone but trusted administrators to write to either.  

