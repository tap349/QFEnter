" File:         autoload/QFEnter.vim
" Description:  Open a Quickfix item in a window you choose.
" Author:       yssl <http://github.com/yssl>
" License:      MIT License

" functions
function! s:ExecuteCC(lnumqf, isloclist)
  if a:isloclist
    let cmd = g:qfenter_ll_cmd
  else
    let cmd = g:qfenter_cc_cmd
  endif
  let cc_cmd = substitute(cmd, '##', a:lnumqf, "")
  execute cc_cmd
endfunction

function! s:ExecuteCN(count, isloclist)
  if a:isloclist
    let cmd = g:qfenter_lne_cmd
  else
    let cmd = g:qfenter_cn_cmd
  endif
  try
    execute cmd
  catch E553
    echo 'QFEnter: cnext: No more items'
  endtry
endfunction

function! s:ExecuteCP(count, isloclist)
  if a:isloclist
    let cmd = g:qfenter_lp_cmd
  else
    let cmd = g:qfenter_cp_cmd
  endif
  try
    execute cmd
  catch E553
    echo 'QFEnter: cprev: No more items'
  endtry
endfunction

function! QFEnter#OpenQFItem(wintype, opencmd, keepfocus)
  let qfbufnr = bufnr('%')
  let qflnum = line('.')

  call s:OpenQFItem(a:wintype, a:opencmd, qflnum)

  if a:keepfocus=='1'
    redraw
    let qfwinnr = bufwinnr(qfbufnr)
    exec qfwinnr.'wincmd w'
  elseif a:keepfocus=='2'
    redraw
    let qfwinnr = bufwinnr(qfbufnr)
    exec qfwinnr.'wincmd c'
  endif
endfunction

"wintype: 'o', 'v', 'h', 't'
"opencmd: 'c', 'n', 'p'
function! s:OpenQFItem(wintype, opencmd, qflnum)
  let lnumqf = a:qflnum

  if len(getloclist(0)) > 0
    let isloclist = 1
  else
    let isloclist = 0
  endif

  " arrange a window or tab in which quickfix item to be opened
  if a:wintype==#'o'
    wincmd p
  elseif a:wintype==#'v'
    wincmd p
    vnew
  elseif a:wintype==#'h'
    wincmd p
    new
  elseif a:wintype==#'t'
    let qfview = winsaveview()

    let modifier = ''
    let widthratio = winwidth(0)*&lines
    let heightratio = winheight(0)*&columns
    if widthratio > heightratio
      let modifier = modifier.''
      let qfresize = 'resize '.winheight(0)
    else
      let modifier = modifier.'vert'
      let qfresize = 'vert resize '.winwidth(0)
    endif

    if winnr() <= winnr('$')/2
      let modifier = modifier.' topleft'
    else
      let modifier = modifier.' botright'
    endif

    tabnew
  endif

  " save current tab or window to check after switchbuf applied when
  " executing cc, cn, cp commands
  let before_tabnr = tabpagenr()
  let before_winnr = winnr()

  " execute vim quickfix open commands
  if a:opencmd==#'c'
    call s:ExecuteCC(lnumqf, isloclist)
  elseif a:opencmd==#'n'
    call s:ExecuteCN(lnumqf, isloclist)
  elseif a:opencmd==#'p'
    call s:ExecuteCP(lnumqf, isloclist)
  endif

  " check if switchbuf applied.
  " if useopen or usetab are applied with new window or tab command, close
  " the newly opened tab or window.
  let after_tabnr = tabpagenr()
  let after_winnr = winnr()
  if (match(&switchbuf,'useopen')>-1 || match(&switchbuf,'usetab')>-1)
    if a:wintype==#'t'
      if before_tabnr!=after_tabnr
        call s:JumpToTab(before_tabnr)
        call s:CloseTab(after_tabnr)
      endif
    elseif a:wintype==#'v'|| a:wintype==#'h'
      if before_tabnr!=after_tabnr  |"when 'usetab' applied
        call s:JumpToTab(before_tabnr)
        call s:CloseWin(after_winnr)
        call s:JumpToTab(after_tabnr)
      elseif before_winnr!=after_winnr
        call s:JumpToWin(before_winnr)
        call s:CloseWin(after_winnr)
      endif
    endif
  endif
  "echo before_tabnr after_tabnr
  "echo before_winnr after_winnr

  " restore quickfix window when tab mode
  if a:wintype==#'t'
    if g:qfenter_enable_autoquickfix
      if isloclist
        exec modifier 'lopen'
      else
        exec modifier 'copen'
      endif
      exec qfresize
      call winrestview(qfview)
      wincmd p
    endif
  endif
endfunction

fun! s:CloseWin(return_winnr)
  let prevwinnr = a:return_winnr
  if prevwinnr > winnr()
    let prevwinnr = prevwinnr - 1
  endif

  quit

  call s:JumpToWin(prevwinnr)
endfun

fun! s:JumpToWin(winnum)
  exec a:winnum.'wincmd w'
endfun

fun! s:CloseTab(return_tabnr)
  let prevtabnr = a:return_tabnr
  if prevtabnr > tabpagenr()
    let prevtabnr = prevtabnr - 1
  endif

  tabclose

  call s:JumpToTab(prevtabnr)
endfun

fun! s:JumpToTab(tabnum)
  exec 'tabnext' a:tabnum
endfun
