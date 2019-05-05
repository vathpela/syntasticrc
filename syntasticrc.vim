

function! EnableDebugSyntastic()
  let g:syntastic_debug = 0x3f
  let g:syntastic_debug_file = "~/syntastic.log"
endfunction

function! DisableDebugSyntastic()
  unlet g:syntastic_debug
  unlet g:syntastic_debug_file
endfunction

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = {
      \ "mode": "passive",
      \ "active_filetypes": ["rust", "rst"],
      \ "passive_filetypes": ["text", "asm", "c", "cpp", "h", "python"]
      \ }
let g:syntastic_asm_generic = 1

if exists("g:default_statusline")
  let s:default_statusline = g:default_statusline
elseif exists("g:statusline")
  let s:default_statusline = g:statusline
else
  let s:default_statusline = "%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P"
endif

if exists("g:syntastic_statusline")
  let s:syntastic_statusline = g:syntastic_statusline
else
  let s:syntastic_statusline = "%<%f\ %{SyntasticStatuslineFlag()}\ %h%m%r%=%-14.(%l,%c%V%)\ %P"
endif

function s:GnuIndent()
  setlocal cindent
  setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
  setlocal tabstop=8
  setlocal shiftwidth=2
  setlocal softtabstop=2
  setlocal textwidth=79
  setlocal fo+=cqlro
endfunction

function s:SetupSyntastic()
  if !exists("g:syntastic_vimrc")
    if has("autocmd")
      "augroup SyntasticVimRcOnce
      "  au!
      "augroup END
    endif
    let l:cwd = getcwd()
    if l:cwd =~ ".*/grub2/.*"
      call GnuIndent()
    endif
    if l:cwd =~ ".*sparc64.*" || l:cwd =~ ".*halstation.*"
      let g:syntastic_c_compiler = "sparc64-linux-gnu-gcc"
      let g:syntastic_cpp_compiler = "sparc64-linux-gnu-cpp"
      let g:syntastic_asm_compiler = "sparc64-linux-gnu-gcc"
    elseif l:cwd =~ ".*sparc.*"
      let g:syntastic_c_compiler = "sparc-linux-gnu-gcc"
      let g:syntastic_cpp_compiler = "sparc-linux-gnu-cpp"
      let g:syntastic_asm_compiler = "sparc-linux-gnu-gcc"
    elseif l:cwd =~ ".*arm64.*" || l:cwd =~ ".*aarch64.*"
      let g:syntastic_c_compiler = "aarch6464-linux-gnu-gcc"
      let g:syntastic_cpp_compiler = "aarch6464-linux-gnu-cpp"
      let g:syntastic_asm_compiler = "aarch6464-linux-gnu-gcc"
    elseif l:cwd =~ ".*arm.*"
      let g:syntastic_c_compiler = "arm-linux-gnu-gcc"
      let g:syntastic_cpp_compiler = "arm-linux-gnu-cpp"
      let g:syntastic_asm_compiler = "arm-linux-gnu-gcc"
    elseif l:cwd =~ ".*mips64.*"
      let g:syntastic_c_compiler = "mips64-linux-gnu-gcc"
      let g:syntastic_cpp_compiler = "mips64-linux-gnu-cpp"
      let g:syntastic_asm_compiler = "mips64-linux-gnu-gcc"
    elseif l:cwd =~ ".*mips.*"
      let g:syntastic_c_compiler = "mips-linux-gnu-gcc"
      let g:syntastic_cpp_compiler = "mips-linux-gnu-cpp"
      let g:syntastic_asm_compiler = "mips-linux-gnu-gcc"
    else
      let g:syntastic_c_compiler = "gcc"
      let g:syntastic_cpp_compiler = "cpp"
      let g:syntastic_asm_compiler = "gcc"
    endif
    let g:syntastic_asm_remove_include_errors = 1
    let g:syntastic_asm_compiler_options = '-x assembler-with-cpp -fsyntax-only'
    let g:syntastic_c_compiler_options = ''
    let g:syntastic_c_no_default_include_dirs = 1
    let g:syntastic_c_include_from_cwd = 1
    let g:syntastic_c_remove_include_errors = 1
    let g:syntastic_cpp_remove_include_errors = 1
    " let g:loaded_syntastic_c_autoload = 1
    let g:syntastic_python_checkers = ['flake8']
    " let g:syntastic_python_pylint_args = '--rcfile=.pylintrc'
    " let g:syntastic_python_pylint3_args = '--rcfile=.pylintrc'
    let g:syntastic_warning_symbol = "!"
    let g:syntastic_python_pylint_exe = 'pylint-3'
    let g:syntastic_python_checkers = ['pylint']
    let g:syntastic_rust_checkers = ['rustc']
    let g:syntastic_enable_signs = 1
    let g:syntastic_vimrc = 1
  endif
