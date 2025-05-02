#!/usr/bin/env bash

FREEDESKTOP_SOUND_PATH="/usr/share/sounds/freedesktop/stereo/"
ALARM_SOUND="${FREEDESKTOP_SOUND_PATH}alarm-clock-elapsed.oga"
NOTIF_SOUND="${FREEDESKTOP_SOUND_PATH}bell.oga"
BELL_SOUND="${FREEDESKTOP_SOUND_PATH}complete.oga"

view_task() {

  notify-send -u normal -t 30000 "Current Task" "Hello"
}
