" Vim compiler file for gcc
let current_compiler = "gcc"

let s:cpo_save = &cpo
set cpo&vim

CompilerSet errorformat=
      \%f(%l):\ %trror:\ %m,
      \%f(%l):\ %tarning:\ %m,
      \%f:%l:%c:\ %trror:\ %m,
      \%f:%l:%c:\ %tarning:\ %m,
      \%I%.%#undefined\ reference\ to%m

if exists('g:compiler_gcc_ignore_unmatched_lines')
  CompilerSet errorformat+=%-G%.%#
endif

CompilerSet makeprg=make

let &cpo = s:cpo_save
unlet s:cpo_save
