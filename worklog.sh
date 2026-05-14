#!/bin/bash

set -o errexit

: "${JIRA_API_TOKEN:?JIRA_API_TOKEN environment variable is required}"

{
    read dummy started_date started_time timezone
    declare started="${started_date} ${started_time}"
    while IFS=\| read col1 col2 rest
    do
        declare issue=$(echo $col1 | xargs)
        declare time=$(echo $col2 | xargs)
        declare comment=$rest

        jira issue worklog add "${issue}" "${time}" --comment "${comment}" --no-input --started "${started}" --timezone "${timezone}"

        started=$(dateutils.dadd --format='%F %T' "${started}" "${time}")
    done
} < <(grep -v '#')
