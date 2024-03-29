# jira-worklog

A simple [Bash](https://www.gnu.org/software/bash/) wrapper for [ankitpokhrel/jira-cli](https://github.com/ankitpokhrel/jira-cli) to convert a text file into [Jira](https://www.atlassian.com/software/jira) issue worklog entries. The wrapper is build to fit my workflow where the work is recorded during the day and only saved to Jira in the end of the day.

Requires:

* [ankitpokhrel/jira-cli](https://github.com/ankitpokhrel/jira-cli)
* [hroptatyr/dateutils](https://github.com/hroptatyr/dateutils)
  * Note in Ubuntu the commands are different than in documentation. The commands are prefixed with `dateutils` to avoid name collisions. See `man dateutils` for the details.

## Tools

* `worklog.sh` - report the working time recorded in the worklog file to Jira.
* `worklog-init.sh` - create the initial worklog file for the current day.

## Worklog Text File Format

Lines starting with `#` are comments and are ignored.

The file has one header row and one or more worklog rows:
```
<HEADER>
<WORKLOG>
...
```

where `<HEADER>` is
```
started: <TIMESTAMP> <TIMEZONE>
```

where:

* `started:` is a fixed value
* `<TIMESTAMP>` is the start time of the first task in the form of `YYYY-MM-DD HH:MI:SS`
* `<TIMEZONE>` is the [time zone name](https://en.wikipedia.org/wiki/Tz_database#Names_of_time_zones) in the form of `Area/Location`

where `<WORKLOG>` is
```
<JIRA_ISSUE>|<TIME>|<DESCRIPTION>
```

where:

* `<JIRA_ISSUE>` is the JIRA issue identifier
* `<TIME>` is how much time will be logged in form of `Nh Nm` where `N` is a positive integer
* `<DESCRIPTION>` is the worklog description

The worklog start times are calculated automatically.

Worklog row colums are trimmed so you can align the colums how you like.

For example the file:
```
started: 2023-10-07 08:00:00 Europe/Helsinki
XZ-140  |   15m|Lorem ipsum
ABC-5457|   15m|Dolor sit amet
FOOB-6  |4h 30m|Consectetur adipiscing elit
ZOO-8077|3h    |Sed do eiusmod tempor incididunt
```

will be converted to the following jira-cli calls:
```
jira issue worklog add "XZ-140" "15m" --comment "Lorem ipsum" --no-input --started "2023-10-07 08:00:00" --timezone "Europe/Helsinki"
jira issue worklog add "ABC-5457" "15m" --comment "Dolor sit amet" --no-input --started "2023-10-07 08:15:00" --timezone "Europe/Helsinki"
jira issue worklog add "FOOB-6" "4h 30m" --comment "Consectetur adipiscing elit" --no-input --started "2023-10-07 08:30:00" --timezone "Europe/Helsinki"
jira issue worklog add "ZOO-8077" "3h" --comment "Sed do eiusmod tempor incididunt" --no-input --started "2023-10-07 13:00:00" --timezone "Europe/Helsinki"
```

## Vim Syntax Highlighting

In the example below replace the worklog file path and ticket type(s) to match your case.

File `~/.vim/ftdetect/worklog.vim`:
```
autocmd BufRead,BufNewFile ~/worklog/*.csv setfiletype worklog
```

File: `~/.vim/syntax/worklog.vim`:
```
if exists("b:current_syntax")
    finish
endif

syntax match worklogHeader /^started:\s\d\{4}-\d\{2}-\d\{2}\s\d\{2}:\d\{2}:\d\{2}\s.\+$/
syntax match worklogComment /^#.*/
syntax match worklogTicketType1 /^XZ-140\|XZ-143\|XZ-526/
syntax match worklogTicketType2 /^FOOB-[126]/
syntax match worklogTicketType3 /^ABC-\d\+/
syntax match worklogTableSeparator /|/

highlight link worklogHeader Constant
highlight link worklogComment Comment
highlight link worklogFixedTicket Statement
highlight link worklogMiscTicket Statement
highlight link worklogDevTicket Statement
highlight link worklogTableSeparator Comment

let b:current_syntax = "worklog"
```
