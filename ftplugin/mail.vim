if exists("b:my_did_ftplugin")
    finish
endif
let b:my_did_ftplugin = 1

if &ft == 'mail'
    " HTML:  thanks to Johannes Zellner and Benji Fisher.
    if exists("loaded_matchit")
        let b:match_ignorecase = 1
        let b:match_words = '<:>,' .
        \ '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,' .
        \ '<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,' .
        \ '<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>'
    endif
    vmap <buffer> <leader>a <Plug>Linkify
endif
setlocal completefunc=email#EmailComplete
