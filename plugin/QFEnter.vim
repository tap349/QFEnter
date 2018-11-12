" File:         plugin/QFEnter.vim
" Description:  Open a Quickfix item in a window you choose.
" Author:       yssl <http://github.com/yssl>
" License:      MIT License

if exists("g:loaded_qfenter") || &cp
  finish
endif

let g:loaded_qfenter  = 1
let s:keepcpo         = &cpo
set cpo&vim
"""""""""""""""""""""""""""""""""""""""""""""

" static variables

" cmd-action map (key-value pairs)
" value[0]: wintype (o-open, v-vert, h-horz, t-tab)
" value[1]: opencmd (c-cc, n-cnext, p-cprev)
" value[2]: keepfocus (0-do not keep focus, 1-keep focus, 2-close)
let s:cmd_action_map = {
        \'open':        'oc0',
        \'vopen':       'vc0',
        \'hopen':       'hc0',
        \'topen':       'tc0',
        \'cnext':       'on0',
        \'vcnext':      'vn0',
        \'hcnext':      'hn0',
        \'tcnext':      'tn0',
        \'cprev':       'op0',
        \'vcprev':      'vp0',
        \'hcprev':      'hp0',
        \'tcprev':      'tp0',
        \'open_keep':   'oc1',
        \'vopen_keep':  'vc1',
        \'hopen_keep':  'hc1',
        \'topen_keep':  'tc1',
        \'cnext_keep':  'on1',
        \'vcnext_keep': 'vn1',
        \'hcnext_keep': 'hn1',
        \'tcnext_keep': 'tn1',
        \'cprev_keep':  'op1',
        \'vcprev_keep': 'vp1',
        \'hcprev_keep': 'hp1',
        \'tcprev_keep': 'tp1',
        \'open_close':   'oc2',
        \'vopen_close':  'vc2',
        \'hopen_close':  'hc2',
        \'topen_close':  'tc2',
        \'cnext_close':  'on2',
        \'vcnext_close': 'vn2',
        \'hcnext_close': 'hn2',
        \'tcnext_close': 'tn2',
        \'cprev_close':  'op2',
        \'vcprev_close': 'vp2',
        \'hcprev_close': 'hp2',
        \'tcprev_close': 'tp2',
      \}

" global variables

" g:qfenter_keymap - cmd-keylist map
" default key mappings are assigned for open, vopen, hopen, topen
if !exists('g:qfenter_keymap')
  let g:qfenter_keymap = {}
endif
if !has_key(g:qfenter_keymap, 'open')
  let g:qfenter_keymap.open = ['<CR>', '<2-LeftMouse>']
endif
if !has_key(g:qfenter_keymap, 'vopen')
  let g:qfenter_keymap.vopen = ['<Leader><CR>']
endif
if !has_key(g:qfenter_keymap, 'hopen')
  let g:qfenter_keymap.hopen = ['<Leader><Space>']
endif
if !has_key(g:qfenter_keymap, 'topen')
  let g:qfenter_keymap.topen = ['<Leader><Tab>']
endif

if !exists('g:qfenter_enable_autoquickfix')
  let g:qfenter_enable_autoquickfix = 1
endif

if !exists('g:qfenter_cc_cmd')  | let g:qfenter_cc_cmd = '##cc' | endif
if !exists('g:qfenter_ll_cmd')  | let g:qfenter_ll_cmd = '##ll' | endif
if !exists('g:qfenter_cn_cmd')  | let g:qfenter_cn_cmd = 'cn'   | endif
if !exists('g:qfenter_cp_cmd')  | let g:qfenter_cp_cmd = 'cp'   | endif
if !exists('g:qfenter_lne_cmd') | let g:qfenter_lne_cmd = 'lne' | endif
if !exists('g:qfenter_lp_cmd')  | let g:qfenter_lp_cmd = 'lp'   | endif

" autocmd
augroup QFEnterAutoCmds
  autocmd!
  autocmd FileType qf call s:RegisterKeymap()
augroup END

" functions
function! s:RegisterKeymap()
  for [cmd, keylist] in items(g:qfenter_keymap)
    let wintype = s:cmd_action_map[cmd][0]
    let opencmd = s:cmd_action_map[cmd][1]
    let keepfocus = s:cmd_action_map[cmd][2]
    for key in keylist
      execute 'nnoremap <silent> <buffer> '.key.' :call QFEnter#OpenQFItem("'.wintype.'","'.opencmd.'","'.keepfocus.'")<CR>'
    endfor
  endfor
endfunction

""""""""""""""""""""""""""""""""""""""""""""
let &cpo = s:keepcpo
unlet s:keepcpo
