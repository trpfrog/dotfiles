#!/usr/bin/env perl
# latex
$latex            = 'uplatex -halt-on-error';
$latex_silent     = 'uplatex -halt-on-error -interaction=batchmode';
# bibtex
$bibtex           = 'upbibtex';
# dvi/pdf
$dvipdf           = 'dvipdfmx %O -o %D %S';$pdf_mode         = 3;
# index
$makeindex        = 'mendex %O -o %D %S';
# viewer
$pdf_previewer    = 'open -a Skim';