endfunction
  
function s:SetLittleS()
  let g:syntastic_asm_compiler_options = '-x assembler -fsyntax-only'
  call s:SetupSyntastic()
endfunction

function s:SetBigS()
  let g:syntastic_asm_compiler_options = '-x assembler-with-cpp -fsyntax-only'
  call s:SetupSyntastic()
endfunction

function s:SetC()
  call s:SetupSyntastic()
endfunction

function s:SetH()
  call s:SetupSyntastic()
endfunction

function s:SetPython()
  call s:SetupSyntastic()
endfunction

function s:SyntasticCheckOnce(afile)
  call EnableSyntastic(a:afile)
  call SyntasticCheck()
  augroup EnableSyntastic
    au!
  augroup END
endfunction

function EnableSyntastic(afile)
  if v:vim_did_enter
    " echomsg "a:afile: " . a:afile
    if a:afile =~ ".*/grub2/.*/util/.*"
      let g:syntastic_c_config_file = '~/.vim/syntastic_grub_util_c_config'
    elseif a:afile =~ ".*/grub2/.*"
      let g:syntastic_c_config_file = '~/.vim/syntastic_grub_c_config'
    endif

    let g:syntastic_mode_map = {
          \ "mode": "active",
          \ "active_filetypes": ["asm", "c", "cpp", "h", "python"],
          \ "passive_filetypes": ["text"]
          \ }

    let l:statusline=s:syntastic_statusline
  else
    let b:afile=a:afile
    augroup EnableSyntastic
      au!
      au VimEnter * call s:SyntasticCheckOnce(b:afile)
    augroup END
  endif
endfunction

function DisableSyntastic()
  if v:vim_did_enter
    let g:syntastic_mode_map = {
          \ "mode": "passive",
          \ "active_filetypes": ["asm", "c", "cpp", "h", "python"],
          \ "passive_filetypes": ["text"]
          \ }
    let l:statusline=s:default_statusline
  endif
endfunction

if has("autocmd")
  augroup SyntasticVimRc
    au!
    auto BufRead,BufNewFile,BufWinEnter *.S :call s:SetBigS()
    auto BufRead,BufNewFile,BufWinEnter *.s :call s:SetLittleS()
    auto BufRead,BufNewFile,BufWinEnter *.c :call s:SetC()
    auto BufRead,BufNewFile,BufWinEnter *.h :call s:SetH()
    auto BufRead,BufNewFile,BufWinEnter *.py :call s:SetPython()
    auto BufRead,BufNewFile *.S :call EnableSyntastic(expand("<afile>:p"))
    auto BufRead,BufNewFile *.s :call EnableSyntastic(expand("<afile>:p"))
    auto BufRead,BufNewFile *.c :call EnableSyntastic(expand("<afile>:p"))
    auto BufRead,BufNewFile *.h :call EnableSyntastic(expand("<afile>:p"))
    auto BufRead,BufNewFile *.py :call EnableSyntastic(expand("<afile>:p"))
  augroup END

  augroup SyntasticVimRcOnce
    au!
    auto VimEnter * call s:SetupSyntastic()
  augroup END
else
  call s:SetupSyntastic()
endif

" vim:sw=2:et
