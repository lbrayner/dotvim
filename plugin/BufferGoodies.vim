command! BufWipeNotLoaded call BufferGoodies#BufWipeNotLoaded()
command! BufWipeTab call BufferGoodies#BufWipeTab()
command! -nargs=1 BufWipe call BufferGoodies#BufWipe(<f-args>)
command! -nargs=1 BufWipeForce call BufferGoodies#BufWipeForce(<f-args>)
command! -nargs=1 BufWipeHidden call BufferGoodies#BufWipeHidden(<f-args>)
command! BufWipeTabOnly call BufferGoodies#BufWipeTabOnly()
command! -nargs=1 BufWipeFileType call BufferGoodies#BufWipeFileType(<f-args>)
