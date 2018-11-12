" File:         plugin/QFEnter.vim
" Description:  Open a Quickfix item in a window you choose.
" Author:       yssl <http://github.com/yssl>
" License:      MIT License

if exists('g:loaded_qfenter') || &cp
  finish
endif

let g:loaded_qfenter  = 1
let s:keepcpo         = &cpo
set cpo&vim

""""""""""""""""""""""""""""""""""""""""""""

" static variables

" cmd-action map (key-value pairs)
" value[0]: wintype (o - open, v - vert, h - horz, t - tab)
" value[1]: opencmd (c - cc, n - cnext, p - cprev)
" value[2]: qfwincmd (l - leave, f - focus, c - close)
let s:cmd_action_map = {
        \'open':         'ocl',
        \'vopen':        'vcl',
        \'hopen':        'hcl',
        \'topen':        'tcl',
        \'cnext':        'onl',
        \'vcnext':       'vnl',
        \'hcnext':       'hnl',
        \'tcnext':       'tnl',
        \'cprev':        'opl',
        \'vcprev':       'vpl',
        \'hcprev':       'hpl',
        \'tcprev':       'tpl',
        \'open_keep':    'ocf',
        \'vopen_keep':   'vcf',
        \'hopen_keep':   'hcf',
        \'topen_keep':   'tcf',
        \'cnext_keep':   'onf',
        \'vcnext_keep':  'vnf',
        \'hcnext_keep':  'hnf',
        \'tcnext_keep':  'tnf',
        \'cprev_keep':   'opf',
        \'vcprev_keep':  'vpf',
        \'hcprev_keep':  'hpf',
        \'tcprev_keep':  'tpf',
        \'open_close':   'occ',
        \'vopen_close':  'vcc',
        \'hopen_close':  'hcc',
        \'topen_close':  'tcc',
        \'cnext_close':  'onc',
        \'vcnext_close': 'vnc',
        \'hcnext_close': 'hnc',
        \'tcnext_close': 'tnc',
        \'cprev_close':  'opc',
        \'vcprev_close': 'vpc',
        \'hcprev_close': 'hpc',
        \'tcprev_close': 'tpc',
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
    let qfwincmd = s:cmd_action_map[cmd][2]
    for key in keylist
      execute 'nnoremap <silent> <buffer> '.key.' :call QFEnter#OpenQFItem("'.wintype.'","'.opencmd.'","'.qfwincmd.'")<CR>'
    endfor
  endfor
endfunction

""""""""""""""""""""""""""""""""""""""""""""

let &cpo = s:keepcpo
unlet s:keepcpo
