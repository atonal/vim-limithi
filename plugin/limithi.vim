" limithi.vim - Highlight line limits
" Description:  Per buffer, togglable syntax highlighting of line length
"               limits
" Author:       Tuukka Koistinen <tvkoisti@gmail.com>
" License:      Redistribution and use of this file, with or without
"               modification, are permitted without restriction.
"
" Section: Documentation {{{1
"
" This plugin will highlight line length limits, with the ability to toggle
" the highlighting on and off. This plugin is based on SpaceHi plugin by Adam
" Lazur.
"
" NOTE: "set list" will override LimitHi's highlighting.
"
" Highlighting can be turned on and off with the functions LimitHi() and
" NoLimitHi() respectively. You can also toggle the highlighting state by
" using ToggleLimitHi(). By default, ToggleLimitHi is bound to the key F3.
"
" You can customize the colors by setting the following variables to a string
" of key=val that would normally follow "highlight group" command:
"
"       g:limithi_linecolor_soft
"       g:limithi_linecolor_hard
"
" And you can set the following limits, that default to 80 and 120:
"
"       g:limithi_softlimit
"       g:limithi_hardlimit
"
" The defaults can be found in the "Default Global Vars" section below.
"
" You can give a list of filetypes to exclude 
"
" If you want to highlight line limits by default for every file that is
" syntax highlighted, you can add the following to your vimrc:
"
"       autocmd syntax * LimitHi

" Section: Plugin header {{{1
" If we have already loaded this file, don't load it again.
if exists("loaded_limithi")
    finish
endif
let loaded_limithi=1

" Section: Default Global Vars {{{1
if !exists("g:limithi_softlimit")
    let g:limithi_softlimit=80
endif
if !exists("g:limithi_hardlimit")
    let g:limithi_hardlimit=120
endif
if !exists("g:limithi_linecolor_soft")
    " highlight soft limit with blue underline
    let g:limithi_linecolor_soft="ctermfg=4 cterm=underline"
    let g:limithi_linecolor_soft=g:limithi_linecolor_soft . " guifg=blue gui=underline"
endif
if !exists("g:limithi_linecolor_hard")
    " highlight hard limit with red underline
    let g:limithi_linecolor_hard="ctermfg=1 cterm=underline"
    let g:limithi_linecolor_hard=g:limithi_linecolor_hard . " guifg=red gui=underline"
endif

" Section: Functions {{{1
" Function: s:LimitHi() {{{2
" Turn on highlighting of line limits
function! s:LimitHi()
    let l:soft_limit_start = g:limithi_softlimit + 1 " 81
    let l:soft_limit_end = g:limithi_hardlimit + 2 " 122, don't know why this was +2
    let l:hard_limit_start = g:limithi_hardlimit + 1 " 121

    execute("highlight limithiLineLengthSoft " . g:limithi_linecolor_soft)
    let g:ll_soft = matchadd("limithiLineLengthSoft",
                \ '\(\S\%<' . l:soft_limit_end . 'v\%>' . l:soft_limit_start .
                \ 'v\)\|\(\s\%<' . l:soft_limit_end . 'v\%>' . l:soft_limit_start .
                \ 'v\(\s*\S\)\@=\)', -1)

    execute("highlight limithiLineLengthHard " . g:limithi_linecolor_hard)
    let g:ll_hard = matchadd("limithiLineLengthHARD",
                \ '\(\S\%>' . l:hard_limit_start . 'v\)\|\(\s\%>' .
                \ l:hard_limit_start.'v\(\s*\S\)\@=\)', -1)
    let b:limithi = 1
endfunction

" Function: s:NoLimitHi() {{{2
" Turn off highlighting of line limits
function! s:NoLimitHi()
    call matchdelete(g:ll_soft)
    call matchdelete(g:ll_hard)
    let b:limithi = 0
endfunction

" Function: s:ToggleLimitHi() {{{2
" Toggle highlighting of line limits
function! s:ToggleLimitHi()
    if exists("b:limithi") && b:limithi
        call s:NoLimitHi()
        echo "limithi off"
    else
        call s:LimitHi()
        echo "limithi on"
    endif
endfunction

" Section: Commands {{{1
com! LimitHi call s:LimitHi()
com! NoLimitHi call s:NoLimitHi()
com! ToggleLimitHi call s:ToggleLimitHi()

" Section: Default mappings {{{1
" Only insert a map to ToggleLimitHi if they don't already have a map to
" the function and don't have something bound to F3
if !hasmapto('ToggleLimitHi') && maparg("<F3>") == ""
  map <silent> <unique> <F3> :ToggleLimitHi<CR>
endif


