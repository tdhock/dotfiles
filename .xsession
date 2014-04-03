#!/bin/bash
. ~/.bashrc
#export PATH=$HOME/bin:/local/usr/R/R/lib64/R/bin:$PATH
if [ -z $(which urxvt) ];then
    cmd="gnome-terminal --geometry="
    dist=800
else
    cmd="urxvt -geometry "
    dist=850
fi
export BROWSER=firefox
##emacs --no-site-file -g 80x80+0+0 &
if [ -z $(which emacs22) ];then
    emacs=emacs
else
    emacs=emacs22
fi
$emacs -g +0+0 --no-site-file -fh &
${cmd}+1200+0 -e htop --sort-key PERCENT_MEM &
${cmd}+660+0 -e htop &
${cmd}+660+340 -e bash &
${cmd}+660+${dist} -e bash &
${cmd}+1200+${dist} -e bash &
firefox&

