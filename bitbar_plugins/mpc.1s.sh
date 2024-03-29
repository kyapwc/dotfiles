#!/bin/bash
export PATH=/usr/local/bin:$PATH

if [[ "$1" = "play" ]]; then
  mpc play
fi

if [[ "$1" = "pause" ]]; then
  mpc pause
fi

if [[ "$1" = "next" ]]; then
  mpc next
fi

if [[ "$1" = "prev" ]]; then
  mpc prev
fi

echo "$(mpc status | awk 'NR==1{print substr($0, index($0,$100))}') | length=50"
echo $(mpc status | awk 'NR==2 { split($3, a, "/"); print a[1] }')
echo "Pause | bash='$0' param1=pause terminal=false"
echo "Play | bash='$0' param1=play terminal=false"
echo "Next | bash='$0' param1=next terminal=false"
echo "Previous | bash='$0' param1=prev terminal=false"
