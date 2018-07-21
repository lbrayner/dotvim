" file under the cursor

function! assorted#CopyFileNameUnderCursor()
    silent exec ":let @\"=expand('<cfile>:t')"
    echomsg "Yanked file name."
endfunction

function! assorted#CopyFileParentUnderCursor()
    silent exec ":let @\"=expand('<cfile>:h')"
    echomsg "Yanked file's parent name."
endfunction

function! assorted#CopyFileFullPathUnderCursor()
    silent exec ":let @\"=expand('<cfile>:p')"
    echomsg "Yanked file's full path."
endfunction

function! assorted#CopyFilePathUnderCursor()
    silent exec ":let @\"=expand('<cfile>')"
    echomsg "Yanked file path."
endfunction

function! assorted#SetDictionaryLanguage(global,language)
    if !exists("g:assorted#dictionaries")
        echoe "No dictionaries defined."
        return
    endif
    let dictionaries = g:assorted#dictionaries
    if a:global
        let &dictionary = dictionaries[a:language]
        return
    endif
    let &l:dictionary = dictionaries[a:language]
    echo "Dictionary language set to '" . a:language . "'."
endfunction

function! assorted#SourceVisualSelection() range
    let line_start = a:firstline
    let line_end = a:lastline
    let offset = 0
    for linenr in range(line_start,line_end)
        exe getline(linenr)
    endfor
    echom "Sourced visual selection."
endfunction

function! assorted#FilterVisualSelection() range
    let line_start = a:firstline
    let line_end = a:lastline
    let offset = 0
    for linenr in range(line_start,line_end)
        call cursor(linenr+offset,0)
        let output = systemlist(getline(linenr+offset))
        exe "delete"
        call append(linenr+offset-1,output)
        if len(offset) > 0
            let offset += len(output) - 1
        endif
    endfor
    call cursor(line_start,0)
endfunction

function! assorted#RemoveTrailingSpaces() range
    silent exec "keepp ".a:firstline.",".a:lastline.'s/\s\+$//e'
endfunction

" XML

function! s:NavigateXmlNthParent(n)
    let n_command = "v" . (a:n+1) . "at"
    exec "silent normal! " . n_command . "v"
    exec "silent normal! \<esc>"
endfunction

function! assorted#NavigateXmlDepth(depth)
    if a:depth < 0
        call s:NavigateXmlNthParent(-a:depth)
        return
    endif
endfunction

function! assorted#HighlightOverLength()
    if ! exists("s:OverLength")
        let s:OverLength = 90
    endif
    if ! exists("w:HighlightOverLengthFlag")
        let w:HighlightOverLengthFlag = 1
    endif
    if w:HighlightOverLengthFlag
        highlight OverLength ctermbg=red ctermfg=white guibg=#592929
        exec 'match OverLength /\%' . s:OverLength . 'v.\+/'
        echo "Overlength highlighted."
    else
        exec "match"
        echo "Overlength highlight cleared."
    endif
    let w:HighlightOverLengthFlag = ! w:HighlightOverLengthFlag
endfunction

function! assorted#InsertModeUndoPoint()
    if mode() != "i"
        return
    endif
    call feedkeys("\<c-g>u")
endfunction

function! assorted#FilterLine()
    let line = getline('.')
    let temp = tempname()
    exe 'sil! !'.escape(line,&shellxescape).' > '.temp.' 2>&1'
    if v:shell_error
        exe 'throw "'.escape(readfile(temp)[0],'"').'"'
    endif
    exe "sil! read ".fnameescape(temp)
    exe "sil call delete ('".temp."')"
endfunction