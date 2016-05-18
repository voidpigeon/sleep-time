# sleep-time
Have you ever fallen asleep at your computer and wondered how much sleep you got? I know I have.

## How it works
The ruby script listens to `/dev/input/event0` and `/dev/input/mice` and remembers the last time you moved the mouse or typed a key. If you do nothing for over 30 minutes, it assumes you fell asleep and writes the time to `log.txt`.

## How to use it
Just run `sudo bash start.sh`. It needs root access in order to read from `/dev/input`. The script runs in the background.

To end the script, run `sudo killall ruby` or kill the process in another way if you have another important ruby script running.

## Configuration
`config.conf` contains options to change the behavior of the script:
* `seconds_cutoff` --- inactivity time in seconds necessary to consider the user asleep
* `time_format` --- controls how the time is written to the log file
* `check_mouse` --- if set to NO, mouse movement will not be considered activity
