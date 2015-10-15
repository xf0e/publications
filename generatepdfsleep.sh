#!/bin/bash

tmo=900                 #15 minutes, the maximum amount of time the compilers get per session
                        #to ensure this script will always and pdflatex won't get it in an infinite loop
tim=1                   #1 second, the amount of time between two compilation sequences

pint="nonstopmode"      #The interaction mode used for pdflatex
popt="-file-line-error" #additional options for pdflatex

dts=$(date)             #The date string at which compiling started

bsf="$1"                #The base file name, used to generate derivative products
pdff="$bsf.pdf"         #The resulting pdf file
texf="$bsf.tex"         #The main tex file

TEXINPUTS="$TEXINPUTS:../libtex//:../SharedData//"
export TEXINPUTS

timeout $tmo pdflatex $popt --interaction $pint "$texf" >/dev/null 2>/dev/null
timeout $tmo makeglossaries -q "$bsf" >/dev/null 2>/dev/null
timeout $tmo makeindex -q "$bsf" >/dev/null 2>/dev/null
sleep $tim

timeout $tmo pdflatex $popt --interaction $pint "$texf" >/dev/null 2>/dev/null
timeout $tmo bibtex "$bsf" >/dev/null 2>/dev/null
timeout $tmo makeglossaries -q "$bsf" >/dev/null 2>/dev/null
timeout $tmo makeindex -q "$bsf" >/dev/null 2>/dev/null
sleep $tim

timeout $tmo pdflatex $popt --interaction $pint "$texf" >/dev/null 2>/dev/null
timeout $tmo bibtex "$bsf" >/dev/null 2>/dev/null
timeout $tmo makeglossaries -q "$bsf" >/dev/null 2>/dev/null
timeout $tmo makeindex -q "$bsf" >/dev/null 2>/dev/null
sleep $tim

timeout $tmo pdflatex $popt --interaction $pint "$texf" >/dev/null 2>/dev/null
timeout $tmo bibtex "$bsf" >/dev/null 2>/dev/null
timeout $tmo makeglossaries -q "$bsf" >/dev/null 2>/dev/null
timeout $tmo makeindex -q "$bsf" >/dev/null 2>/dev/null
sleep $tim

time -f '%S' timeout $tmo pdflatex $popt --interaction $pint "$texf"

if [ -f "$pdff" ] #make sure the create/access/modification time is set to the time `make` was called.
then              #such that modifications while compiling trigger a new compiler run
    touch -d "$dts" "$pdff"
fi
