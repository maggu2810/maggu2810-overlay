#!/bin/bash
# Copyright (c) 2015 DisplayLink (UK) Ltd.

PM_I=$DLM_DIR/PmMessagesPort_in
PM_O=$DLM_DIR/PmMessagesPort_out

suspend_dlm()
{
  #flush any bytes in pipe
  while read -n 1 -t 1 SUSPEND_RESULT < $PM_O; do : ; done;

  #suspend DisplayLinkManager
  echo "S" > $PM_I

  #wait until suspend of DisplayLinkManager finish
  read -n 1 -t 10 SUSPEND_RESULT < $PM_O
}

resume_dlm()
{
  #resume DisplayLinkManager
  echo "R" > $PM_I
}

case "$1/$2" in
  pre/*)
    suspend_dlm
    ;;
  post/*)
    resume_dlm
    ;;
esac
