function! util#GetComparableNodeName(filename)
    let node = resolve(substitute(fnamemodify(a:filename,":p"),'\','/','g'))
    let node = substitute(node,"/$","","")
    if has("win32") || has ("win64")
        return tolower(node)
    endif
    return node
endfunction

" TODO possibly remove this, for it's currently not used
" Based on tpope's vim-surround
function! util#getVisualSelection()
    let ve = &virtualedit
    set virtualedit=
    let reg = 'v'
    let reg_save = getreg(reg)
    let reg_type = getregtype(reg)
    silent exe 'norm! gv"'.reg.'y'
    let visual_selection = getreg(reg)
    call setreg(reg,reg_save,reg_type)
    let &virtualedit = ve
    return visual_selection
endfunction

function! util#trivialHorizontalMotion()
    let col = getpos('.')[2]
    if col <= 1
        return 'h'
    endif
    return 'lh'
endfunction

function! s:truncateNode(filename,maxlength,...)
    if len(a:filename) <= a:maxlength
        return a:filename
    endif
    if len(fnamemodify(a:filename,":t")) < a:maxlength
        " -1 (forward slash), -3 (three dots)
        let trunc_fname_head=strpart(fnamemodify(a:filename,":h"),0,
                    \a:maxlength-len(fnamemodify(a:filename,":t"))-1-3)
        return trunc_fname_head.".../".fnamemodify(a:filename,":t")
    endif
    if a:0 > 0 && a:1
        if fnamemodify(a:filename,":e") != ""
            " -1 (a dot), -3 (three dots)
            let trunc_fname_tail=strpart(fnamemodify(a:filename,":t"),0,
                        \a:maxlength-len(fnamemodify(a:filename,":e"))-1-3)
            return trunc_fname_tail."....".fnamemodify(a:filename,":e")
        endif
    endif
    let trunc_fname_tail=strpart(fnamemodify(a:filename,":t"),0,a:maxlength-3)
    return trunc_fname_tail."..."
endfunction

function! util#truncateFilename(filename,maxlength,...)
    return s:truncateNode(a:filename,a:maxlength,1)
endfunction

function! util#truncateDirname(dirname,maxlength)
    return s:truncateNode(a:dirname,a:maxlength)
endfunction

" a string or a 0-arg funcref
function! util#PreserveViewPort(command)
    let lazyr = &lazyredraw
    try
        set lazyredraw
        let winview = winsaveview()
        if type(a:command) == type(function("tr"))
            call a:command()
        else
            exe a:command
        endif
        call winrestview(winview)
    finally
        let &lazyredraw = lazyr
    endtry
endfunction

function! util#random()
    if &sh =~# 'sh'
        return system('echo $RANDOM')[:-2]
    endif
    if has("win32") || has("win64")
        if &sh =~# 'cmd.exe'
            return system('echo %RANDOM%')[:-2]
        endif
    endif
    return -1
endfunction

function! util#isLocationList(...)
    let winid = win_getid()
    if a:0 && a:1
        let winid = a:1
    endif
    return getwininfo(winid)[0]["loclist"]
endfunction

function! util#isQuickfixList(...)
    let winid = win_getid()
    if a:0 && a:1
        let winid = a:1
    endif
    return getwininfo(winid)[0]["quickfix"] && !util#isLocationList(winid)
endfunction

function! util#IsVimBundle()
    return filereadable("init.vim")
endfunction

function! util#IsEclipseProject()
    return filereadable(".project")
endfunction

function! util#TabExists(tabnr)
    return len(gettabinfo(a:tabnr)) > 0
endfunction

function! util#EclimLoaded()
    return exists(':ProjectCreate')
endfunction
