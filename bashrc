IAM="kk" && export IAM
[ -n "$HOME" ] || { HOME="/tmp"; export HOME; }
IAM_HOME="$HOME/.${IAM}_home" && export IAM_HOME
SSH_PUB_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEApJEHtvysrpZeN7xfBS5GY0JjFD8eL5UCYZFbwcUhKXKNXsjtLl9FtwA9sS0cJhqM8CSSGAcceSirACC5L5PSLckeUh2eofYlqJPBkNzU2Uycwc7CSKJRaVTY+yNAJrdpO+7fJPxzis5H3CEB6roguEr+ZqDF9BSEZ0CO8l4wTGgsmqZ2UJuEKfVpPMg6cqGCUj6NvoADavMyrOPRKVCvKikJaWd3NJK4UXueLW0pc/lNoKvbVYRyXO0VruwsAAeciPtn/M1po/iz3+pQW9fk6uM1YContqmR3Ga7TfF249cSyml2gSO8VeNoPbm3RM/KPMZ8F9eyfwQUf6bic2IRoQ== kkushnir" && export SSH_PUB_KEY
_GIT_USER_NAME="Konstantin Kushnir" && export _GIT_USER_NAME
_GIT_USER_EMAIL="chpock@gmail.com" && export _GIT_USER_EMAIL
[ -d "$IAM_HOME/terminfo" ] || mkdir -p "$IAM_HOME/terminfo"

cat <<'EOF' > "$IAM_HOME/terminfo/.terminfo"
xterm-256color|xterm with 256 colors,
 am,bce,ccc,xenl,km,hs,mir,msgr,xon,npc,mc5i,it#8,colors#256,pairs#32767,acsc=``aaffggiijjkkllmmnnooppqqrrssttuuvvwwxxyyzz{{||}}~~,cbt=\E[Z,bel=^G,cr=^M,csr=\E[%i%p1%d;%p2%dr,tbc=\E[3g,clear=\E[H\E[J,el1=\E[1K,el=\E[K,ed=\E[J,hpa=\E[%i%p1%dG,cup=\E[%i%p1%d;%p2%dH,home=\E[H,civis=\E[?25l,cub1=^H,cnorm=\E[34h\E[?25h,cud1=\E[B,cuf1=\E[C,cuu1=\E[A,cvvis=\E[34l\E[?25h,dch1=\E[P,dl1=\E[M,dsl=\E]0;\007,dispc=%?%p1%{8}%=%t\E%%G\342\227\230\E%%@%e%p1%{10}%=%t\E%%G\342\227\231\E%%@%e%p1%{12}%=%t\E%%G\342\231\0\E%%@%e%p1%{13}%=%t\E%%G\342\231\252\E%%@%e%p1%{14}%=%t\E%%G\342\231\253\E%%@%e%p1%{15}%=%t\E%%G\342\230\274\E%%@%e%p1%{27}%=%t\E%%G\342\206\220\E%%@%e%p1%{155}%=%t\E%%G\340\202\242\E%%@%e%p1%c%;,enacs=\E(B\E)0,smacs=\E(0,smam=\E[?7h,blink=\E[5m,bold=\E[1m,smcup=\E[?1049h,swidm=\E#6,smir=\E[4h,smpch=\E[11m,rev=\E[7m,smso=\E[7m,smul=\E[4m,ech=\E[%p1%dX,rmacs=\E(B,rmam=\E[?7l,sgr0=\E[m\E(B,rmcup=\E[?1049l,rmir=\E[4l,rmpch=\E[10m,rmso=\E[27m,rmul=\E[24m,flash=\E[?5h$<100/>\E[?5l,fsl=^G,is2=\E[34h\E[?25h\E[4l\E[?7h\E[?1;4;6;1047l\E[2J\E[H\E>\E[r\E[m\E]R\E[?1000l\E[?1002l,initc@,ich1=\E[@,il1=\E[L,ka1=\EOw,ka3=\EOy,kb2=\EOu,kc1=\EOq,kc3=\EOs,kbs=\177,kcbt=\E[Z,kdch1=\E[3~,kend=\E[4~,kent=\EOM,kf1=\E[11~,kf2=\E[12~,kf3=\E[13~,kf4=\E[14~,kf5=\E[15~,kf6=\E[17~,kf7=\E[18~,kf8=\E[19~,kf9=\E[20~,kf10=\E[21~,kf11=\E[23~,kf12=\E[24~,kf13=\E[25~,kf14=\E[26~,kf15=\E[28~,kf16=\E[29~,kf17=\E[31~,kf18=\E[32~,kf19=\E[33~,kf20=\E[34~,kf21=\E[20;2~,kf22=\E[21;2~,kf23=\E[23;2~,kf24=\E[24;2~,kf25=\EO5P,kf26=\EO5Q,kf27=\EO5R,kf28=\EO5S,kf29=\E[15;5~,kf30=\E[17;5~,kf31=\E[18;5~,kf32=\E[19;5~,kf33=\E[20;5~,kf34=\E[21;5~,kf35=\E[23;5~,kf36=\E[24;5~,kf37=\EO6P,kf38=\EO6Q,kf39=\EO6R,kf40=\EO6S,kf41=\E[15;6~,kf42=\E[17;6~,kf43=\E[18;6~,kf44=\E[19;6~,kf45=\E[20;6~,kf46=\E[21;6~,kf47=\E[23;6~,kf48=\E[24;6~,kf49=\EO3P,kf50=\EO3Q,kf51=\EO3R,kf52=\EO3S,kf53=\E[15;3~,kf54=\E[17;3~,kf55=\E[18;3~,kf56=\E[19;3~,kf57=\E[20;3~,kf58=\E[21;3~,kf59=\E[23;3~,kf60=\E[24;3~,kf61=\EO4P,kf62=\EO4Q,kf63=\EO4R,khome=\E[1~,kich1=\E[2~,kcub1=\EOD,kcuf1=\EOC,kcuu1=\EOA,kcud1=\EOB,kmous=\E[M,knp=\E[6~,kpp=\E[5~,rmkx=\E[?1l\E>,smkx=\E[?1h\E=,oc=\E]R,op=\E[39;49m,dch=\E[%p1%dP,dl=\E[%p1%dM,cud=\E[%p1%dB,ich=\E[%p1%d@,indn=\E[%p1%dS,il=\E[%p1%dL,cub=\E[%p1%dD,cuf=\E[%p1%dC,rin=\E[%p1%dT,cuu=\E[%p1%dA,mc0=\E[i,mc4=\E[4i,mc5=\E[5i,rs1=\Ec,rs2=\E<\E["p\E[50;6"p\Ec\E[?3l\E]R\E[?1000l,rc=\E8,vpa=\E[%i%p1%dd,sc=\E7,ind=^J,ri=\EM,s0ds=\E[10m,s1ds=\E[11m,s2ds=\E[12m,setab=\E[%?%p1%{8}%<%t4%p1%d%e%p1%{16}%<%t10%p1%{8}%-%d%e48;5;%p1%d%;m,setaf=\E[%?%p1%{8}%<%t3%p1%d%e%p1%{16}%<%t9%p1%{8}%-%d%e38;5;%p1%d%;m,sgr=\E[0%?%p1%p6%|%t;1%;%?%p2%t;4%;%?%p1%p3%|%t;7%;%?%p4%t;5%;m%?%p9%t\016%e\017%;,hts=\EH,ht=^I,tsl=\E]0;,u6=\E[%i%d;%dR,u7=\E[6n,u8=\E[?6c,u9=\E[c,
tmux-256color|tmux with 256 colors,
 am, hs, km, mir, msgr, xenl,colors#0x100, cols#80, it#8, lines#24, pairs#0x10000,acsc=++\,\,--..00``aaffgghhiijjkkllmmnnooppqqrrssttuuvvwwxxyyzz{{||}}~~,bel=^G, blink=\E[5m, bold=\E[1m, cbt=\E[Z, civis=\E[?25l,clear=\E[H\E[J, cnorm=\E[34h\E[?25h, cr=\r,csr=\E[%i%p1%d;%p2%dr, cub=\E[%p1%dD, cub1=^H,cud=\E[%p1%dB, cud1=\n, cuf=\E[%p1%dC, cuf1=\E[C,cup=\E[%i%p1%d;%p2%dH, cuu=\E[%p1%dA, cuu1=\EM,cvvis=\E[34l, dch=\E[%p1%dP, dch1=\E[P, dim=\E[2m,dl=\E[%p1%dM, dl1=\E[M, dsl=\E]0;\007, ed=\E[J, el=\E[K,el1=\E[1K, enacs=\E(B\E)0, flash=\Eg, fsl=^G, home=\E[H,hpa=\E[%i%p1%dG, ht=^I, hts=\EH, ich=\E[%p1%d@,il=\E[%p1%dL, il1=\E[L, ind=\n, indn=\E[%p1%dS,invis=\E[8m, is2=\E)0, kDC=\E[3;2~, kEND=\E[1;2F,kHOM=\E[1;2H, kIC=\E[2;2~, kLFT=\E[1;2D, kNXT=\E[6;2~,kPRV=\E[5;2~, kRIT=\E[1;2C, kbs=^?, kcbt=\E[Z, kcub1=\EOD,kcud1=\EOB, kcuf1=\EOC, kcuu1=\EOA, kdch1=\E[3~,kend=\E[4~, kf1=\EOP, kf10=\E[21~, kf11=\E[23~,kf12=\E[24~, kf13=\E[1;2P, kf14=\E[1;2Q, kf15=\E[1;2R,kf16=\E[1;2S, kf17=\E[15;2~, kf18=\E[17;2~,kf19=\E[18;2~, kf2=\EOQ, kf20=\E[19;2~, kf21=\E[20;2~,kf22=\E[21;2~, kf23=\E[23;2~, kf24=\E[24;2~,kf25=\E[1;5P, kf26=\E[1;5Q, kf27=\E[1;5R, kf28=\E[1;5S,kf29=\E[15;5~, kf3=\EOR, kf30=\E[17;5~, kf31=\E[18;5~,kf32=\E[19;5~, kf33=\E[20;5~, kf34=\E[21;5~,kf35=\E[23;5~, kf36=\E[24;5~, kf37=\E[1;6P, kf38=\E[1;6Q,kf39=\E[1;6R, kf4=\EOS, kf40=\E[1;6S, kf41=\E[15;6~,kf42=\E[17;6~, kf43=\E[18;6~, kf44=\E[19;6~,kf45=\E[20;6~, kf46=\E[21;6~, kf47=\E[23;6~,kf48=\E[24;6~, kf49=\E[1;3P, kf5=\E[15~, kf50=\E[1;3Q,kf51=\E[1;3R, kf52=\E[1;3S, kf53=\E[15;3~, kf54=\E[17;3~,kf55=\E[18;3~, kf56=\E[19;3~, kf57=\E[20;3~,kf58=\E[21;3~, kf59=\E[23;3~, kf6=\E[17~, kf60=\E[24;3~,kf61=\E[1;4P, kf62=\E[1;4Q, kf63=\E[1;4R, kf7=\E[18~,kf8=\E[19~, kf9=\E[20~, khome=\E[1~, kich1=\E[2~,kind=\E[1;2B, kmous=\E[M, knp=\E[6~, kpp=\E[5~,kri=\E[1;2A, nel=\EE, op=\E[39;49m, rc=\E8, rev=\E[7m,ri=\EM, rin=\E[%p1%dT, ritm=\E[23m, rmacs=^O,rmcup=\E[?1049l, rmir=\E[4l, rmkx=\E[?1l\E>, rmso=\E[27m,rmul=\E[24m, rs2=\Ec\E[?1000l\E[?25h, sc=\E7,setab=\E[%?%p1%{8}%<%t4%p1%d%e%p1%{16}%<%t10%p1%{8}%-%d%e48;5;%p1%d%;m,setaf=\E[%?%p1%{8}%<%t3%p1%d%e%p1%{16}%<%t9%p1%{8}%-%d%e38;5;%p1%d%;m,sgr=\E[0%?%p6%t;1%;%?%p2%t;4%;%?%p1%p3%|%t;7%;%?%p4%t;5%;%?%p5%t;2%;%?%p7%t;8%;m%?%p9%t\016%e\017%;,sgr0=\E[m\017, sitm=\E[3m, smacs=^N, smcup=\E[?1049h,smir=\E[4h, smkx=\E[?1h\E=, smso=\E[7m, smul=\E[4m,tbc=\E[3g, tsl=\E]0;, u6=\E[%i%d;%dR, u7=\E[6n,u8=\E[?1;2c, u9=\E[c, vpa=\E[%i%p1%dd,
EOF

if [ "$TERM" = "xterm-256color" -o "$TERM" = "tmux-256color" ] && command -v tic >/dev/null 2>&1; then
    TERMINFO="$IAM_HOME/terminfo"
    export TERMINFO
    tic "$IAM_HOME/terminfo/.terminfo" >/dev/null 2>&1 || true
fi

cat <<'EOF' > "$HOME/.tclshrc"
if { !$::tcl_interactive } return
puts "Tcl $tcl_patchLevel"
if { [file exists [file join $::env(IAM_HOME) tools tcl TclReadLine]] } {
lappend auto_path [file join $::env(IAM_HOME) tools tcl TclReadLine]
package require TclReadLine
set ::TclReadLine::HISTFILE     [file join $::env(IAM_HOME) tclline_history]
set ::TclReadLine::HISTORY_SIZE 99999
TclReadLine::interact
}
EOF

cat <<'EOF' > "$IAM_HOME/vimrc"
set nocompatible
set t_Co=256
set nowrap
set tabstop=4
set backspace=indent,eol,start
set autoindent
set copyindent
set number
set shiftwidth=4
set shiftround
set showmatch
set matchtime=3
set ignorecase
set smartcase
set smarttab
set expandtab
set hlsearch
set incsearch
if maparg('<C-L>', 'n') ==# ''
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif
set history=1000
set undolevels=1000
set notitle
set visualbell
set noerrorbells
set noshowmode
set ruler
set laststatus=2
set complete-=i
set notimeout
set ttimeout
set ttimeoutlen=100
set wildmenu
set wildignore=*.swp,*.bak,*.pyc,*.class
set directory=$IAM_HOME/vim_swap//,~/tmp//,/var/tmp//,/tmp//,.
set runtimepath=$IAM_HOME/vim_runtime,$VIMRUNTIME
if version >= 600
filetype plugin indent on
else
filetype on
endif
set list
set listchars=tab:>.,trail:.,extends:>,precedes:<,nbsp:.
if v:version > 703 || v:version == 703 && has("patch541")
set formatoptions+=j " Delete comment character when joining commented lines
endif
if !&scrolloff
set scrolloff=1
endif
if !&sidescrolloff
set sidescrolloff=5
endif
set display+=lastline
command! Q :q
command! Wq :wq
command! Wqa :wqa
noremap <C-s>  :update<CR>
vnoremap <C-s> <C-C>:update<CR>
inoremap <C-s> <Esc>:update<CR>gi
func! PasteGuard()
if !exists("g:paste_prev") | let g:paste_prev = &paste | endif
if !exists("g:paste_guard") | let g:paste_guard = 0 | endif
if g:paste_prev != &paste
let g:paste_prev = &paste
if &paste && g:paste_guard == 1
let g:paste_guard = 2
call timer_start(1, { -> PasteChange() })
endif
if !&paste && g:paste_guard == 2
let g:paste_guard = 0
call timer_start(1, { -> PasteChange() })
endif
endif
return ''
endfunc
func! PasteChange()
if &paste
if mode() == 'n'
call feedkeys("i")
endif
let g:paste_num = &number
let g:paste_list = &list
set nonumber nolist
else
if mode() == 'i'
call feedkeys("\<C-\>\<C-n>")
endif
let &number = g:paste_num
let &list = g:paste_list
endif
redrawstatus!
endfunc
augroup PasteGuardAU
au!
au InsertLeave * if mode(1) == "n" && &paste | set nopaste | endif
augroup END
nnoremap <silent> <special> <F2> :let g:paste_guard=1<CR>:set invpaste<CR>
inoremap <silent> <special> <F2> <C-O>:let g:paste_guard=1<CR><C-O>:set invpaste<CR>
set pastetoggle=<F2>
set statusline=
set statusline+=%{PasteGuard()}
set statusline+=%#DiffText#%{(&paste&&mode()=='i')?'\ \ PASTE\ \ ':''}
set statusline+=%#DiffChange#%{(!&paste&&mode()=='i')?'\ \ INSERT\ ':''}
set statusline+=%#DiffAdd#%{(mode()=='n')?'\ \ NORMAL\ ':''}
set statusline+=%#DiffDelete#%{(mode()=='r')?'\ \ RPLACE\ ':''}
set statusline+=%#Cursor#%{(mode()=='v')?'\ \ VISUAL\ ':''}
set statusline+=\ %n
set statusline+=\ %#Visual#
set statusline+=%{(&paste&&mode()!='i')?'\ PASTE\ ':''}
set statusline+=%{&spell?'\ SPELL\ ':''}
set statusline+=%#CursorIM#
set statusline+=%R
set statusline+=%M
set statusline+=%#Cursor#
set statusline+=%#CursorLine#
set statusline+=\ %t
set statusline+=\ %=
set statusline+=%#CursorLine#
if v:version > 802 || v:version == 802 && has("patch2854")
set statusline+=\ [StripSpaces:%{%exists('#StripTrailingWhitespace#BufWritePre')?'%#diffChanged#ON':'%#diffRemoved#OFF'%}%#CursorLine#]
else
set statusline+=\ [StripSpaces:
set statusline+=%#diffChanged#%{exists('#StripTrailingWhitespace#BufWritePre')?'ON':''}
set statusline+=%#diffRemoved#%{exists('#StripTrailingWhitespace#BufWritePre')?'':'OFF'}
set statusline+=%#CursorLine#]
endif
set statusline+=\ [FileType:%Y]
set statusline+=\ %#CursorIM#
set statusline+=\ [Line:%-3l\ Column:%-3c]
set statusline+=\ %#Cursor#
set statusline+=\ %3p%%\ %##
set background=dark
highlight clear
if !has('gui_running')
if exists('+termguicolors')
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
let &termguicolors = v:true
endif
if v:version > 800 || v:version == 800 && has('patch210')
let &t_BE = "\<Esc>[?2004h"
let &t_BD = "\<Esc>[?2004l"
let &t_PS = "\<Esc>[200~"
let &t_PE = "\<Esc>[201~"
endif
if v:version > 802 || v:version == 802 && has('patch2345')
let &t_fe = "\<Esc>[?1004h"
let &t_fd = "\<Esc>[?1004l"
if v:version > 802 || v:version == 802 && has('patch2383')
execute "set <FocusGained>=\<Esc>[I"
execute "set <FocusLost>=\<Esc>[O"
endif
endif
endif
if exists("syntax_on")
syntax reset
endif
let g:terminal_ansi_colors = [
\ '#1d2021', '#cc241d', '#98971a', '#d79921', '#458588', '#b16286', '#689d6a', '#bdae93',
\ '#7c6f64', '#fb4934', '#b8bb26', '#fabd2f', '#83a598', '#d3869b', '#8ec07c', '#ebdbb2']
hi Normal ctermfg=187 ctermbg=234 guifg=#ebdbb2 guibg=#1d2021 guisp=NONE cterm=NONE gui=NONE
hi CursorLineNr ctermfg=214 ctermbg=237 guifg=#fabd2f guibg=#3c3836 guisp=NONE cterm=NONE gui=NONE
hi FoldColumn ctermfg=102 ctermbg=237 guifg=#928374 guibg=#3c3836 guisp=NONE cterm=NONE gui=NONE
hi SignColumn ctermfg=187 ctermbg=237 guifg=#ebdbb2 guibg=#3c3836 guisp=NONE cterm=NONE gui=NONE
hi VertSplit ctermfg=59 ctermbg=234 guifg=#665c54 guibg=#1d2021 guisp=NONE cterm=NONE gui=NONE
hi ColorColumn ctermfg=NONE ctermbg=237 guifg=NONE guibg=#3c3836 guisp=NONE cterm=NONE gui=NONE
hi Conceal ctermfg=109 ctermbg=NONE guifg=#83a598 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Cursor ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE guisp=NONE cterm=NONE,reverse gui=NONE,reverse
hi! link CursorColumn CursorLine
hi CursorLine ctermfg=NONE ctermbg=237 guifg=NONE guibg=#3c3836 guisp=NONE cterm=NONE gui=NONE
hi DiffAdd ctermfg=142 ctermbg=234 guifg=#b8bb26 guibg=#1d2021 guisp=NONE cterm=NONE,reverse gui=NONE,reverse
hi DiffChange ctermfg=107 ctermbg=234 guifg=#8ec07c guibg=#1d2021 guisp=NONE cterm=NONE,reverse gui=NONE,reverse
hi DiffDelete ctermfg=203 ctermbg=234 guifg=#fb4934 guibg=#1d2021 guisp=NONE cterm=NONE,reverse gui=NONE,reverse
hi DiffText ctermfg=214 ctermbg=234 guifg=#fabd2f guibg=#1d2021 guisp=NONE cterm=NONE,reverse gui=NONE,reverse
hi Directory ctermfg=142 ctermbg=NONE guifg=#b8bb26 guibg=NONE guisp=NONE cterm=NONE,bold gui=NONE,bold
hi EndOfBuffer ctermfg=234 ctermbg=NONE guifg=#1d2021 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Error ctermfg=203 ctermbg=234 guifg=#fb4934 guibg=#1d2021 guisp=NONE cterm=NONE,bold,reverse gui=NONE,bold,reverse
hi ErrorMsg ctermfg=234 ctermbg=203 guifg=#1d2021 guibg=#fb4934 guisp=NONE cterm=NONE,bold gui=NONE,bold
hi Folded ctermfg=102 ctermbg=237 guifg=#928374 guibg=#3c3836 guisp=NONE cterm=NONE gui=NONE,italic
hi IncSearch ctermfg=208 ctermbg=234 guifg=#fe8019 guibg=#1d2021 guisp=NONE cterm=NONE,reverse gui=NONE,reverse
hi LineNr ctermfg=243 ctermbg=NONE guifg=#7c6f64 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi MatchParen ctermfg=NONE ctermbg=59 guifg=NONE guibg=#665c54 guisp=NONE cterm=NONE,bold gui=NONE,bold
hi ModeMsg ctermfg=214 ctermbg=NONE guifg=#fabd2f guibg=NONE guisp=NONE cterm=NONE,bold gui=NONE,bold
hi MoreMsg ctermfg=214 ctermbg=NONE guifg=#fabd2f guibg=NONE guisp=NONE cterm=NONE,bold gui=NONE,bold
hi NonText ctermfg=239 ctermbg=NONE guifg=#504945 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Pmenu ctermfg=187 ctermbg=239 guifg=#ebdbb2 guibg=#504945 guisp=NONE cterm=NONE gui=NONE
hi PmenuSbar ctermfg=NONE ctermbg=239 guifg=NONE guibg=#504945 guisp=NONE cterm=NONE gui=NONE
hi PmenuSel ctermfg=239 ctermbg=109 guifg=#504945 guibg=#83a598 guisp=NONE cterm=NONE,bold gui=NONE,bold
hi PmenuThumb ctermfg=NONE ctermbg=243 guifg=NONE guibg=#7c6f64 guisp=NONE cterm=NONE gui=NONE
hi Question ctermfg=208 ctermbg=NONE guifg=#fe8019 guibg=NONE guisp=NONE cterm=NONE,bold gui=NONE,bold
hi! link QuickFixLine Search
hi Search ctermfg=214 ctermbg=234 guifg=#fabd2f guibg=#1d2021 guisp=NONE cterm=NONE,reverse gui=NONE,reverse
hi SpecialKey ctermfg=239 ctermbg=NONE guifg=#504945 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi SpellBad ctermfg=203 ctermbg=NONE guifg=#fb4934 guibg=NONE guisp=#fb4934 cterm=NONE,underline gui=NONE,italic,undercurl
hi SpellCap ctermfg=109 ctermbg=NONE guifg=#83a598 guibg=NONE guisp=#83a598 cterm=NONE,underline gui=NONE,italic,undercurl
hi SpellLocal ctermfg=107 ctermbg=NONE guifg=#8ec07c guibg=NONE guisp=#8ec07c cterm=NONE,underline gui=NONE,italic,undercurl
hi SpellRare ctermfg=175 ctermbg=NONE guifg=#d3869b guibg=NONE guisp=#d3869b cterm=NONE,underline gui=NONE,italic,undercurl
hi StatusLine ctermfg=239 ctermbg=187 guifg=#504945 guibg=#ebdbb2 guisp=NONE cterm=NONE,reverse gui=NONE,reverse
hi StatusLineNC ctermfg=237 ctermbg=137 guifg=#3c3836 guibg=#a89984 guisp=NONE cterm=NONE,reverse gui=NONE,reverse
hi! link StatusLineTerm StatusLine
hi! link StatusLineTermNC StatusLineNC
hi! link TabLine TabLineFill
hi TabLineFill ctermfg=243 ctermbg=237 guifg=#7c6f64 guibg=#3c3836 guisp=NONE cterm=NONE gui=NONE
hi TabLineSel ctermfg=142 ctermbg=237 guifg=#b8bb26 guibg=#3c3836 guisp=NONE cterm=NONE gui=NONE
hi Title ctermfg=142 ctermbg=NONE guifg=#b8bb26 guibg=NONE guisp=NONE cterm=NONE,bold gui=NONE,bold
hi Visual ctermfg=NONE ctermbg=59 guifg=NONE guibg=#665c54 guisp=NONE cterm=NONE gui=NONE
hi! link VisualNOS Visual
hi WarningMsg ctermfg=203 ctermbg=NONE guifg=#fb4934 guibg=NONE guisp=NONE cterm=NONE,bold gui=NONE,bold
hi WildMenu ctermfg=109 ctermbg=239 guifg=#83a598 guibg=#504945 guisp=NONE cterm=NONE,bold gui=NONE,bold
hi Boolean ctermfg=175 ctermbg=NONE guifg=#d3869b guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Character ctermfg=175 ctermbg=NONE guifg=#d3869b guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Comment ctermfg=102 ctermbg=NONE guifg=#928374 guibg=NONE guisp=NONE cterm=NONE gui=NONE,italic
hi Conditional ctermfg=203 ctermbg=NONE guifg=#fb4934 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Constant ctermfg=175 ctermbg=NONE guifg=#d3869b guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Define ctermfg=107 ctermbg=NONE guifg=#8ec07c guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Debug ctermfg=203 ctermbg=NONE guifg=#fb4934 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Delimiter ctermfg=208 ctermbg=NONE guifg=#fe8019 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Error ctermfg=203 ctermbg=234 guifg=#fb4934 guibg=#1d2021 guisp=NONE cterm=NONE,bold,reverse gui=NONE,bold,reverse
hi Exception ctermfg=203 ctermbg=NONE guifg=#fb4934 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Float ctermfg=175 ctermbg=NONE guifg=#d3869b guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Function ctermfg=142 ctermbg=NONE guifg=#b8bb26 guibg=NONE guisp=NONE cterm=NONE,bold gui=NONE,bold
hi Identifier ctermfg=109 ctermbg=NONE guifg=#83a598 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Ignore ctermfg=fg ctermbg=NONE guifg=fg guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Include ctermfg=107 ctermbg=NONE guifg=#8ec07c guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Keyword ctermfg=203 ctermbg=NONE guifg=#fb4934 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Label ctermfg=203 ctermbg=NONE guifg=#fb4934 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Macro ctermfg=107 ctermbg=NONE guifg=#8ec07c guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Number ctermfg=175 ctermbg=NONE guifg=#d3869b guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi! link Operator Normal
hi PreCondit ctermfg=107 ctermbg=NONE guifg=#8ec07c guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi PreProc ctermfg=107 ctermbg=NONE guifg=#8ec07c guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Repeat ctermfg=203 ctermbg=NONE guifg=#fb4934 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi SpecialChar ctermfg=203 ctermbg=NONE guifg=#fb4934 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi SpecialComment ctermfg=203 ctermbg=NONE guifg=#fb4934 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Statement ctermfg=203 ctermbg=NONE guifg=#fb4934 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi StorageClass ctermfg=208 ctermbg=NONE guifg=#fe8019 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Special ctermfg=208 ctermbg=NONE guifg=#fe8019 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi String ctermfg=142 ctermbg=NONE guifg=#b8bb26 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Structure ctermfg=107 ctermbg=NONE guifg=#8ec07c guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi! link Tag Special
hi Todo ctermfg=fg ctermbg=234 guifg=fg guibg=#1d2021 guisp=NONE cterm=NONE,bold gui=NONE,bold,italic
hi Type ctermfg=214 ctermbg=NONE guifg=#fabd2f guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Typedef ctermfg=214 ctermbg=NONE guifg=#fabd2f guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi Underlined ctermfg=109 ctermbg=NONE guifg=#83a598 guibg=NONE guisp=NONE cterm=NONE,underline gui=NONE,underline
hi! link lCursor Cursor
hi CursorIM ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE guisp=NONE cterm=NONE,reverse gui=NONE,reverse
hi ToolbarLine ctermfg=NONE ctermbg=59 guifg=NONE guibg=#665c54 guisp=NONE cterm=NONE gui=NONE
hi ToolbarButton ctermfg=230 ctermbg=59 guifg=#fdf4c1 guibg=#665c54 guisp=NONE cterm=NONE,bold gui=NONE,bold
hi! link iCursor Cursor
hi! link vCursor Cursor
hi NormalMode ctermfg=137 ctermbg=234 guifg=#a89984 guibg=#1d2021 guisp=NONE cterm=NONE,reverse gui=NONE,reverse
hi InsertMode ctermfg=109 ctermbg=234 guifg=#83a598 guibg=#1d2021 guisp=NONE cterm=NONE,reverse gui=NONE,reverse
hi ReplaceMode ctermfg=107 ctermbg=234 guifg=#8ec07c guibg=#1d2021 guisp=NONE cterm=NONE,reverse gui=NONE,reverse
hi VisualMode ctermfg=208 ctermbg=234 guifg=#fe8019 guibg=#1d2021 guisp=NONE cterm=NONE,reverse gui=NONE,reverse
hi CommandMode ctermfg=175 ctermbg=234 guifg=#d3869b guibg=#1d2021 guisp=NONE cterm=NONE,reverse gui=NONE,reverse
hi Warnings ctermfg=208 ctermbg=234 guifg=#fe8019 guibg=#1d2021 guisp=NONE cterm=NONE,reverse gui=NONE,reverse
if has('nvim')
let g:terminal_color_0  = '#1d2021'
let g:terminal_color_8  = '#928374'
let g:terminal_color_1  = '#cc241d'
let g:terminal_color_9  = '#fb4934'
let g:terminal_color_2  = '#98971a'
let g:terminal_color_10 = '#b8bb26'
let g:terminal_color_3  = '#d79921'
let g:terminal_color_11 = '#fabd2f'
let g:terminal_color_4  = '#458588'
let g:terminal_color_12 = '#83a598'
let g:terminal_color_5  = '#b16286'
let g:terminal_color_13 = '#d3869b'
let g:terminal_color_6  = '#689d6a'
let g:terminal_color_14 = '#8ec07c'
let g:terminal_color_7  = '#a89984'
let g:terminal_color_15 = '#ebdbb2'
hi! link TermCursor Cursor
hi TermCursorNC ctermfg=237 ctermbg=187 guifg=#3c3836 guibg=#ebdbb2 guisp=NONE cterm=NONE gui=NONE
endif
hi diffAdded ctermfg=142 ctermbg=NONE guifg=#b8bb26 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi diffRemoved ctermfg=203 ctermbg=NONE guifg=#fb4934 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi diffChanged ctermfg=107 ctermbg=NONE guifg=#8ec07c guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi diffFile ctermfg=208 ctermbg=NONE guifg=#fe8019 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi diffNewFile ctermfg=214 ctermbg=NONE guifg=#fabd2f guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi diffLine ctermfg=109 ctermbg=NONE guifg=#83a598 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi htmlTag ctermfg=109 ctermbg=NONE guifg=#83a598 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi htmlEndTag ctermfg=109 ctermbg=NONE guifg=#83a598 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi htmlTagName ctermfg=107 ctermbg=NONE guifg=#8ec07c guibg=NONE guisp=NONE cterm=NONE,bold gui=NONE,bold
hi htmlArg ctermfg=107 ctermbg=NONE guifg=#8ec07c guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi htmlScriptTag ctermfg=175 ctermbg=NONE guifg=#d3869b guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi htmlTagN ctermfg=187 ctermbg=NONE guifg=#ebdbb2 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi htmlSpecialTagName ctermfg=107 ctermbg=NONE guifg=#8ec07c guibg=NONE guisp=NONE cterm=NONE,bold gui=NONE,bold
hi htmlLink ctermfg=137 ctermbg=NONE guifg=#a89984 guibg=NONE guisp=NONE cterm=NONE,underline gui=NONE,underline
hi htmlSpecialChar ctermfg=208 ctermbg=NONE guifg=#fe8019 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi htmlBold ctermfg=fg ctermbg=234 guifg=fg guibg=#1d2021 guisp=NONE cterm=NONE,bold gui=NONE,bold
hi htmlBoldUnderline ctermfg=fg ctermbg=234 guifg=fg guibg=#1d2021 guisp=NONE cterm=NONE,bold,underline gui=NONE,bold,underline
hi htmlBoldItalic ctermfg=fg ctermbg=234 guifg=fg guibg=#1d2021 guisp=NONE cterm=NONE,bold,italic gui=NONE,bold,italic
hi htmlBoldUnderlineItalic ctermfg=fg ctermbg=234 guifg=fg guibg=#1d2021 guisp=NONE cterm=NONE,bold,italic,underline gui=NONE,bold,italic,underline
hi htmlUnderline ctermfg=fg ctermbg=234 guifg=fg guibg=#1d2021 guisp=NONE cterm=NONE,underline gui=NONE,underline
hi htmlUnderlineItalic ctermfg=fg ctermbg=234 guifg=fg guibg=#1d2021 guisp=NONE cterm=NONE,italic,underline gui=NONE,italic,underline
hi htmlItalic ctermfg=fg ctermbg=234 guifg=fg guibg=#1d2021 guisp=NONE cterm=NONE,italic gui=NONE,italic
hi xmlTag ctermfg=109 ctermbg=NONE guifg=#83a598 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi xmlEndTag ctermfg=109 ctermbg=NONE guifg=#83a598 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi xmlTagName ctermfg=109 ctermbg=NONE guifg=#83a598 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi xmlEqual ctermfg=109 ctermbg=NONE guifg=#83a598 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi docbkKeyword ctermfg=107 ctermbg=NONE guifg=#8ec07c guibg=NONE guisp=NONE cterm=NONE,bold gui=NONE,bold
hi xmlDocTypeDecl ctermfg=102 ctermbg=NONE guifg=#928374 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi xmlDocTypeKeyword ctermfg=175 ctermbg=NONE guifg=#d3869b guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi xmlCdataStart ctermfg=102 ctermbg=NONE guifg=#928374 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi xmlCdataCdata ctermfg=175 ctermbg=NONE guifg=#d3869b guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi dtdFunction ctermfg=102 ctermbg=NONE guifg=#928374 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi dtdTagName ctermfg=175 ctermbg=NONE guifg=#d3869b guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi xmlAttrib ctermfg=107 ctermbg=NONE guifg=#8ec07c guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi xmlProcessingDelim ctermfg=102 ctermbg=NONE guifg=#928374 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi dtdParamEntityPunct ctermfg=102 ctermbg=NONE guifg=#928374 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi dtdParamEntityDPunct ctermfg=102 ctermbg=NONE guifg=#928374 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi xmlAttribPunct ctermfg=102 ctermbg=NONE guifg=#928374 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi xmlEntity ctermfg=208 ctermbg=NONE guifg=#fe8019 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi xmlEntityPunct ctermfg=208 ctermbg=NONE guifg=#fe8019 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi vimCommentTitle ctermfg=137 ctermbg=NONE guifg=#a89984 guibg=NONE guisp=NONE cterm=NONE,bold gui=NONE,bold
hi vimNotation ctermfg=208 ctermbg=NONE guifg=#fe8019 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi vimBracket ctermfg=208 ctermbg=NONE guifg=#fe8019 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi vimMapModKey ctermfg=208 ctermbg=NONE guifg=#fe8019 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi vimFuncSID ctermfg=144 ctermbg=NONE guifg=#bdae93 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi vimSetSep ctermfg=144 ctermbg=NONE guifg=#bdae93 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi vimSep ctermfg=144 ctermbg=NONE guifg=#bdae93 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi vimContinue ctermfg=144 ctermbg=NONE guifg=#bdae93 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi markdownItalic ctermfg=144 ctermbg=NONE guifg=#bdae93 guibg=NONE guisp=NONE cterm=NONE,italic gui=NONE,italic
hi markdownH1 ctermfg=142 ctermbg=NONE guifg=#b8bb26 guibg=NONE guisp=NONE cterm=NONE,bold gui=NONE,bold
hi markdownH2 ctermfg=142 ctermbg=NONE guifg=#b8bb26 guibg=NONE guisp=NONE cterm=NONE,bold gui=NONE,bold
hi markdownH3 ctermfg=214 ctermbg=NONE guifg=#fabd2f guibg=NONE guisp=NONE cterm=NONE,bold gui=NONE,bold
hi markdownH4 ctermfg=214 ctermbg=NONE guifg=#fabd2f guibg=NONE guisp=NONE cterm=NONE,bold gui=NONE,bold
hi markdownH5 ctermfg=214 ctermbg=NONE guifg=#fabd2f guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi markdownH6 ctermfg=214 ctermbg=NONE guifg=#fabd2f guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi markdownCode ctermfg=107 ctermbg=NONE guifg=#8ec07c guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi markdownCodeBlock ctermfg=107 ctermbg=NONE guifg=#8ec07c guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi markdownCodeDelimiter ctermfg=107 ctermbg=NONE guifg=#8ec07c guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi markdownBlockquote ctermfg=102 ctermbg=NONE guifg=#928374 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi markdownListMarker ctermfg=102 ctermbg=NONE guifg=#928374 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi markdownOrderedListMarker ctermfg=102 ctermbg=NONE guifg=#928374 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi markdownRule ctermfg=102 ctermbg=NONE guifg=#928374 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi markdownHeadingRule ctermfg=102 ctermbg=NONE guifg=#928374 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi markdownUrlDelimiter ctermfg=144 ctermbg=NONE guifg=#bdae93 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi markdownLinkDelimiter ctermfg=144 ctermbg=NONE guifg=#bdae93 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi markdownLinkTextDelimiter ctermfg=144 ctermbg=NONE guifg=#bdae93 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi markdownHeadingDelimiter ctermfg=208 ctermbg=NONE guifg=#fe8019 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi markdownUrl ctermfg=175 ctermbg=NONE guifg=#d3869b guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi markdownUrlTitleDelimiter ctermfg=142 ctermbg=NONE guifg=#b8bb26 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi markdownLinkText ctermfg=102 ctermbg=NONE guifg=#928374 guibg=NONE guisp=NONE cterm=NONE,underline gui=NONE,underline
hi! link markdownIdDeclaration markdownLinkText
hi jsonKeyword ctermfg=142 ctermbg=NONE guifg=#b8bb26 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi jsonQuote ctermfg=142 ctermbg=NONE guifg=#b8bb26 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi jsonBraces ctermfg=187 ctermbg=NONE guifg=#ebdbb2 guibg=NONE guisp=NONE cterm=NONE gui=NONE
hi jsonString ctermfg=187 ctermbg=NONE guifg=#ebdbb2 guibg=NONE guisp=NONE cterm=NONE gui=NONE
if has('syntax') && !exists('g:syntax_on')
syntax enable
endif
if exists('+colorcolumn')
set colorcolumn=80
endif
nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
if !exists("*synstack")
return
endif
echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
function! <SID>lastplace()
if index(split("quickfix,nofile,help", ","), &buftype) != -1
return
endif
if index(split("gitcommit,gitrebase,svn,hgcommit", ","), &filetype) != -1
return
endif
try
if empty(glob(@%))
return
endif
catch
return
endtry
if line("'\"") > 0 && line("'\"") <= line("$")
if line("w$") == line("$")
execute "normal! g`\""
elseif line("$") - line("'\"") > ((line("w$") - line("w0")) / 2) - 1
execute "normal! g`\"zz"
else
execute "normal! \G'\"\<c-e>"
endif
endif
if foldclosed(".") != -1
execute "normal! zvzz"
endif
endfunc
augroup RestoreCursorPosition
au!
au BufWinEnter * call <SID>lastplace()
augroup END
func! <SID>stripTrailingWhitespace()
normal mZ
let l:winview = winsaveview()
let l:chars = col("$")
%s/\s\+$//e
if (line("'Z") != line(".")) || (l:chars != col("$"))
echo "Warning: trailing whitespaces have been removed! Use UNDO to restore deleted whitespaces.\n"
endif
call winrestview(l:winview)
endfunc
func! ToggleStripTrailingWhitespace()
if exists('#StripTrailingWhitespace#BufWritePre')
augroup StripTrailingWhitespace
au!
augroup END
else
augroup StripTrailingWhitespace
au!
au BufWritePre * call <SID>stripTrailingWhitespace()
augroup END
endif
endfunc
augroup WhitespacesEOL
au!
au BufWinEnter * hi WhitespaceEOL ctermbg=red guibg=red | match WhitespaceEOL /\s\+$/
au InsertEnter * match WhitespaceEOL /\s\+\%#\@<!$/
au InsertLeave * match WhitespaceEOL /\s\+$/
au BufWinLeave * call clearmatches()
augroup END
augroup SpecialFileTypes
au!
au BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
au FileType yaml setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=0# indentkeys-=0} indentkeys-=0] indentkeys-=<:> indentkeys-=0-
au FileType html,xml setlocal listchars-=tab:>.
augroup END
command ToggleStripTrailingWhitespace :call ToggleStripTrailingWhitespace()
call ToggleStripTrailingWhitespace()
let g:colorizer_auto_filetype = 'css,html'
let g:colorizer_fgcontrast = 0
EOF

# avoid issue with some overflow when the file is more than 65536 bytes
cat <<'EOF' > "$IAM_HOME/bashrc"
LOCAL_TOOLS_FILE_HASH=0988C694
BASHRC_FILE_HASH=33AC3CDB
declare -A -r __CPRINTF_COLORS=(
[fw]=$'\e[37m' [fW]=$'\e[97m'
[fk]=$'\e[30m' [fK]=$'\e[90m'
[fr]=$'\e[31m' [fR]=$'\e[91m'
[fg]=$'\e[32m' [fG]=$'\e[92m'
[fy]=$'\e[33m' [fY]=$'\e[93m'
[fb]=$'\e[34m' [fB]=$'\e[94m'
[fm]=$'\e[35m' [fM]=$'\e[95m'
[fc]=$'\e[36m' [fC]=$'\e[96m'
[bw]=$'\e[47m' [bW]=$'\e[107m'
[bk]=$'\e[40m' [bK]=$'\e[100m'
[br]=$'\e[41m' [bR]=$'\e[101m'
[bg]=$'\e[42m' [bG]=$'\e[102m'
[by]=$'\e[43m' [bY]=$'\e[103m'
[bb]=$'\e[44m' [bB]=$'\e[104m'
[bm]=$'\e[45m' [bM]=$'\e[105m'
[bc]=$'\e[46m' [bC]=$'\e[106m'
[d]=$'\e[0m'
)
cprintf() {
{
local LC_ALL=C LC_TYPE=C
local __CPRINTF_VAR_NAME __CPRINTF_APPEND __CPRINTF_NEW_LINE=1 __CPRINTF_CLEAR=1 __CPRINTF_QUOTE __CPRINTF_QUOTE_SKIP
local __CPRINTF_RESULT __CPRINTF_PROCESS __CPRINTF_PART __CPRINTF_HAS_COLOR __CPRINTF_HAS_BG
local -a __CPRINTF_PARTS
case "$1" in
-a) __CPRINTF_VAR_NAME="$2"; __CPRINTF_APPEND=1; shift 2;;
-A) __CPRINTF_VAR_NAME="$2"; __CPRINTF_APPEND=2; shift 2;;
-v) __CPRINTF_VAR_NAME="$2"; shift 2;;
-n) unset __CPRINTF_NEW_LINE; shift;;
esac
[ "$1" != "-c" ] || { unset __CPRINTF_CLEAR; shift; }
[ "$1" != "--" ] || { shift; }
IFS='~' read -ra __CPRINTF_PARTS <<< "$1"
shift
[ "$__CPRINTF_VAR_NAME" != "PS1" ] || __CPRINTF_QUOTE=1
for __CPRINTF_PART in "${__CPRINTF_PARTS[@]}"; do
if [ "$__CPRINTF_PROCESS" ]; then
case "$__CPRINTF_PART" in
d)
__CPRINTF_PART=${__CPRINTF_COLORS["$__CPRINTF_PART"]}
unset __CPRINTF_HAS_COLOR __CPRINTF_HAS_BG
;;
[wWkKrRgGyYbBmMcC])
__CPRINTF_PART=${__CPRINTF_COLORS["f$__CPRINTF_PART"]}
if [ -n "$__CPRINTF_HAS_BG" ]; then
__CPRINTF_PART="${__CPRINTF_COLORS['d']}$__CPRINTF_PART"
unset __CPRINTF_HAS_BG
fi
__CPRINTF_HAS_COLOR=1
;;
[wWkKrRgGyYbBmMcC][wWkKrRgGyYbBmMcC])
__CPRINTF_PART="${__CPRINTF_COLORS["f${__CPRINTF_PART:0:1}"]}${__CPRINTF_COLORS["b${__CPRINTF_PART:1:1}"]}"
__CPRINTF_HAS_COLOR=1
__CPRINTF_HAS_BG=1
;;
[0-9]|[0-9][0-9]|[0-9][0-9][0-9])
__CPRINTF_PART=$'\e[38;5;'"${__CPRINTF_PART}m"
if [ -n "$__CPRINTF_HAS_BG" ]; then
__CPRINTF_PART="${__CPRINTF_COLORS['d']}$__CPRINTF_PART"
unset __CPRINTF_HAS_BG
fi
__CPRINTF_HAS_COLOR=1
;;
*)
if [[ "$__CPRINTF_PART" =~ ^[0-9]{1,3}\ [0-9]{1,3}$ ]]; then
__CPRINTF_PART=$'\e[38;5;'"${__CPRINTF_PART% *}m"$'\e[48;5;'"${__CPRINTF_PART#* }m"
__CPRINTF_HAS_COLOR=1
__CPRINTF_HAS_BG=1
else
__CPRINTF_PART="~${__CPRINTF_PART}~"
__CPRINTF_QUOTE_SKIP=1
fi
;;
esac
if [ -n "$__CPRINTF_QUOTE" ]; then
[ -n "$__CPRINTF_QUOTE_SKIP" ] \
&& unset __CPRINTF_QUOTE_SKIP \
|| __CPRINTF_PART="\\[${__CPRINTF_PART}\\]"
fi
unset __CPRINTF_PROCESS
else
__CPRINTF_PROCESS=1
fi
__CPRINTF_RESULT+=$__CPRINTF_PART
done
if [[ "$__CPRINTF_CLEAR" ]] && [[ "$__CPRINTF_HAS_COLOR" ]]; then
if [ -n "$__CPRINTF_QUOTE" ]; then
__CPRINTF_RESULT+="\\[${__CPRINTF_COLORS['d']}\\]"
else
__CPRINTF_RESULT+=${__CPRINTF_COLORS['d']}
fi
fi
if [[ "$__CPRINTF_VAR_NAME" ]]; then
if [[ "$__CPRINTF_APPEND" ]] && [[ "${!__CPRINTF_VAR_NAME}" ]]; then
printf -v __CPRINTF_RESULT "$__CPRINTF_RESULT" "$@" 2>&3
if [ "$__CPRINTF_APPEND" -eq 1 ]; then
printf -v "$__CPRINTF_VAR_NAME" '%s%s' "${!__CPRINTF_VAR_NAME}" "$__CPRINTF_RESULT"
else
printf -v "$__CPRINTF_VAR_NAME" '%s %s' "${!__CPRINTF_VAR_NAME}" "$__CPRINTF_RESULT"
fi
else
printf -v "$__CPRINTF_VAR_NAME" "$__CPRINTF_RESULT" "$@" 2>&3
fi
else
if [[ "$__CPRINTF_NEW_LINE" ]]; then
__CPRINTF_RESULT+='\n'
fi
printf "$__CPRINTF_RESULT" "$@" 2>&3
fi
} 3>&2 2>/dev/null
}
_warn() { cprintf "~y~WARNING~K~:~d~ $1" "${@:2}"; }
_err() { cprintf "~r~ERROR~K~:~d~ $1" "${@:2}"; }
_info() { cprintf "~g~Info~K~:~d~ $1" "${@:2}"; }
_dbg() { cprintf "~K~Debug:~d~ $1" "${@:2}"; }
_trim() {
local __TRIM_VAR __TRIM_WHAT='[:space:]' __TRIM_L=1 __TRIM_R=1
[ "$1" != "-r" ] || { unset __TRIM_L; shift; }
[ "$1" != "-l" ] || { unset __TRIM_R; shift; }
[ "$1" != "-v" ] || { __TRIM_VAR="$2"; shift 2; }
[ "$1" != "--" ] || { shift; }
[ -n "$2" ] && __TRIM_WHAT="$2" || local LC_ALL=C LC_TYPE=C
local __TRIM_OUT="$1"
[ -z "$__TRIM_L" ] || __TRIM_OUT=${__TRIM_OUT#"${__TRIM_OUT%%[!${__TRIM_WHAT}]*}"}
[ -z "$__TRIM_R" ] || __TRIM_OUT=${__TRIM_OUT%"${__TRIM_OUT##*[!${__TRIM_WHAT}]}"}
[ -z "$__TRIM_VAR" ] && echo "$__TRIM_OUT" || printf -v "$__TRIM_VAR" '%s' "$__TRIM_OUT"
}
_dirname() {
local __DIRNAME_VAR
[ "$1" != "-v" ] || { __DIRNAME_VAR="$2"; shift 2; }
[ "$1" != "--" ] || { shift; }
local __DIRNAME_OUT=${1%/*}
[ "$__DIRNAME_OUT" != "$1" ] || __DIRNAME_OUT="."
[ -z "$__DIRNAME_VAR" ] && echo "$__DIRNAME_OUT" || printf -v "$__DIRNAME_VAR" '%s' "$__DIRNAME_OUT"
}
_basename() {
local __BASENAME_VAR
[ "$1" != "-v" ] || { __BASENAME_VAR="$2"; shift 2; }
[ "$1" != "--" ] || { shift; }
local __BASENAME_OUT
if [ -n "$1" ]; then
_trim -r -v __BASENAME_OUT "$1" "/"
[ -z "$__BASENAME_OUT" ] && __BASENAME_OUT="/" || __BASENAME_OUT="${__BASENAME_OUT##*/}"
fi
[ -z "$__BASENAME_VAR" ] && echo "$__BASENAME_OUT" || printf -v "$__BASENAME_VAR" '%s' "$__BASENAME_OUT"
}
_absname() {
local __ABSNAME_VAR
[ "$1" != "-v" ] || { __ABSNAME_VAR="$2"; shift 2; }
[ "$1" != "--" ] || { shift; }
local __ABSNAME_OUT
case "$1" in
/*) __ABSNAME_OUT="$1";;
""|".") __ABSNAME_OUT="$PWD";;
./*) __ABSNAME_OUT="$PWD/${1:2}";;
*) __ABSNAME_OUT="$PWD/$1";;
esac
[ -z "$__ABSNAME_VAR" ] && echo "$__ABSNAME_OUT" || printf -v "$__ABSNAME_VAR" '%s' "$__ABSNAME_OUT"
}
_hash_file() {
local SOURCE_FILE="$1" SOURCE_BASENAME="${1##*/}" SOURCE_PATH="${1%/*}"
[ "$SOURCE_BASENAME" != "$SOURCE_PATH" ] || SOURCE_PATH="$PWD"
local HASH_CACHE_PATH="$IAM_HOME/.cache/hash_file"
_hash "$SOURCE_PATH"
local HASH_FILE="$HASH_CACHE_PATH/${SOURCE_BASENAME}.${_HASH}.hash"
if [ -f "$HASH_FILE" ] && [ "$HASH_FILE" -nt "$SOURCE_FILE" ]; then
_HASH="$(<"$HASH_FILE")"
else
_hash < "$SOURCE_FILE"
[ -d "$HASH_CACHE_PATH" ] || mkdir -p "$HASH_CACHE_PATH"
printf '%s' "$_HASH" > "$HASH_FILE"
fi
}
_cache() {
_hash "$@"
local V="__CACHE_$_HASH"
[ -n "${!V}" ] || printf -v "$V" '%s' "$("$@")"
_CACHE="${!V}"
}
_check() {
_hash "$@"
local V="__CACHE_CHECK_$_HASH"
[ -n "${!V}" ] || { "$@" >/dev/null 2>&1 && printf -v "$V" 0 || printf -v "$V" 1; }
return "${!V}"
}
_once() {
_hash "$@"
local V="__CACHE_ONCE_$_HASH"
[ -z "${!V}" ] || return 1
printf -v "$V" 0
return 0
}
_create_flag() {
printf '' >> "$1"
}
_glob_match() {
eval "case \"\$2\" in ${1// /\\ }) return 0;; *) return 1;; esac"
}
_get_size() {
if _check command stat --version; then
command stat -c '%s' "$@"
elif _check command stat -F /dev/null; then
command stat -f '%z' "$@"
elif _check command du --bytes /dev/null; then
command du --bytes --summarize "$@" | awk '{ print $1 }'
else
local a
for a; do echo "unknown"; done
fi
}
_get_hash() {
while [ $# -gt 0 ]; do
_hash_file "$1"
echo "$_HASH"
shift
done
}
_get_url() {
if [ "$1" = "-check" ]; then
if _has curl || _has wget || _has openssl || [ -x /usr/lib/apt/apt-helper ]; then
return 0
else
return 1
fi
fi
local URL="$1"
if _has curl; then
set -- --fail --silent --show-error -k -L "$URL"
_isnot need_proxy || set -- --proxy "http://127.0.0.1:52011" "$@"
curl "$@"
elif _has wget; then
set -- -q -O - "$URL"
_isnot need_proxy || set -- -e "use_proxy=on" -e "https_proxy=http://127.0.0.1:52011" "$@"
wget "$@"
elif [ -x /usr/lib/apt/apt-helper ]; then
local R OUT ERR TMP
TMP="$(mktemp)"
_catch OUT ERR /usr/lib/apt/apt-helper -oAcquire::https::Verify-Peer=false download-file "$URL" "$TMP" && R=0 || R=$?
if [ $R -eq 0 ]; then
cat "$TMP"
else
echo "$ERR" >&2
fi
rm -f "$TMP"
return $R
elif _has openssl; then
local LOOP=1
while [ -n "$LOOP" ]; do
local X="$URL" HOST UPATH PORT=443 R="" S=""
unset LOOP
X="${X#https://}"
HOST="${X%%/*}"
UPATH="/${X#*/}"
[ "$UPATH" != "/$X" ] || UPATH="/"
while IFS= read -r line; do
if [ -z "$R" ]; then
R="${line#* }"
S="${R%% *}"
if [ "$S" != "200" ] && [ "$S" != "301" ] && [ "$S" != "302" ]; then
echo "Error: $R" >&2
return 1
fi
elif [ "${line%% *}" = "Location:" ]; then
URL="${line#* }"
URL="${URL%$'\r'}"
[ "${URL#https://}" != "$URL" ] || URL="https://$HOST$URL"
LOOP=1
break
elif [ "${#line}" -eq 1 ]; then
cat
fi
done < <(printf '%s\r\n' "GET $UPATH HTTP/1.1" "Host: $HOST" "Connection: Close" "" | openssl s_client -quiet -connect "$HOST:$PORT" 2>/dev/null)
done
else
return 1
fi
}
_has() { _check command -v "$1" && return 0 || return 1; }
_hasnot() { _has "$1" && return 1 || return 0; }
_has_local() {
[ -n "$__INSTALL_FUNCTIONS_AVAILABLE" ] || return 1
local EXECUTABLE="$IAM_HOME/tools/bin/$1"
_isnot windows || EXECUTABLE="${EXECUTABLE}.exe"
[ -x "$EXECUTABLE" ] && return 0 || return 1
}
_has_executable() { builtin type -P "$1" >/dev/null && return 0 || return 1; }
_has_function() { declare -f -F "$1" >/dev/null && return 0 || return 1; }
_maybe_local() {
if [ -n "$__INSTALL_FUNCTIONS_AVAILABLE" ] && _check _is_install_available "$1"; then
if _has_local "$1" || ! _has_executable "$1"; then
,install -executable "$1" || :
fi
fi
}
_has_potentially() {
_hasnot "$1" || return 0
[ -n "$__INSTALL_FUNCTIONS_AVAILABLE" ] && _check _is_install_available "$1" && return 0 || return 1
}
_hasnot_potentially() { _has_potentially "$1" && return 1 || return 0; }
_hash() {
{
if [ $# -eq 0 ]; then
_hash_in
else
local LC_ALL=C LC_TYPE=C
local A=1 B=0 C i M="$*"
local L=${#M}
for (( i = 0; i < L; i++ )); do
printf -v C '%d' "'${M:i:1}"
(( A = (A + C) % 65521 )) || :
(( B = (B + A) % 65521 )) || :
done
printf -v _HASH '%08X' $(( A + ( B << 16 ) ))
fi
} 2>/dev/null
: _HASH = "$_HASH"
}
if _has perl; then
_hash_in() {
_HASH="$(command perl -e '$a=1;$b=0;while(read(STDIN,$c,1)){$a=($a+ord$c)%65521;$b=($b+$a)%65521}printf("%08X",($b<<16)|$a)')"
}
elif _has python3; then
_hash_in() {
_HASH="$(command python3 -c 'import sys;a,b=1,0;exec("for c in sys.stdin.buffer.read(): a=(a+c)%65521; b=(b+a)%65521");print(f"{(b<<16)|a:08X}",end="")')"
}
else
_hash_in() {
{
local LC_ALL=C LC_TYPE=C
local A=1 B=0 C
while IFS= read -d '' -r -n1 C; do
printf -v C '%d' "'$C"
(( A = (A + C) % 65521 )) || :
(( B = (B + A) % 65521 )) || :
done
printf -v _HASH '%08X' $(( A + ( B << 16 ) ))
} 2>/dev/null
}
fi
__vercomp() {
local i IFS=.
local v1=($1) v2=($2)
for (( i = 0; i < ${#v1[@]} || i < ${#v2[@]}; i++ )); do
[ "${v1[i]:-0}" -le "${v2[i]:-0}" ] || return 1
[ "${v1[i]:-0}" -ge "${v2[i]:-0}" ] || return 0
done
return "$3"
}
_vercomp() {
case "$2" in
le|-le|'<=') __vercomp "$1" "$3" 0;;
lt|-lt|'<')  __vercomp "$1" "$3" 1;;
ge|-ge|'>=') ! _vercomp "$1" lt "$3";;
gt|-gt|'>')  ! _vercomp "$1" le "$3";;
esac
}
_addpath() {
local pos="end" d
if [ "$1" = "-start" ]; then
pos="start"
shift
fi
PATH=":${PATH}:"
for d; do
d="${d%/}"
PATH="${PATH//:${d}:/:}"
[ "$pos" = "end" ] && PATH="$PATH${d}:" || PATH=":$d$PATH"
done
PATH=${PATH%:}
PATH=${PATH#:}
export PATH
}
_random() {
local chars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
local V=""
if [ "$1" = "-v" ]; then
V="$2"
shift 2
fi
local count="${1:-8}"
local result=""
while [ "$count" -ne 0 ]; do
result="$result${chars:$(( RANDOM % ${#chars} )):1}"
count=$(( count - 1 ))
done
[ -n "$V" ] && printf -v "$V" '%s' "$result" || echo "$result"
}
_catch() {
local USE_V USE_X R STDOUT STDERR
[ "${-/v}" != "$-" ] && set +v && USE_V="-v" || USE_V="+v"
[ "${-/x}" != "$-" ] && set +x && USE_X="-x" || USE_X="+x"
eval "$({
STDERR="$({ STDOUT="$("${@:3}")"; } 2>&1 && R=0 || R=$?; declare -p STDOUT >&2; exit $R)" && R=0 || R=$?
declare -p STDERR
declare -p R
} 2>&1)"
printf -v "$1" '%s' "$STDOUT"
printf -v "$2" '%s' "$STDERR"
set $USE_X
set $USE_V
return "$R"
}
__uname_machine() { uname --machine 2>/dev/null || uname -m 2>/dev/null || uname -p 2>/dev/null || echo "Unknown"; }
__uname_kernel_name() { uname --kernel-name 2>/dev/null || uname -s 2>/dev/null || echo "Unknown"; }
__uname_kernel_release() { uname --kernel-release 2>/dev/null || uname -r 2>/dev/null || uname -v 2>/dev/null || echo "Unknown"; }
__uname_all() { uname --all 2>/dev/null || uname -a 2>/dev/null || echo "Unknown"; }
_is() {
local CONDITION="${1//-/_}"
local V="__CACHE_IS_$CONDITION"
[ -z "${!V}" ] || return "${!V}"
local R=0 TMPVAL
case "$CONDITION" in
x86_64|aarch64_be|aarch64|armv8b|armv8l)
_cache __uname_machine
[ "$_CACHE" = "$CONDITION" ] || R=1
;;
x64)   _is x86_64 || R=1 ;;
arm64) ! _is aarch64_be && ! _is aarch64 && ! _is armv8b && ! _is armv8l && R=1 || : ;;
hpux|aix|sunos|macos|linux|cygwin|msys|mingw)
_cache __uname_kernel_name
case "$CONDITION" in
hpux)   [ "$_CACHE" = "HP-UX" ]  || R=1 ;;
aix)    [ "$_CACHE" = "AIX" ]    || R=1 ;;
sunos)  [ "$_CACHE" = "SunOS" ]  || R=1 ;;
macos)  [ "$_CACHE" = "Darwin" ] || R=1 ;;
linux)  [ "$_CACHE" = "Linux" ]  || R=1 ;;
cygwin) [ "$_CACHE" = "${_CACHE#CYGWIN_NT*}" ] && R=1 || : ;;
msys)   [ "$_CACHE" = "${_CACHE#MSYS_NT*}" ]   && R=1 || : ;;
mingw)  [ "$_CACHE" = "${_CACHE#MINGW*}" ]     && R=1 || : ;;
esac
;;
wsl)
_is in-container && R=1 || {
_cache __uname_kernel_release
[ -z "${_CACHE%%*-WSL2}" ] || R=1
}
;;
windows)     ! _is cygwin && ! _is mingw && ! _is msys && R=1 || : ;;
unix)        ! _is windows || R=1 ;;
linux_x64)   _is linux && _is x64   || R=1 ;;
windows_x64) _is windows && _is x64 || R=1 ;;
macos_x64)   _is macos && _is x64   || R=1 ;;
root)        [ "$(id -u 2>/dev/null)" = "0" ] || R=1 ;;
in_container)
R=1
if _is linux; then
if [ ! -f /proc/1/sched ]; then
R=0
else
read -d ' ' -r TMPVAL < /proc/1/sched
[ "$TMPVAL" != "init" ] && [ "$TMPVAL" != "systemd" ] && R=0 || R=1
fi
fi
;;
in_docker)   _is in_container && [ -f /.dockerenv ] || R=1 ;;
sudo)        [ -n "$SUDO_USER" ] || R=1 ;;
tmux)        [ -n "$TMUX" ] || R=1 ;;
aws)         _is cloud && curl -s -I http://169.254.169.254 | grep -qF 'Server: EC2ws' || R=1 ;;
aws_metadata_available)
_is aws && TMPVAL="$(_aws_metadata instance-id)" && [ -n "$TMPVAL" ] || R=1
;;
cloud)
_has curl && curl -s -I --connect-timeout 0.1 -o /dev/null http://169.254.169.254 || R=1
;;
need_proxy)
[ -r /proc/net/tcp ] && {
grep -qF ': 0100007F:CB2B 00000000:0000 ' /proc/net/tcp 2>/dev/null || R=1
} || R=1
;;
*)
echo "bashrc error: unknown _is '$CONDITION'" >&2
R=1
;;
esac
printf -v "$V" '%s' "$R"
return "${!V}"
}
_isnot() { _is "$1" && return 1 || return 0; }
_unexport() {
local TMPVAL TMPVAR
for TMPVAR; do
TMPVAL="${!TMPVAR}"
unset "$TMPVAR"
printf -v "$TMPVAR" '%s' "$TMPVAL"
done
}
mkdir -p "$IAM_HOME/tools/bin"
_addpath -start "$IAM_HOME/tools/bin"
_addpath "/usr/local/bin"
if _is aix; then
_addpath -start "/opt/freeware/bin"
elif _is sunos; then
_addpath -start "/usr/xpg4/bin"
elif _is macos; then
_addpath -start "/usr/local/bin" "/usr/local/opt/coreutils/libexec/gnubin"
_addpath -start "/opt/local/bin"
elif _is msys || _is mingw; then
for i in ucrt64 clang64 mingw64; do
[ ! -d "/${i}/bin" ] || _addpath -start "/${i}/bin"
done
MSYS2_ARG_CONV_EXCL="*"
export MSYS2_ARG_CONV_EXCL
MSYS2_ENV_CONV_EXCL="*"
export MSYS2_ENV_CONV_EXCL
elif _is wsl; then
if [ -d /usr/bin/windows/System32 ]; then
_addpath -start "/usr/bin/windows" "/usr/bin/windows/System32"
fi
fi
if [ -f ~/gcloud/google-cloud-sdk/path.bash.inc ]; then
. ~/gcloud/google-cloud-sdk/path.bash.inc
fi
for fn in \
"/proc/registry/HKEY_CURRENT_USER/Environment/Path" \
"/proc/registry/HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/Control/Session Manager/Environment/Path"
do
if [ -e "$fn" ]; then
IFS= read -d $'\0' -r __val < "$fn"
while read -r -d ';' p; do
[ -n "$p" ] || continue
p="${p/\%SystemRoot\%/$SYSTEMROOT}"
p="${p/\%ProgramFiles\%/$PROGRAMFILES}"
p="${p/\%USERPROFILE\%/$USERPROFILE}"
p="${p/\%HomeDrive\%\%HomePath\%/$USERPROFILE}"
_addpath "$(cygpath -u "$p")"
done <<< "$__val;"
unset p
unset __val
fi
done
unset fn
if
! command -v vi >/dev/null 2>&1 && \
! command -v vim >/dev/null 2>&1 && \
[ ! -e "$IAM_HOME/tools/bin/vim" ] && \
[ -x /usr/bin/vim.basic ]
then
ln -sf /usr/bin/vim.basic "$IAM_HOME/tools/bin/vim"
fi
if [ "$LANG" != "en_US.UTF-8" ] && _has locale && [ "$(LANG=en_US.UTF-8 locale charmap 2>/dev/null)" = "UTF-8" ]; then
LANG="en_US.UTF-8"
export LANG
fi
mkdir -p "$IAM_HOME/state"
if [ -n "$BASHRC_FILE_HASH" ]; then
_BASHRC_STAMP_FILE="$IAM_HOME/state/bashrc.${BASHRC_FILE_HASH}.stamp"
if [ ! -e "$_BASHRC_STAMP_FILE" ]; then
rm -f "$IAM_HOME/state/bashrc."*.stamp
_create_flag "$_BASHRC_STAMP_FILE"
fi
fi
[ -e "$IAM_HOME/tmux_sessions/sessions-backup-ids" ] \
&& TMUX_TMPDIR="$IAM_HOME/tmux_sessions" tmux kill-server >/dev/null 2>&1 || true
[ -z "$IAM_HOME" ] || {
rm -rf \
"$IAM_HOME/kitty_sessions" \
"$IAM_HOME/shell_sessions" \
"$IAM_HOME/tmux_sessions"
rm -f \
"$IAM_HOME/tools/bash_completion"/ecconfigure.completion.bash \
"$IAM_HOME/tools/bash_completion"/ectool.completion.bash \
"$IAM_HOME/tools/bash_completion"/electricflow.completion.bash \
"$IAM_HOME/tools/bash_completion"/virtualbox.completion.bash \
"$IAM_HOME/tools/bash_completion"/makefile.completion.bash
}
if [ -n "$__KITTY_ID" ]; then
_TERM_SESSION_ID="$__KITTY_ID"
unset __KITTY_ID
fi
if [ -n "$_TERM_SESSION_ID" ]; then
_unexport _TERM_SESSION_ID
_TERM_SESSION_DIR="$IAM_HOME/session/term/id-$_TERM_SESSION_ID"
mkdir -p "$_TERM_SESSION_DIR"
fi
tools() {
local CMD="$1"
local PARAM="$2"
local PARAM_EX="$3"
local LINE
local I_DESC I_URL I_FILE I_SIZE I_FILTER_IS I_FILTER_HAS I_ON_UPDATE
local SIZE HASH
local CHECK_STATE
local IS_ERROR
local IDX
local TOOLS_FILE="$IAM_HOME/local_tools"
local TOOLS_URL="https://raw.githubusercontent.com/chpock/dotfiles/master/tools.list"
local UPDATE_IMPORTANT_BANNER="Updating important tools..."
local UPDATE_IMPORTANT_BANNEX="                           "
if [ "lock" = "$CMD" ]; then
_create_flag "$IAM_HOME/local_tools.locked"
echo "Tools are locked now."
return
fi
if [ "unlock" = "$CMD" ]; then
rm -f "$IAM_HOME/local_tools.locked"
echo "Tools are unlocked now."
return
fi
if [ "locked" = "$CMD" ]; then
[ -e "$IAM_HOME/local_tools.locked" ] && return 0 || return 1
fi
if [ "update" = "$CMD" ]; then
if tools locked; then
_warn 'Tools are locked now and will not be updated.'
return
fi
if ! _get_url -check; then
[ "$PARAM" = "important" ] || _err "Could not update tools: curl/wget command not found"
return 1
fi
if [ "$PARAM" = "background" ]; then
tools update background-real >/dev/null 2>&1 &
disown $!
return
fi
fi
local recs=() TOOLS_EXISTS=
local files_by_size=() checks_by_size=()
local files_by_hash=() checks_by_hash=()
if [ -f "$TOOLS_FILE" ]; then
_hash_file "$TOOLS_FILE"
[ "$_HASH" != "$LOCAL_TOOLS_FILE_HASH" ] || TOOLS_EXISTS=1
fi
if [ -z "$TOOLS_EXISTS" ]; then
local TMP
TMP="$(mktemp)"
if [ "$PARAM" = "important" ]; then
printf '%s' "$UPDATE_IMPORTANT_BANNER"
unset UPDATE_IMPORTANT_BANNER
fi
if ! _get_url "$TOOLS_URL" >"$TMP" 2>/dev/null; then
rm -f "$TMP"
CHECK_STATE=1
[ "$PARAM" = "important" ] || _err "An unexpected error occurred while updating the list of tools."
else
_hash < "$TMP"
if [ "$_HASH" != "$LOCAL_TOOLS_FILE_HASH" ]; then
rm -f "$TMP"
[ "$PARAM" = "important" ] || _warn "The list of tools is not properly updated. The downloaded file hash %s doesn't match the expected hash %s." "$_HASH" "$LOCAL_TOOLS_FILE_HASH"
else
mv -f "$TMP" "$TOOLS_FILE"
TOOLS_EXISTS=1
fi
fi
fi
if [ -n "$TOOLS_EXISTS" ]; then
while IFS= read -r LINE || [ -n "$LINE" ]; do
if [ "${LINE:0:5}" = "tool:" ]; then
I_DESC="${LINE#*: }"
unset I_URL I_FILE I_SIZE I_HASH I_FILTER_IS I_FILTER_HAS I_IMPORTANT I_ON_UPDATE
elif [ -z "$I_URL" ]; then
I_URL="$LINE"
elif [ -z "$I_FILE" ]; then
printf -v LINE '%q' "$LINE"; # quote string
eval "I_FILE=\"${LINE//\\\$/\$}\""; # enable $VAR
elif [ -z "$I_SIZE" ]; then
local P1="${LINE%:*}"
if [ "$P1" = "$LINE" ]; then
[ "${LINE:0:1}" = "#" ] && I_HASH="${LINE:1}" || I_SIZE="$LINE"
else
if [ "$P1" = "is" ]; then
I_FILTER_IS="${LINE#*: }"
elif [ "$P1" = "has" ]; then
I_FILTER_HAS="${LINE#*: }"
elif [ "$P1" = "on update" ]; then
I_ON_UPDATE="${LINE#*: }"
elif [ "$P1" = "important" ]; then
I_IMPORTANT="${LINE#*: }"
I_IMPORTANT="${I_IMPORTANT,,}"
[ "$I_IMPORTANT" != "1" ] && [ "$I_IMPORTANT" != "yes" ] && [ "$I_IMPORTANT" != "true" ] && unset I_IMPORTANT || :
else
echo "ERROR: unexpected line in tools list: $LINE"
fi
fi
else
echo "ERROR: unexpected line in tools list: $LINE"
fi
[ -n "$I_SIZE$I_HASH" ] || continue
[ "$PARAM" = "important" ] && [ -z "$I_IMPORTANT" ] && continue || :
[ -n "$I_FILTER_IS" ] && ! _is "$I_FILTER_IS" && continue || :
[ -n "$I_FILTER_HAS" ] && ! _has "$I_FILTER_HAS" && continue || :
if [ -e "$I_FILE" ]; then
if [ -n "$I_SIZE" ]; then
files_by_size+=("$I_FILE")
checks_by_size+=("$I_DESC" "$I_URL" "$I_FILE" "$I_ON_UPDATE" "$I_SIZE" "$I_HASH")
else
files_by_hash+=("$I_FILE")
checks_by_hash+=("$I_DESC" "$I_URL" "$I_FILE" "$I_ON_UPDATE" "$I_SIZE" "$I_HASH")
fi
else
recs+=("$I_DESC" "$I_URL" "$I_FILE" "$I_ON_UPDATE" "$I_SIZE" "$I_HASH" 0 0)
fi
unset I_DESC I_URL I_FILE I_SIZE I_HASH I_FILTER_IS I_FILTER_HAS I_ON_UPDATE
done < "$TOOLS_FILE"
fi
if [ "${#files_by_size[@]}" -gt 0 ]; then
IDX=0
while read -r SIZE; do
recs+=("${checks_by_size[@]:$(( 6 * IDX++)):6}" "$SIZE" 0)
done < <(_get_size "${files_by_size[@]}")
fi
if [ "${#files_by_hash[@]}" -gt 0 ]; then
IDX=0
while read -r HASH; do
recs+=("${checks_by_hash[@]:$(( 6 * IDX++)):6}" 0 "$HASH")
done < <(_get_hash "${files_by_hash[@]}")
fi
IDX=0
while [ $IDX -lt ${#recs[@]} ]; do
I_DESC="${recs[IDX++]}"
I_URL="${recs[IDX++]}"
I_FILE="${recs[IDX++]}"
I_ON_UPDATE="${recs[IDX++]}"
I_SIZE="${recs[IDX++]}"
I_HASH="${recs[IDX++]}"
SIZE="${recs[IDX++]}"
HASH="${recs[IDX++]}"
if [ "check" = "$CMD" ]; then
if [ "$SIZE$HASH" = "00" ]; then
LINE="~R~NOT FOUND"
SIZE="undef"
HASH="undef"
[ -n "$CHECK_STATE" ] || CHECK_STATE=1
else
if [ -n "$I_HASH" ] && [ "$I_HASH" != "$HASH" ]; then
LINE="~y~OUTDATED "
CHECK_STATE=2
elif [ -n "$I_SIZE" ] && [ "$I_SIZE" -ne "$SIZE" ]; then
LINE="~y~OUTDATED "
CHECK_STATE=2
else
LINE="~g~OK       "
fi
fi
if [ "quick" != "$PARAM" ]; then
if [ -n "$I_SIZE" ]; then
cprintf "$LINE ~K~[~d~Size current: %8s ~K~/~d~ expected: %8s~K~]~d~ %s" "$SIZE" "$I_SIZE" "${I_FILE/$HOME/\~}"
else
cprintf "$LINE ~K~[~d~Hash current: %8s ~K~/~d~ expected: %8s~K~]~d~ %s" "$HASH" "$I_HASH" "${I_FILE/$HOME/\~}"
fi
fi
elif [ "update" = "$CMD" ]; then
if [ "$PARAM" != "force" ]; then
[ -n "$I_HASH" ] && [ "$HASH" = "$I_HASH" ] && continue || true
[ -n "$I_SIZE" ] && [ "$SIZE" -eq "$I_SIZE" ] && continue || true
fi
IS_ERROR=0
mkdir -p "${I_FILE%/*}"
local TMP
TMP="$(mktemp)"
if [ "$PARAM" = "important" ]; then
if [ -n "$UPDATE_IMPORTANT_BANNER" ]; then
printf '%s' "$UPDATE_IMPORTANT_BANNER"
unset UPDATE_IMPORTANT_BANNER
fi
_get_url "$I_URL" >"$TMP" 2>/dev/null || IS_ERROR=$?
else
printf "Download: %s '%s'..." "$I_DESC" "${I_FILE##*/}"
_get_url "$I_URL" >"$TMP" || IS_ERROR=$?
if [ "$IS_ERROR" -ne 0 ]; then
cprintf " ~R~ERROR"
else
cprintf " ~g~OK"
fi
fi
if [ "$IS_ERROR" -ne 0 ]; then
rm -f "$TMP"
else
mv -f "$TMP" "$I_FILE"
[ -n "${I_FILE##*/bin/*}" ] || chmod +x "$I_FILE"
[ -z "$I_ON_UPDATE" ] || eval "$I_ON_UPDATE"
fi
fi
done
if [ "check" = "$CMD" ] && [ "quick" = "$PARAM" ] && [ -n "$CHECK_STATE" ]; then
if [ "$PARAM_EX" = "update" ]; then
if [ "$CHECK_STATE" -eq 1 ]; then
cprintf "~y~Some or all local tools are not exist and will be updated in background.\n"
elif [ "$CHECK_STATE" -eq 2 ]; then
cprintf "~y~Some or all local tools are outdated and will be updated in background.\n"
fi
tools update background
else
if [ "$CHECK_STATE" -eq 1 ]; then
cprintf "~r~Some or all local tools are not exist. Run the 'tools update' command.\n"
elif [ "$CHECK_STATE" -eq 2 ]; then
cprintf "~y~Some or all local tools are outdated. Run the 'tools update' command.\n"
fi
fi
elif [ "update" = "$CMD" ] && [ "important" = "$PARAM" ] && [ -z "$UPDATE_IMPORTANT_BANNER" ]; then
printf '\r%s\r' "$UPDATE_IMPORTANT_BANNEX"
fi
}
complete -W "check update lock unlock" tools
tools update important
for SCRIPT in "$IAM_HOME"/shell.rc/*; do
[ -e "$SCRIPT" ] || continue
! _once "PS1 -> source $SCRIPT" || source "$SCRIPT"
done
unset SCRIPT
if _has tmux; then
[ ! -n "$__TMUX_FUNCTIONS_AVAILABLE" ] || _tmux_generate_conf
TMUX_TMPDIR="$IAM_HOME/session/tmux"
export TMUX_TMPDIR
[ -e "$TMUX_TMPDIR" ] || mkdir -p "$TMUX_TMPDIR"
if _is tmux; then
if [ -n "$_TMUX_SESSION_ID" ]; then
_unexport _TMUX_SESSION_ID
else
_random -v _TMUX_SESSION_ID
command tmux set-env _TMUX_SESSION_ID "$_TMUX_SESSION_ID"
fi
_TMUX_SESSION_DIR="$TMUX_TMPDIR/id-$_TMUX_SESSION_ID"
mkdir -p "$_TMUX_SESSION_DIR"
[ -e "$_TMUX_SESSION_DIR/sid" ] || command tmux display-message -p '#{session_id}' > "$_TMUX_SESSION_DIR/sid"
if _TMUX_WINDOW_ID="$(command tmux show -w -t "$TMUX_PANE" -v '@persistent-id' 2>/dev/null)" && [ -n "$_TMUX_WINDOW_ID" ]; then
: no-op
elif [ -e "$_TMUX_SESSION_DIR/mode-restore" ]; then
while ! _TMUX_WINDOW_ID="$(command tmux show -w -t "$TMUX_PANE" -v '@persistent-id' 2>/dev/null)" || [ -z "$_TMUX_WINDOW_ID" ]; do
sleep 1
done
else
_random -v _TMUX_WINDOW_ID
command tmux set -w -t "$TMUX_PANE" '@persistent-id' "$_TMUX_WINDOW_ID"
fi
_TMUX_WINDOW_DIR="$_TMUX_SESSION_DIR/wid-$_TMUX_WINDOW_ID"
mkdir -p "$_TMUX_WINDOW_DIR"
_TMUX_WINDOW_DUMP_FILE="$_TMUX_WINDOW_DIR/dump"
if ! _TMUX_WINDOW_IS_NEW="$(command tmux show -w -t "$TMUX_PANE" -v '@is-new' 2>/dev/null)" || [ -z "$_TMUX_WINDOW_IS_NEW" ]; then
[ ! -e "$_TMUX_WINDOW_DUMP_FILE" ] \
|| awk 'NF{last=NR} {lines[NR]=$0} END{for(i=1;i<=last;i++)print lines[i]}' "$_TMUX_WINDOW_DUMP_FILE"
command tmux set -w -t "$TMUX_PANE" '@is-new' "no"
fi
fi
if _isnot tmux; then
tmux() {
local _TMUX_SESSION_ID
local TMUX_CONFIG="$IAM_HOME/tmux.conf"
if [ -z "$1" ]; then
local _TMUX_SESSION_ID TMUX_SESSION
if ! TMUX_SESSION="$(
export SSH_PUB_KEY _GIT_USER_EMAIL _GIT_USER_NAME
command tmux -f "$TMUX_CONFIG" new-session -d -P -F '#{session_id}'
)"
then
_err 'failed to create a new tmux session: %s' "$TMUX_SESSION"
return 1
fi
local COUNT=1 MAX_COUNT=10
while ! _TMUX_SESSION_ID="$(command tmux show-env -t "$TMUX_SESSION" _TMUX_SESSION_ID 2>/dev/null)" || [ -z "$_TMUX_SESSION_ID" ]; do
echo "[$COUNT/$MAX_COUNT] wait for the new tmux session to set its _TMUX_SESSION_ID"
sleep 1
done
_TMUX_SESSION_ID="${_TMUX_SESSION_ID#*=}"
set -- attach-session -t "$TMUX_SESSION"
fi
if [ "$1" = "attach-session" ] || [ "$1" = "attach" ]; then
if [ -n "$_TERM_SESSION_DIR" ]; then
if [ -z "$_TMUX_SESSION_ID" ]; then
local ARG PREV_ARG
for ARG; do
if [ "$PREV_ARG" != "-t" ]; then
PREV_ARG="$ARG"
continue
fi
if ! _TMUX_SESSION_ID="$(command tmux show-env -t "$ARG" _TMUX_SESSION_ID 2>/dev/null)"; then
unset _TMUX_SESSION_ID
else
_TMUX_SESSION_ID="${_TMUX_SESSION_ID#*=}"
fi
break
done
fi
if [ -n "$_TMUX_SESSION_ID" ]; then
echo "$_TMUX_SESSION_ID" > "$_TERM_SESSION_DIR/tmux_session_id"
fi
fi
exec tmux -f "$TMUX_CONFIG" "$@"
fi
command tmux -f "$TMUX_CONFIG" "$@"
}
[ -z "$__TMUX_FUNCTIONS_AVAILABLE" ] || ,tmux restore
if [ -n "$_TERM_SESSION_DIR" ] && [ -e "$_TERM_SESSION_DIR/tmux_session_id" ]; then
_TMUX_SESSION_ID="$(< "$_TERM_SESSION_DIR/tmux_session_id")"
_TMUX_SESSION_DIR="$TMUX_TMPDIR/id-$_TMUX_SESSION_ID"
if [ ! -e "$_TMUX_SESSION_DIR/sid" ]; then
_warn "this terminal session is associated with tmux session '%s', but its sid file does not exist: %s" \
"$_TMUX_SESSION_ID" "$_TMUX_SESSION_DIR/sid"
else
TMUX_SESSION="$(< "$_TMUX_SESSION_DIR/sid")"
if ! command tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
_warn "this terminal session is associated with tmux session '%s' (%s), but currently tmux doesn't have such a session" \
"$_TMUX_SESSION_ID" "$TMUX_SESSION"
else
exec tmux attach-session -t "$TMUX_SESSION"
fi
unset TMUX_SESSION
fi
unset _TMUX_SESSION_ID _TMUX_SESSION_DIR
else
if [ -z "$_MAGIC_TMUX" ] && command tmux list-sessions -F '#{session_attached} #{session_name}' 2>/dev/null | grep --silent '^0 default$'; then
_MAGIC_TMUX="default"
fi
if [ -n "$_MAGIC_TMUX" ]; then
if [ -n "$_TERM_SESSION_DIR" ] && _TMUX_SESSION_ID="$(command tmux show-env -t "$_MAGIC_TMUX" _TMUX_SESSION_ID 2>/dev/null)" && [ -n "$_TMUX_SESSION_ID" ]; then
_TMUX_SESSION_ID="${_TMUX_SESSION_ID#*=}"
echo "$_TMUX_SESSION_ID" > "$_TERM_SESSION_DIR/tmux_session_id"
fi
exec tmux attach-session -t "$_MAGIC_TMUX"
fi
fi
else
alias tmux="tmux -f \"\$IAM_HOME/tmux.conf\""
fi
fi; # tmux
__magic_ssh() {
{
printf '%s\n' \
"IAM=\"$IAM\" && export IAM" \
"[ -n \"\$HOME\" ] || { HOME=\"/tmp\"; export HOME; }" \
"IAM_HOME=\"\$HOME/.${IAM}_home\" && export IAM_HOME" \
"SSH_PUB_KEY=\"$SSH_PUB_KEY\" && export SSH_PUB_KEY" \
"_GIT_USER_NAME=\"$_GIT_USER_NAME\" && export _GIT_USER_NAME" \
"_GIT_USER_EMAIL=\"$_GIT_USER_EMAIL\" && export _GIT_USER_EMAIL" \
"[ -d \"\$IAM_HOME/terminfo\" ] || mkdir -p \"\$IAM_HOME/terminfo\"" \
"cat >\"\$IAM_HOME/terminfo/.terminfo\" <<'EOF'" "$(cat "$IAM_HOME/terminfo/.terminfo")" "EOF" \
"if [ \"\$TERM\" = 'xterm' ]; then TERM='xterm-256color'; export TERM; fi" \
"if [ \"\$TERM\" = 'xterm-256color' -o \"\$TERM\" = 'tmux-256color' ] && command -v tic >/dev/null 2>&1; then" \
"TERMINFO=\"\$IAM_HOME/terminfo\"" \
"export TERMINFO" \
"tic \"\$IAM_HOME/terminfo/.terminfo\" >/dev/null 2>&1 || true" \
"fi" \
"cat >\"\$IAM_HOME/vimrc\" <<'EOF'" "$(cat "$IAM_HOME/vimrc")" "EOF" \
"cat >\"\$IAM_HOME/bashrc\" <<'EOF'" "$(cat "$IAM_HOME/bashrc")" "EOF" \
"cat >\"\$IAM_HOME/shellrc\" <<'EOF'" "$(cat "$IAM_HOME/shellrc")" "EOF" \
"cat >\"\$IAM_HOME/local_tools\" <<'EOF'" "$(cat "$IAM_HOME/local_tools" 2>/dev/null || :)" "EOF" \
"cat >\"\$HOME/.tclshrc\" <<'EOF'" "$(cat "$HOME/.tclshrc")" "EOF" \
"chmod +x \"\$IAM_HOME/shellrc\"" \
"exec \"\$IAM_HOME/shellrc\""
} 2>/dev/null
}
,ssh() {
local ARG
for ARG in "$@"; do :; done
if ! _glob_match "*@*" "$ARG"; then
local SSH_USER
SSH_USER="$(ssh -G "$ARG" 2>/dev/null | grep -i '^user ' | awk '{print $2}')"
if [ -z "$SSH_USER" ] || [ "$SSH_USER" = "$USER" ]; then
_warn "the remote user is not provided. Current user '%s' will be used on the remove machine." "$USER"
fi
fi
set -- -t "$@" "$(__magic_ssh)"
if _has autossh; then
set -- autossh -M0 "$@"
else
_warn "autossh is not available, using plain ssh"
set -- ssh "$@"
fi
[ -z "$_MAGIC_SSH" ] || set -- exec "$@"
"$@"
}
if [ -n "$_MAGIC_SSH" ]; then
,ssh "$_MAGIC_SSH"
fi
if [ -z "$_SHELL_SESSION_ID" ]; then
if [ -n "$_TMUX_WINDOW_DIR" ] && [ -r "$_TMUX_WINDOW_DIR/shell_session_id" ]; then
_SHELL_SESSION_ID="$(< "$_TMUX_WINDOW_DIR/shell_session_id")"
elif [ -n "$_TERM_SESSION_DIR" ] && [ -r "$_TERM_SESSION_DIR/shell_session_id" ]; then
_SHELL_SESSION_ID="$(< "$_TERM_SESSION_DIR/shell_session_id")"
else
_random -v _SHELL_SESSION_ID
fi
else
_unexport _SHELL_SESSION_ID
fi
_SHELL_SESSION_DIR="$IAM_HOME/session/shell/id-$_SHELL_SESSION_ID"
mkdir -p "$_SHELL_SESSION_DIR"
if [ -n "$_TMUX_WINDOW_DIR" ]; then
echo "$_SHELL_SESSION_ID" > "$_TMUX_WINDOW_DIR/shell_session_id"
elif [ -n "$_TERM_SESSION_DIR" ]; then
echo "$_SHELL_SESSION_ID" > "$_TERM_SESSION_DIR/shell_session_id"
fi
_SHELL_SESSION_STAMP="$_SHELL_SESSION_DIR/stamp"
echo > "$_SHELL_SESSION_STAMP"
_isnot "aws" || _aws_metadata() {
local METADATA_URL="http://169.254.169.254/latest"
if [ -z "$_AWS_METADATA_ACCESS_TYPE" ]; then
local STATUS_CODE
STATUS_CODE="$(command curl -s -f --connect-timeout 0.1 -o /dev/null -I -w "%{http_code}" "$METADATA_URL/meta-data/instance-id")"
if [ "$STATUS_CODE" = "200" ]; then
_AWS_METADATA_ACCESS_TYPE="plain"
elif [ "$STATUS_CODE" = "401" ]; then
_AWS_METADATA_ACCESS_TYPE="token"
else
_AWS_METADATA_ACCESS_TYPE="no"
fi
fi
[ "$_AWS_METADATA_ACCESS_TYPE" != "no" ] || return 1
set -- command curl -s -f --connect-timeout 1 "$METADATA_URL/meta-data/$1"
if [ "$_AWS_METADATA_ACCESS_TYPE" = "token" ]; then
[ "$_AWS_METADATA_TOKEN" != "error" ] || return 1
local CURRENT_TIMESTAMP DURATION_HOURS_LEFT=0
CURRENT_TIMESTAMP="$(date +%s)"
[ -z "$_AWS_METADATA_TOKEN_TIMESTAMP" ] || DURATION_HOURS_LEFT=$(( ( 21600 + _AWS_METADATA_TOKEN_TIMESTAMP - CURRENT_TIMESTAMP ) / 3600 ))
if [ "$DURATION_HOURS_LEFT" -le 0 ]; then
if ! _AWS_METADATA_TOKEN="$(command curl -s -f --connect-timeout 1 -X PUT \
-H "X-aws-ec2-metadata-token-ttl-seconds: 21600" \
"$METADATA_URL/api/token")" || [ -z "$_AWS_METADATA_TOKEN" ]
then
_AWS_METADATA_TOKEN="error"
return 1
fi
_AWS_METADATA_TOKEN_TIMESTAMP="$CURRENT_TIMESTAMP"
fi
set -- "$@" -H "X-aws-ec2-metadata-token: $_AWS_METADATA_TOKEN"
fi
"$@"
}
hostinfo() {
local UNAME_MACHINE UNAME_RELEASE UNAME_ALL
local MSHELL="unknown"
! _glob_match "*.*" "$BASH_VERSION" || MSHELL="bash $BASH_VERSION"
! _glob_match "*.*" "$ZSH_VERSION" || MSHELL="zsh $ZSH_VERSION"
! _glob_match "*zsh*" "$VERSION" || MSHELL="$VERSION"
! _glob_match "*PD*" "$SH_VERSION" || MSHELL="$SH_VERSION"
! _glob_match "*MIRBSD*" "$KSH_VERSION" || MSHELL="$KSH_VERSION"
! _glob_match "*.*|*POSH*" "$POSH_VERSION" || MSHELL="posh $POSH_VERSION"
! _glob_match "*.*" "$YASH_VERSION" || MSHELL="yash $YASH_VERSION"
_cache __uname_machine
UNAME_MACHINE="$_CACHE"
_cache __uname_kernel_release
UNAME_RELEASE="$_CACHE"
_cache __uname_all
UNAME_ALL="$_CACHE"
sep() {
local WIDTH=79
[ -z "$1" ] || WIDTH=$(( WIDTH - ${#1} - 6 ))
local BAR
printf -v BAR "%${WIDTH}s"
BAR="${BAR// /-}"
cprintf -v BAR '~K~%s' "$BAR"
[ -z "$1" ] || cprintf -a BAR '~K~[ ~d~%s ~K~]--' "$1"
echo "$BAR"
}
if _is linux; then
if [ -f /etc/redhat-release ]; then
UNAME_RELEASE="$(cat /etc/redhat-release)"
elif [ -f /etc/alpine-release ] || [ -f /etc/arch-release ]; then
UNAME_RELEASE="$(grep 'PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')"
elif [ -f /etc/SuSE-release ]; then
UNAME_RELEASE="SUSE Linux Enterprise Server $(grep VERSION /etc/SuSE-release | cut -d= -f2 | awk '{print $1}') SP$(grep PATCHLEVEL /etc/SuSE-release | cut -d= -f2 | awk '{print $1}')"
elif [ -f /etc/lsb-release ]; then
UNAME_RELEASE="$(grep DISTRIB_DESCRIPTION= /etc/lsb-release | sed 's/DISTRIB_DESCRIPTION\s*=\s*"//' | sed 's/""*$//')"
elif [ -f /etc/debian_version ]; then
UNAME_RELEASE="Debian $(cat /etc/debian_version)"
elif [ -e /etc/amazon-linux-release ]; then
UNAME_RELEASE="$(cat /etc/amazon-linux-release)"
elif [ -f /usr/lib/system-release ]; then
UNAME_RELEASE="$(cat /usr/lib/system-release)"
elif [ -f /etc/system-release ]; then
UNAME_RELEASE="$(cat /etc/system-release)"
else
UNAME_RELEASE="Linux, unknown distribution"
fi
case "$UNAME_MACHINE" in
x86_64) UNAME_MACHINE="Intel x86-64" ;;
i386)   UNAME_MACHINE="Intel x86" ;;
esac
elif _is aix; then
UNAME_MACHINE="$(lsattr -El proc0 -a type | cut -d ' ' -f 2) ($(prtconf -c); $(prtconf -k))"
UNAME_RELEASE="AIX v$(oslevel)"
elif _is macos; then
UNAME_RELEASE="$(sw_vers -productName) $(sw_vers -productVersion)"
case "$UNAME_MACHINE" in
i386)   UNAME_MACHINE="Intel x86";;
x86-64) UNAME_MACHINE="Intel x86-64";;
ppc)    UNAME_MACHINE="PowerPC";;
ppc64)  UNAME_MACHINE="PowerPC-64";;
esac
UNAME_MACHINE="$UNAME_MACHINE (Kernel Type: $(getconf LONG_BIT)-bit)"
elif _is cygwin; then
UNAME_RELEASE="$(/usr/lib/csih/winProductName.exe)"
case "$UNAME_MACHINE" in
x86_64) UNAME_MACHINE="Intel x86-64" ;;
i386)   UNAME_MACHINE="Intel x86" ;;
esac
elif _is mingw || _is msys; then
UNAME_RELEASE="$(cmd /c "ver" | tr -d '\n\r')"
case "$UNAME_MACHINE" in
x86_64) UNAME_MACHINE="Intel x86-64" ;;
i386)   UNAME_MACHINE="Intel x86" ;;
esac
elif _is hpux; then
UNAME_MACHINE="$(model | sed -e 's/[[:space:]]*$//') (CPU Type: $(getconf HW_CPU_SUPP_BITS)-bit; Kernel Type: $(getconf KERNEL_BITS)-bit)"
UNAME_RELEASE="HP-UX $UNAME_RELEASE"
elif _is sunos; then
UNAME_RELEASE="$(head -n 1 /etc/release | sed 's/^ *//')"
TMPARCH="$(isainfo -kv | cut -d ' ' -f 2)"
case "$TMPARCH" in
i386)   UNAME_MACHINE="Intel x86";;
amd64)  UNAME_MACHINE="Intel x86-64";;
sparc*) UNAME_MACHINE="SPARC ${TMPARCH:5}";;
esac
unset TMPARCH
UNAME_MACHINE="$UNAME_MACHINE (Kernel Type: $(isainfo -b)-bit)"
fi
sep
printf -- "Hostname  : %s\n" "$HOSTNAME"
printf -- "Kernel    : %s\n" "$UNAME_ALL"
printf -- "Machine   : %s\n" "$UNAME_MACHINE"
cprintf -- "Release   : ~c~%s" "$UNAME_RELEASE"
if _is need_proxy; then
cprintf -- "Proxy     : ~R~%s" "Enabled"
fi
sep "OS"
if ! _is in-container && ! _is sudo; then
if _is linux || _is macos || _is sunos; then
if [ -e /sbin/ifconfig ]; then
int2ip() {
printf "%d.%d.%d.%d" $(($1>>24)) $(($1>>16&255)) $(($1>>8&255)) $(($1&255))
}
ip2int() {
_a=(${1//./ })
printf "%u" $(( _a<<24 | _a[1] << 16 | _a[2] << 8 | _a[3] ))
}
runOnMac=0
while IFS=$' :\t\r\n' read -r a b c d; do
[ "$a" = "usage" ] && [ "$b" = "route" ] && runOnMac=1
if [ "$runOnMac" = "1" ]; then
case $a in
gateway )    gWay="$b"  ;;
esac
else
[ "$a" = "0.0.0.0" ] && [ "$c" = "$a" ] && gWay="$b"
fi
done < <(/sbin/route -n 2>&1 || /sbin/route -n get 0.0.0.0/0 2>&1 || true)
[ -z "$gWay" ] && gw=0 || gw=$(ip2int "$gWay")
while read -r lhs rhs; do
[ "$lhs" ] && {
[ "$lhs" != "inet" ] && [ "$lhs" != "inet6" ] && iface="$lhs"
[ -z "${lhs#*:}" ] && iface=${lhs%:}
[ "$lhs" = "inet" ] && {
mask=${rhs#*netmask }
mask=${mask#*Mask:}
mask=${mask%% *}
case "$mask" in
0x*) mask="$(printf '%u' "$mask")"; ;;
f*)  mask="$(printf '%u' "0x$mask")"; ;;
*)   mask="$(ip2int "$mask")"; ;;
esac
myIp=${rhs%% *}
myIp=${myIp#*addr:}
ip=$(ip2int "$myIp")
netMask=$(int2ip "$mask")
(( ( ip & mask ) == ( gw & mask ) )) && myGway=", gw: $gWay" || myGway=
[ "$myIp" != "127.0.0.1" ] && \
printf -- "Interface : %s (name: '%s', mask: %s%s)\n" "$myIp" "$iface" "$netMask" "$myGway"
}
}
done < <(/sbin/ifconfig 2>&1 || /sbin/ifconfig -a)
sep "Network"
fi
fi
fi
if ! _is in-container && ! _is sudo && _is aws_metadata_available; then
printf -- "Instance  : %s (%s)\n" "$(_aws_metadata instance-type)" "$(_aws_metadata instance-id)"
printf -- "Region    : %s (%s)\n" "$(_aws_metadata placement/region)" "$(_aws_metadata placement/availability-zone)"
sep "Cloud: AWS"
fi
_showfeature() {
local line
local width=15
for f in "$@"; do
local color
local feature="${f%:*}"
local state="${f#*:}"
if [ "$state" != "1" ] && [ "$state" != "0" ]; then
if _has_executable "$state"; then
_has_local "$state" && state=2 || state=0
else
_has_potentially "$state" && state=3 || state=1
fi
fi
case "$state" in
0) color="~g~" ;;
1) color="~d~" ;;
2) color="~G~" ;;
3) color="~b~" ;;
*) color="~r~" ;;
esac
cprintf -A line "~K~[${color} %-${width}s~K~ ]" "$feature"
done
echo "$line"
}
_showinfo() {
local infoType="$1"
local total="$2"
local free="$3"
local add="$4"
local add2="$5"
local prc=$(( 100 - 100 * (total - free) / total ))
local color
if [ $prc -gt 19 ]; then
color="~g~"
elif [ $prc -gt 9 ]; then
color="~Y~"
else
color="~R~"
fi
local bar=$(( prc / 4 ))
printf -v bar "%${bar}s"
bar="${bar// /=}"
if [ "$prc" != '100' ]; then
printf -v prc '%02d' "$prc"
fi
local units="MB"
if [ "$total" -gt 1022976 ]; then
total="$(( 100 * total / 1024 / 1024 ))e-2"
free="$(( 100 * free / 1024 / 1024 ))e-2"
units="TB"
elif [ "$total" -gt 999 ]; then
total="$(( 100 * total / 1024 ))e-2"
free="$(( 100 * free / 1024 ))e-2"
units="GB"
else
total="$(( 100 * total ))e-2"
free="$(( 100 * free ))e-2"
fi
printf -v total '%.2f %s' "$total" "$units"
printf -v free '%.2f %s' "$free" "$units"
local msg
cprintf -v msg "%-9s : Free ${color}%9s~d~ of %9s ~K~[~b~%-25s~K~] ${color}%3s%%" "$infoType" "$free" "$total" "$bar" "$prc"
if [ -n "$add" ]; then
cprintf -A msg '~W~%s' "$add"
fi
if [ -n "$add2" ]; then
cprintf -A msg '~K~%s' "$add2"
fi
echo "$msg"
}
if ! _is in-container && ! _is sudo; then
local MEM_TOTAL="" MEM_FREE SWAP_TOTAL SWAP_FREE
if [ -f /proc/meminfo ]; then
local _buffers=0 _cached=0 _memTotal _memFree _swapTotal _swapFree
while IFS=$' :\t\r\n' read -r a b c; do
case "$a" in
MemTotal)  _memTotal="$b";;
MemFree)   _memFree="$b";;
Buffers)   _buffers="$b";;
Cached)    _cached="$b";;
SwapTotal) _swapTotal="$b";;
SwapFree)  _swapFree="$b";;
EOF
cat <<'EOF' >> "$IAM_HOME/bashrc"
esac
done < /proc/meminfo
MEM_TOTAL=$(( _memTotal / 1024 ))
MEM_FREE=$(( (_memFree + _buffers + _cached) / 1024 ))
SWAP_TOTAL=$(( _swapTotal / 1024 ))
SWAP_FREE=$(( _swapFree / 1024 ))
elif _has vm_stat; then
read -r SWAP_TOTAL SWAP_FREE <<< "$(sysctl vm.swapusage | awk '{ print $4 "\n" $10 }')"
SWAP_TOTAL="${SWAP_TOTAL%%.*}"
SWAP_FREE="${SWAP_FREE%%.*}"
MEM_TOTAL=$(sysctl hw.memsize | awk '{ print $NF }')
MEM_TOTAL=$(( MEM_TOTAL / 1024 / 1024 ))
MEM_FREE=0
while IFS=$':\r\n' read -r a b; do
if [ "$a" = "Pages free" ] || [ "$a" = "Pages inactive" ] || [ "$a" = "Pages speculative" ]; then
b="${b// /}"
b="${b//./}"
MEM_FREE=$(( MEM_FREE + b ))
fi
done < <(vm_stat)
MEM_FREE=$(( MEM_FREE * 4096 / 1024 / 1024 ))
fi
if [ -n "$MEM_TOTAL" ]; then
_showinfo "RAM" "$MEM_TOTAL" "$MEM_FREE"
if [ "$SWAP_TOTAL" -eq 0 ]; then
cprintf -- "Swap      : ~y~%s" "Not installed"
else
_showinfo "Swap" "$SWAP_TOTAL" "$SWAP_FREE"
fi
sep "Memory"
fi
fi
if ! _is in-container && ! _is sudo; then
if _is linux; then
while IFS=$' \t\r\n' read -r a b c d _ f; do
[ "$f" = "/dev/shm" ] && continue
[ "$f" = "/dev" ]     && continue
[ "$f" = "/run" ]     && continue
[ "$f" = "/boot" ]    && continue
[ "${f:0:5}" = "/sys/" ] && continue
[ "${f:0:5}" = "/run/" ] && continue
[ "${f:0:6}" = "/boot/" ] && continue
[ "${f:0:6}" = "/snap/" ] && continue
[ "$f" = "/usr/lib/modules" ]         && continue
[ "${f:0:17}" = "/usr/lib/modules/" ] && continue
if _is wsl; then
[ "$f" = "/init" ]                && continue
[ "$f" = "/wslg" ]                && continue
[ "$f" = "/wsl" ]                 && continue
[ "${f:0:6}" = "/wslg/" ]         && continue
[ "${f:0:13}" = "/usr/lib/wsl/" ] && continue
fi
if [ "$a" = "${a%:*}" ]; then
unset a
else
a="(nfs: $a)"
fi
_showinfo "Mount" "$b" "$d" "$f" "$a"
done < <(df -m -P 2>/dev/null | tail -n +2 | grep -v '^/dev/loop')
elif _is macos; then
while IFS=$' \t\r\n' read -r a b c d _ f _ _ i; do
_check df --version || f="$i"
_showinfo "Mount" "$b" "$d" "$f"
done < <(df -m 2>/dev/null | tail -n +2 | grep -v -E ' +0 +0 +0 +100%')
elif _is sunos; then
while IFS=$' \t\r\n' read -r a b c d _ f; do
[ "$f" = "/var/run" ] && continue
[ "$f" = "/etc/svc/volatile" ] && continue
[ "$f" = "/lib/libc.so.1" ]  && continue
b=$(( b / 1024 ))
d=$(( d / 1024 ))
_showinfo "Mount" "$b" "$d" "$f"
done < <(df -k -t | tail -n +2 | grep -v -E ' +0 +0 +0 +0%')
elif _is hpux; then
while IFS=$' \t\r\n' read -r a b c d _ f; do
b=$(( b / 1024 ))
d=$(( d / 1024 ))
_showinfo "Mount" "$b" "$d" "$f"
done < <(df -P -k | tail -n +2)
elif _is aix; then
while IFS=$' \t\r\n' read -r a b c d _ f; do
_showinfo "Mount" "$b" "$d" "$f"
done < <(df -m -P | tail -n +2 | grep -v -E ' +- +- +0 +-')
elif _is windows; then
while IFS=$' ,\t\r\n' read -r a b c d; do
[ -z "$c" ] && continue
b=$(( b / 1024 / 1024 ))
c=$(( c / 1024 / 1024 ))
_showinfo "Mount" "$c" "$b" "$a"
done < <(wmic logicaldisk get Caption,FreeSpace,Size | tail -n +2)
fi
unset a b c d e f g h i
sep "Filesystem"
fi
printf -- "Username  : %s\n" "$(id --user --name 2>/dev/null || id -u -n)"
printf -- "Shell     : %s\n" "$MSHELL"
sep "User"
local DOCKER_COMPOSE_V2=1
if _has docker && [ -x "/usr/libexec/docker/cli-plugins/docker-compose" ]; then
DOCKER_COMPOSE_V2=0
fi
_showfeature "AWS CLI:aws" "localstack" "gcloud CLI:gcloud"
_showfeature "docker" "docker-comp.V1:docker-compose" "docker-comp.V2:$DOCKER_COMPOSE_V2"
_showfeature "kubectl" "eksctl" "OpenShift CLI:oc"
_showfeature "vim" "git" "curl" "wget"
_showfeature "gpg" "tmux"
if _has sudo; then
local SUDO_STATUS SUDO_AVAIL=1 SUDO_NOPASS=1
if SUDO_STATUS="$(printf '' | LC_ALL=C sudo -l -S 2>&1)"; then
! _glob_match "* may run *" "$SUDO_STATUS" || SUDO_AVAIL=0
! _glob_match "* NOPASSWD: ALL*" "$SUDO_STATUS" || SUDO_NOPASS=0
fi
_showfeature \
"sudo avail:$SUDO_AVAIL" \
"sudo nopass:$SUDO_NOPASS"
fi
sep "Features"
}
_is tmux || hostinfo
if [ -f /etc/bash_completion ]; then
. /etc/bash_completion
elif [ -f /etc/profile.d/bash_completion.sh ]; then
. /etc/profile.d/bash_completion.sh
elif [ -f /usr/share/bash-completion/bash_completion ]; then
. /usr/share/bash-completion/bash_completion
elif [ -f /usr/local/etc/bash_completion ]; then
. /usr/local/etc/bash_completion
fi
mkdir -p "$IAM_HOME/tools/bash_completion"
if _has_function _init_completion; then
if _has kubectl && [ ! -f "$IAM_HOME/tools/bash_completion/kubectl.completion.bash" ]; then
_info "Generating bash completions for kubectl..."
kubectl completion bash >"$IAM_HOME/tools/bash_completion/kubectl.completion.bash" 2>/dev/null
fi
if _has eksctl && [ ! -f "$IAM_HOME/tools/bash_completion/eksctl.completion.bash" ]; then
_info "Generating bash completions for eksctl..."
eksctl completion bash >"$IAM_HOME/tools/bash_completion/eksctl.completion.bash" 2>/dev/null
fi
if _has helm && [ ! -f "$IAM_HOME/tools/bash_completion/helm.completion.bash" ]; then
_info "Generating bash completions for helm..."
helm completion bash >"$IAM_HOME/tools/bash_completion/helm.completion.bash" 2>/dev/null
fi
if _has oc && [ ! -f "$IAM_HOME/tools/bash_completion/oc.completion.bash" ]; then
_info "Generating bash completions for OpenShift..."
oc completion bash >"$IAM_HOME/tools/bash_completion/oc.completion.bash" 2>/dev/null
fi
if _has istioctl && [ ! -f "$IAM_HOME/tools/bash_completion/istioctl.completion.bash" ]; then
_info "Generating bash completions for istioctl..."
istioctl completion bash >"$IAM_HOME/tools/bash_completion/istioctl.completion.bash" 2>/dev/null
fi
if _has bazel && [ ! -f "$IAM_HOME/tools/bash_completion/bazel.completion.bash" ]; then
_info "Generating bash completions for bazel..."
bazel help completion bash >"$IAM_HOME/tools/bash_completion/bazel.completion.bash" 2>/dev/null
fi
else
_warn 'The original bash completion package is not installed on this machine. Some of the completions may not be available.\n'
fi
if _has kpexec && [ ! -f "$IAM_HOME/tools/bash_completion/kpexec.completion.bash" ];  then
_info "Generating bash completions for kpexec..."
if kpexec --completion bash >"$IAM_HOME/tools/bash_completion/kpexec.completion.bash" 2>/dev/null; then
echo '
if [ $(type -t compopt) = "builtin" ]; then
complete -o default -F __start_kpexec ,kpexec
else
complete -o default -o nospace -F __start_kpexec ,kpexec
fi
' >>"$IAM_HOME/tools/bash_completion/kpexec.completion.bash"
fi
fi
if [ ! -f "$IAM_HOME/tools/bash_completion/pip.completion.bash" ]; then
if _has pip3; then
_info "Generating bash completions for pip3..."
pip3 completion --bash | tr -d '\r' >"$IAM_HOME/tools/bash_completion/pip.completion.bash" 2>/dev/null && \
echo 'complete -o default -F _pip_completion pip' >>"$IAM_HOME/tools/bash_completion/pip.completion.bash"
elif _has pip; then
_info "Generating bash completions for pip..."
pip completion --bash | tr -d '\r' >"$IAM_HOME/tools/bash_completion/pip.completion.bash" 2>/dev/null
fi
fi
if _has upkg && [ ! -f "$IAM_HOME/tools/bash_completion/upkg.bash" ] && upkg supported silent; then
_info "Generating bash completions for upkg..."
upkg generate bash-completion >"$IAM_HOME/tools/bash_completion/upkg.bash" 2>/dev/null
fi
for i in "$IAM_HOME/tools/bash_completion"/*.bash; do
source "$i"
done
unset i
if [ -f ~/gcloud/google-cloud-sdk/completion.bash.inc ]; then
. ~/gcloud/google-cloud-sdk/completion.bash.inc
elif [ -f /usr/lib/google-cloud-sdk/completion.bash.inc ]; then
. /usr/lib/google-cloud-sdk/completion.bash.inc
fi
KUBECONFIG="$IAM_HOME/kubeconfig"
export KUBECONFIG
unset MAILCHECK
if _has git; then
__GIT_VERSION="$(command git --version | awk '{print $3}')"
GIT_CONFIG_GLOBAL="$IAM_HOME/gitconfig"
export GIT_CONFIG_GLOBAL
fi
if _has gpg; then
GNUPGHOME="$IAM_HOME/gnupg"
export GNUPGHOME
mkdir -p "$GNUPGHOME"
chmod 0700 "$GNUPGHOME"
GPG_TTY="$(tty)"
export GPG_TTY
fi
if ! _is in-container && _is aws_metadata_available; then
AWS_DEFAULT_REGION="$(_aws_metadata placement/region)" && export AWS_DEFAULT_REGION || unset AWS_DEFAULT_REGION
fi
_unexport SSH_PUB_KEY _GIT_USER_EMAIL _GIT_USER_NAME
stty -ixon
set -o notify
shopt -s cdspell
if [ -n "$BASH_VERSION" ]; then
shopt -s dirspell 2>/dev/null || echo "FYI: 'dirspell' bash option is not supported."
fi
shopt -s checkwinsize
shopt -s cmdhist
shopt -u mailwarn
bind "set input-meta on"
bind "set output-meta on"
bind "set show-all-if-ambiguous on"
bind "set skip-completed-text on"
bind "set colored-completion-prefix on"
bind "set colored-stats on"
bind "set mark-directories on"
bind "set mark-symlinked-directories on"
bind "set visible-stats on"
bind "set blink-matching-paren on"
bind "set page-completions off"
bind '"\e[1~": beginning-of-line'
bind '"\e[4~": end-of-line'
bind '"\e[3~": delete-char'
bind '"\e[2~": quoted-insert'
bind '"\e[1;5D": backward-word'
bind '"\e[1;5C": forward-word'
ls() {
set -- -F -l "$@"
! _check command ls --color=auto --version || set -- --color=auto "$@"
! _check command ls -h --version || set -- -h "$@"
! _check command ls --group-directories-first --version || set -- --group-directories-first "$@"
env \
CLICOLOR=1 \
LSCOLORS=GxFxCxDxBxegedabagaced \
LS_COLORS='bd=38;5;68:cd=38;5;113;1:di=38;5;30:do=38;5;127:ex=38;5;208;1:pi=38;5;126:fi=0:ln=target:mh=38;5;222;1:no=0:or=48;5;196;38;5;232;1:ow=38;5;220;1:sg=48;5;3;38;5;0:su=38;5;220;1;3;100;1:so=38;5;197:st=38;5;86;48;5;234:tw=48;5;235;38;5;139;3:*LS_COLORS=48;5;89;38;5;197;1;3;4;7:*README=38;5;220;1:*README.rst=38;5;220;1:*LICENSE=38;5;220;1:*COPYING=38;5;220;1:*INSTALL=38;5;220;1:*COPYRIGHT=38;5;220;1:*AUTHORS=38;5;220;1:*HISTORY=38;5;220;1:*CONTRIBUTORS=38;5;220;1:*PATENTS=38;5;220;1:*VERSION=38;5;220;1:*NOTICE=38;5;220;1:*CHANGES=38;5;220;1:*.log=38;5;190:*.txt=38;5;253:*.etx=38;5;184:*.info=38;5;184:*.markdown=38;5;184:*.md=38;5;184:*.mkd=38;5;184:*.nfo=38;5;184:*.pod=38;5;184:*.rst=38;5;184:*.tex=38;5;184:*.textile=38;5;184:*.bib=38;5;178:*.json=38;5;178:*.msg=38;5;178:*.pgn=38;5;178:*.rss=38;5;178:*.xml=38;5;178:*.yaml=38;5;178:*.yml=38;5;178:*.RData=38;5;178:*.rdata=38;5;178:*.cbr=38;5;141:*.cbz=38;5;141:*.chm=38;5;141:*.djvu=38;5;141:*.pdf=38;5;141:*.PDF=38;5;141:*.docm=38;5;111;4:*.doc=38;5;111:*.docx=38;5;111:*.eps=38;5;111:*.ps=38;5;111:*.odb=38;5;111:*.odt=38;5;111:*.rtf=38;5;111:*.odp=38;5;166:*.pps=38;5;166:*.ppt=38;5;166:*.pptx=38;5;166:*.ppts=38;5;166:*.pptxm=38;5;166;4:*.pptsm=38;5;166;4:*.csv=38;5;78:*.ods=38;5;112:*.xla=38;5;76:*.xls=38;5;112:*.xlsx=38;5;112:*.xlsxm=38;5;112;4:*.xltm=38;5;73;4:*.xltx=38;5;73:*cfg=1:*conf=1:*rc=1:*.ini=1:*.plist=1:*.viminfo=1:*.pcf=1:*.psf=1:*.git=38;5;197:*.gitignore=38;5;240:*.gitattributes=38;5;240:*.gitmodules=38;5;240:*.awk=38;5;172:*.bash=38;5;172:*.bat=38;5;172:*.BAT=38;5;172:*.sed=38;5;172:*.sh=38;5;172:*.zsh=38;5;172:*.vim=38;5;172:*.ahk=38;5;41:*.py=38;5;41:*.ipynb=38;5;41:*.rb=38;5;41:*.pl=38;5;208:*.PL=38;5;160:*.t=38;5;114:*.msql=38;5;222:*.mysql=38;5;222:*.pgsql=38;5;222:*.sql=38;5;222:*.tcl=38;5;64;1:*.r=38;5;49:*.R=38;5;49:*.gs=38;5;81:*.asm=38;5;81:*.cl=38;5;81:*.lisp=38;5;81:*.lua=38;5;81:*.moon=38;5;81:*.c=38;5;81:*.C=38;5;81:*.h=38;5;110:*.H=38;5;110:*.tcc=38;5;110:*.c++=38;5;81:*.h++=38;5;110:*.hpp=38;5;110:*.hxx=38;5;110:*.ii=38;5;110:*.M=38;5;110:*.m=38;5;110:*.cc=38;5;81:*.cs=38;5;81:*.cp=38;5;81:*.cpp=38;5;81:*.cxx=38;5;81:*.cr=38;5;81:*.go=38;5;81:*.f=38;5;81:*.for=38;5;81:*.ftn=38;5;81:*.s=38;5;110:*.S=38;5;110:*.rs=38;5;81:*.swift=38;5;219:*.sx=38;5;81:*.hi=38;5;110:*.hs=38;5;81:*.lhs=38;5;81:*.pyc=38;5;240:*.css=38;5;125;1:*.less=38;5;125;1:*.sass=38;5;125;1:*.scss=38;5;125;1:*.htm=38;5;125;1:*.html=38;5;125;1:*.jhtm=38;5;125;1:*.mht=38;5;125;1:*.eml=38;5;125;1:*.mustache=38;5;125;1:*.coffee=38;5;074;1:*.java=38;5;074;1:*.js=38;5;074;1:*.mjs=38;5;074;1:*.jsm=38;5;074;1:*.jsm=38;5;074;1:*.jsp=38;5;074;1:*.php=38;5;81:*.ctp=38;5;81:*.twig=38;5;81:*.vb=38;5;81:*.vba=38;5;81:*.vbs=38;5;81:*Dockerfile=38;5;155:*.dockerignore=38;5;240:*Makefile=38;5;155:*MANIFEST=38;5;243:*pm_to_blib=38;5;240:*.am=38;5;242:*.in=38;5;242:*.hin=38;5;242:*.scan=38;5;242:*.m4=38;5;242:*.old=38;5;242:*.out=38;5;242:*.SKIP=38;5;244:*.diff=48;5;197;38;5;232:*.patch=48;5;197;38;5;232;1:*.bmp=38;5;97:*.tiff=38;5;97:*.tif=38;5;97:*.TIFF=38;5;97:*.cdr=38;5;97:*.gif=38;5;97:*.ico=38;5;97:*.jpeg=38;5;97:*.JPG=38;5;97:*.jpg=38;5;97:*.nth=38;5;97:*.png=38;5;97:*.psd=38;5;97:*.xpm=38;5;97:*.ai=38;5;99:*.eps=38;5;99:*.epsf=38;5;99:*.drw=38;5;99:*.ps=38;5;99:*.svg=38;5;99:*.avi=38;5;114:*.divx=38;5;114:*.IFO=38;5;114:*.m2v=38;5;114:*.m4v=38;5;114:*.mkv=38;5;114:*.MOV=38;5;114:*.mov=38;5;114:*.mp4=38;5;114:*.mpeg=38;5;114:*.mpg=38;5;114:*.ogm=38;5;114:*.rmvb=38;5;114:*.sample=38;5;114:*.wmv=38;5;114:*.3g2=38;5;115:*.3gp=38;5;115:*.gp3=38;5;115:*.webm=38;5;115:*.gp4=38;5;115:*.asf=38;5;115:*.flv=38;5;115:*.ts=38;5;115:*.ogv=38;5;115:*.f4v=38;5;115:*.VOB=38;5;115;1:*.vob=38;5;115;1:*.3ga=38;5;137;1:*.S3M=38;5;137;1:*.aac=38;5;137;1:*.au=38;5;137;1:*.dat=38;5;137;1:*.dts=38;5;137;1:*.fcm=38;5;137;1:*.m4a=38;5;137;1:*.mid=38;5;137;1:*.midi=38;5;137;1:*.mod=38;5;137;1:*.mp3=38;5;137;1:*.mp4a=38;5;137;1:*.oga=38;5;137;1:*.ogg=38;5;137;1:*.opus=38;5;137;1:*.s3m=38;5;137;1:*.sid=38;5;137;1:*.wma=38;5;137;1:*.ape=38;5;136;1:*.aiff=38;5;136;1:*.cda=38;5;136;1:*.flac=38;5;136;1:*.alac=38;5;136;1:*.midi=38;5;136;1:*.pcm=38;5;136;1:*.wav=38;5;136;1:*.wv=38;5;136;1:*.wvc=38;5;136;1:*.afm=38;5;66:*.fon=38;5;66:*.fnt=38;5;66:*.pfb=38;5;66:*.pfm=38;5;66:*.ttf=38;5;66:*.otf=38;5;66:*.PFA=38;5;66:*.pfa=38;5;66:*.7z=38;5;40:*.a=38;5;40:*.arj=38;5;40:*.bz2=38;5;40:*.cpio=38;5;40:*.gz=38;5;40:*.lrz=38;5;40:*.lz=38;5;40:*.lzma=38;5;40:*.lzo=38;5;40:*.rar=38;5;40:*.s7z=38;5;40:*.sz=38;5;40:*.tar=38;5;40:*.tgz=38;5;40:*.xz=38;5;40:*.z=38;5;40:*.Z=38;5;40:*.zip=38;5;40:*.zipx=38;5;40:*.zoo=38;5;40:*.zpaq=38;5;40:*.zz=38;5;40:*.apk=38;5;215:*.deb=38;5;215:*.rpm=38;5;215:*.jad=38;5;215:*.jar=38;5;215:*.cab=38;5;215:*.pak=38;5;215:*.pk3=38;5;215:*.vdf=38;5;215:*.vpk=38;5;215:*.bsp=38;5;215:*.dmg=38;5;215:*.r[0-9]{0,2}=38;5;239:*.zx[0-9]{0,2}=38;5;239:*.z[0-9]{0,2}=38;5;239:*.part=38;5;239:*.dmg=38;5;124:*.iso=38;5;124:*.bin=38;5;124:*.nrg=38;5;124:*.qcow=38;5;124:*.sparseimage=38;5;124:*.toast=38;5;124:*.vcd=38;5;124:*.vmdk=38;5;124:*.accdb=38;5;60:*.accde=38;5;60:*.accdr=38;5;60:*.accdt=38;5;60:*.db=38;5;60:*.fmp12=38;5;60:*.fp7=38;5;60:*.localstorage=38;5;60:*.mdb=38;5;60:*.mde=38;5;60:*.sqlite=38;5;60:*.typelib=38;5;60:*.nc=38;5;60:*.pacnew=38;5;33:*.un~=38;5;241:*.orig=38;5;241:*.BUP=38;5;241:*.bak=38;5;241:*.o=38;5;241:*core=38;5;241:*.rlib=38;5;241:*.swp=38;5;244:*.swo=38;5;244:*.tmp=38;5;244:*.sassc=38;5;244:*.pid=38;5;248:*.state=38;5;248:*lockfile=38;5;248:*.err=38;5;160;1:*.error=38;5;160;1:*.stderr=38;5;160;1:*.aria2=38;5;241:*.dump=38;5;241:*.stackdump=38;5;241:*.zcompdump=38;5;241:*.zwc=38;5;241:*.pcap=38;5;29:*.cap=38;5;29:*.dmp=38;5;29:*.DS_Store=38;5;239:*.localized=38;5;239:*.CFUserTextEncoding=38;5;239:*.allow=38;5;112:*.deny=38;5;196:*.service=38;5;45:*@.service=38;5;45:*.socket=38;5;45:*.swap=38;5;45:*.device=38;5;45:*.mount=38;5;45:*.automount=38;5;45:*.target=38;5;45:*.path=38;5;45:*.timer=38;5;45:*.snapshot=38;5;45:*.application=38;5;116:*.cue=38;5;116:*.description=38;5;116:*.directory=38;5;116:*.m3u=38;5;116:*.m3u8=38;5;116:*.md5=38;5;116:*.properties=38;5;116:*.sfv=38;5;116:*.srt=38;5;116:*.theme=38;5;116:*.torrent=38;5;116:*.urlview=38;5;116:*.asc=38;5;192;3:*.bfe=38;5;192;3:*.enc=38;5;192;3:*.gpg=38;5;192;3:*.signature=38;5;192;3:*.sig=38;5;192;3:*.p12=38;5;192;3:*.pem=38;5;192;3:*.pgp=38;5;192;3:*.asc=38;5;192;3:*.enc=38;5;192;3:*.sig=38;5;192;3:*.32x=38;5;213:*.cdi=38;5;213:*.fm2=38;5;213:*.rom=38;5;213:*.sav=38;5;213:*.st=38;5;213:*.a00=38;5;213:*.a52=38;5;213:*.A64=38;5;213:*.a64=38;5;213:*.a78=38;5;213:*.adf=38;5;213:*.atr=38;5;213:*.gb=38;5;213:*.gba=38;5;213:*.gbc=38;5;213:*.gel=38;5;213:*.gg=38;5;213:*.ggl=38;5;213:*.ipk=38;5;213:*.j64=38;5;213:*.nds=38;5;213:*.nes=38;5;213:*.sms=38;5;213:*.pot=38;5;7:*.pcb=38;5;7:*.mm=38;5;7:*.pod=38;5;7:*.gbr=38;5;7:*.spl=38;5;7:*.scm=38;5;7:*.Rproj=38;5;11:*.sis=38;5;7:*.1p=38;5;7:*.3p=38;5;7:*.cnc=38;5;7:*.def=38;5;7:*.ex=38;5;7:*.example=38;5;7:*.feature=38;5;7:*.ger=38;5;7:*.map=38;5;7:*.mf=38;5;7:*.mfasl=38;5;7:*.mi=38;5;7:*.mtx=38;5;7:*.pc=38;5;7:*.pi=38;5;7:*.plt=38;5;7:*.pm=38;5;7:*.rdf=38;5;7:*.rst=38;5;7:*.ru=38;5;7:*.sch=38;5;7:*.sty=38;5;7:*.sug=38;5;7:*.t=38;5;7:*.tdy=38;5;7:*.tfm=38;5;7:*.tfnt=38;5;7:*.tg=38;5;7:*.vcard=38;5;7:*.vcf=38;5;7:*.xln=38;5;7:*.iml=38;5;166:*.xcconfig=1:*.entitlements=1:*.strings=1:*.storyboard=38;5;196:*.xcsettings=1:*.xib=38;5;208:' \
ls "$@"
}
_hasnot ps || psa() {
_check command ps --version && set -- aux "$@" || set -- -e -f "$@"
env ps "$@"
}
_hasnot ps || psaf() {
_check command ps --version && set -- auxf "$@" || set -- -e -f "$@"
env ps "$@"
}
_hasnot ps || psgrep() {
local OUTPUT
if OUTPUT="$(psaf)"; then
echo "$OUTPUT" | head -n 1
echo "$OUTPUT" | grep "$@"
fi
}
_hasnot grep || grep() {
! _check command grep --color=auto --version || set -- --color=auto "$@"
env grep "$@"
}
_hasnot grep || grepzip() {
local ret i start_fn
for (( i = 1; i <= $#; i++ )); do
_glob_match "*.zip" "${!i}" || continue
start_fn=$i
break
done
[ -n "$start_fn" ] || { echo "Error: zip files in command line were not found." >&2; return 1; }
for (( i = start_fn; i <= $#; i++ )); do
local TEMP_DIR
TEMP_DIR="$(mktemp -d)"
if unzip -q "${!i}" -d "$TEMP_DIR"; then
grep "${@:1:$(( start_fn - 1 ))}" -r "$TEMP_DIR" || true
else
ret=$?
fi
rm -rf "$TEMP_DIR"
[ -z "$ret" ] || return $ret
done
}
_hasnot ip || ip() {
! _check command ip -color -Version || set -- -color "$@"
env ip "$@"
}
_hasnot diff || diff() {
if [ -t 1 ]; then
! _check command diff --color=auto --version || set -- --palette=':ad=32:de=31:ln=35' --color=auto "$@"
fi
env diff "$@"
}
alias mv='mv -i'
alias mkdir='mkdir -p'
alias mkcd='_(){ mkdir -p $1; cd $1; }; _'
alias mkcdtmp='_(){ cd "$(test -z "$1" && mktemp -d || mktemp -d -t "${1}.XXXXXXX")"; }; _'
alias ..='cd ..'
alias tailf='tail -F'
alias ff='find . -name'
if _has vim; then
EDITOR="vim -u $IAM_HOME/vimrc -i $IAM_HOME/viminfo"
elif _has vi; then
EDITOR="vi"
else
_warn 'vi/vim not found\n'
fi
export EDITOR
alias vi=vim
vim() {
_maybe_local "vim"
local VIM_SESSION_FILE="$_TERM_SESSION_DIR/vim"
[ -z "$_TERM_SESSION_DIR" ] || {
if [ -e "$VIM_SESSION_FILE" ]; then
set -- $(< "$VIM_SESSION_FILE")
else
printf '%q ' "$@" > "$VIM_SESSION_FILE"
fi
}
command vim -u "$IAM_HOME/vimrc" -i "$IAM_HOME/viminfo" "$@"
[ -z "$_TERM_SESSION_DIR" ] || rm -f "$VIM_SESSION_FILE"
}
mkdir -p "$IAM_HOME/vim_swap"
mkdir -p "$IAM_HOME/vim_runtime"
_has apt-get && _isnot root && apt-get() {
cprintf "~r~The 'sudo' prefix was added automatically for the 'apt-get' comman" >&2
sudo apt-get "$@"
}
_has apt && _isnot root && apt() {
case "$1" in
install|remove|purge|autoremove|update|upgrade|full-upgrade|edit-sources)
cprintf "~r~The 'sudo' prefix was added automatically for the 'apt' command" >&2
sudo apt "$@"
;;
*) command apt "$@"
;;
esac
}
_has pacman && _isnot root && pacman() {
case "$1" in
-S*|-R*|-U*|-D*)
cprintf "~r~The 'sudo' prefix was added automatically for the 'pacman' command" >&2
sudo pacman "$@"
;;
*) command pacman "$@"
;;
esac
}
clear() {
[ "$TERM" != "tmux-256color" ] || set -- -T tmux "$@"
command clear "$@"
}
man() {
env \
LESS_TERMCAP_mb=$'\E[01;31m' \
LESS_TERMCAP_md=$'\E[01;31m' \
LESS_TERMCAP_me=$'\E[0m' \
LESS_TERMCAP_se=$'\E[0m' \
LESS_TERMCAP_so=$'\E[01;44;33m' \
LESS_TERMCAP_ue=$'\E[0m' \
LESS_TERMCAP_us=$'\E[01;32m' \
man "$@"
}
sha256sum() {
case "$1" in
http://*|https://*) _get_url "$1" | command sha256sum;;
*) command sha256sum "$@";;
esac
}
,myip() { _get_url "https://checkip.amazonaws.com"; }
,hostname() {
local FN="$IAM_HOME/hostname"
[ -z "$1" ] || { [ "$1" = "-" ] && rm -f "$FN" || echo "$1" > "$FN"; }
[ -f "$FN" ] && echo "Set hostname: $(cat "$FN")" || echo "Hostname is not set"
}
,retry() {
local R
while true; do
"$@" && R=0 || R=$?
echo "Exit code: $R; Retry in 5 seconds ..."
sleep 5
done
}
_comp_,retry() {
if _has_function _comp_command_offset; then
_comp_command_offset 1
elif _has_function _command_offset; then
local cur prev words cword split
_init_completion -s || return
_command_offset 1
fi
}
complete -F _comp_,retry ,retry
if _is need_proxy; then
,proxy() {
env \
https_proxy=http://127.0.0.1:52011 \
http_proxy=http://127.0.0.1:52011 \
HTTPS_PROXY=http://127.0.0.1:52011 \
HTTP_PROXY=http://127.0.0.1:52011 \
"$@"
}
_comp_,proxy() {
if _has_function _comp_command_offset; then
_comp_command_offset 1
elif _has_function _command_offset; then
local cur prev words cword split
_init_completion -s || return
_command_offset 1
fi
}
complete -F _comp_,proxy ,proxy
fi
,forget() {
[ -n "$1" ] || { echo "Usage: $0 <grep parameters>"; return 1; }
grep "$@" "$HISTFILE" || { echo "Nothing found."; return 1; }
echo
local ASK TMP_FILE
read -r -p "Do you wish to delete these lines from history file '$HISTFILE' [y/N]? " ASK
_glob_match '[Yy]*' "$ASK" || { echo "Do nothing."; return 0; }
TMP_FILE="$(mktemp)"
grep -v "$@" "$HISTFILE" > "$TMP_FILE"
awk '/^#[0-9]+$/ { last=$0; have_in=1; next } !/^#[0-9]+$/ { if (have_in) { print last; have_in=0 } print }' "$TMP_FILE" > "$HISTFILE"
rm -f "$TMP_FILE"
echo "Done."
}
,dedup_history() {
local ASK TMP_FILE LINES_START LINES_END
read -r -p "Do you wish to dedup lines in history file '$HISTFILE' [y/N]? " ASK
_glob_match '[Yy]*' "$ASK" || { echo "Do nothing."; return 0; }
LINES_START="$(wc -l < "$HISTFILE")"
TMP_FILE="$(mktemp)"
tac "$HISTFILE" \
| awk '/^#[0-9]+$/ || !seen[$0]++ { print }' \
| tac > "$TMP_FILE"
awk '/^#[0-9]+$/ { last=$0; have_in=1; next } !/^#[0-9]+$/ { if (have_in) { print last; have_in=0 } print }' "$TMP_FILE" > "$HISTFILE"
rm -f "$TMP_FILE"
LINES_END="$(wc -l < "$HISTFILE")"
echo "Done. Removed lines: $(( LINES_START - LINES_END ))"
}
reload() {
if _is tmux && [ "$1" != "current" ]; then
local current_wid wid cmd
current_wid="$(command tmux display-message -p -t "$TMUX_PANE" '#{window_id}')"
for wid in $(command tmux list-windows -F '#{window_id}'); do
[ "$wid" != "$current_wid" ] || continue
cmd="$(command tmux display-message -p -t "$wid" '#{pane_current_command}')"
if [ "$cmd" != "bash" ]; then
echo "Error: can't reload window '$(command tmux display-message -p -t "$wid" '#{window_index}:#{window_name}')' as its command '$cmd' is not 'bash'."
return 1
fi
done
"$IAM_HOME/tools/bin/tmux-helper" reset-options-to-default >/dev/null 2>&1 || true
command tmux source-file "$IAM_HOME/tmux.conf"
for wid in $(command tmux list-windows -F '#{window_id}'); do
[ "$wid" != "$current_wid" ] || continue
command tmux send-keys -t "$wid" 'reload current' C-m
done
fi
export _SHELL_SESSION_ID _TERM_SESSION_ID _TMUX_SESSION_ID
export SSH_PUB_KEY _GIT_USER_EMAIL _GIT_USER_NAME
exec bash --rcfile "$IAM_HOME/bashrc" -i
}
gssh() {
host="$1"
shift
gcloud compute ssh --internal-ip "$host" "$@" -- -t "$(__magic_ssh)"
}
,sudo() {
local sudo_cmd
if [ -z "$1" ]; then
sudo_cmd="sudo"
else
sudo_cmd="sudo -u $1"
fi
$sudo_cmd -H bash -ci "$(__magic_ssh)"
}
_hasnot_potentially kpexec || ,kpexec() {
_maybe_local "kpexec"
command kpexec -ti -T "$@" -- bash -ci "sleep 3; $(__magic_ssh)"
}
wsl() {
if [ -n "$1" ]; then
command wsl "$@"
else
echo "IAM=\"$IAM\" && export IAM && \
SSH_PUB_KEY=\"$SSH_PUB_KEY\" && export SSH_PUB_KEY && \
IAM_HOME=\"\$HOME/.${IAM}_home\" && export IAM_HOME && \
_GIT_USER_NAME=\"$_GIT_USER_NAME\" && export _GIT_USER_NAME && \
_GIT_USER_EMAIL=\"$_GIT_USER_EMAIL\" && export _GIT_USER_EMAIL && \
if [ ! -d \"\$IAM_HOME/terminfo\" ]; then mkdir \"\$IAM_HOME/terminfo\"; fi && \
echo \"$(cat "${IAM_HOME}"/terminfo/.terminfo | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/terminfo/.terminfo\" &&
TERMINFO=\"\$IAM_HOME/terminfo\" && \
export TERMINFO && \
tic \"\$IAM_HOME/terminfo/.terminfo\" && \
echo \"$(cat "${IAM_HOME}"/vimrc | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/vimrc\" && \
echo \"$(cat "${IAM_HOME}"/local_tools | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/local_tools\" && \
echo \"$(cat "${HOME}"/.tclshrc | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$HOME/.tclshrc\" && \
echo \"$(cat "${IAM_HOME}"/bashrc | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/bashrc\"" \
| wsl -d Ubuntu
wsl -d Ubuntu /bin/bash -ci "IAM=\"$IAM\" && export IAM && \
SSH_PUB_KEY=\"$SSH_PUB_KEY\" && export SSH_PUB_KEY && \
IAM_HOME=\"\$HOME/.${IAM}_home\" && export IAM_HOME && \
_GIT_USER_NAME=\"$_GIT_USER_NAME\" && export _GIT_USER_NAME && \
_GIT_USER_EMAIL=\"$_GIT_USER_EMAIL\" && export _GIT_USER_EMAIL && \
if [ ! -d \"\\\$IAM_HOME/terminfo\" ]; then mkdir \"\\\$IAM_HOME/terminfo\"; fi && \
echo \"$(cat "$IAM_HOME"/terminfo/.terminfo | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\\\$IAM_HOME/terminfo/.terminfo\" &&
TERMINFO=\"\\\$IAM_HOME/terminfo\" && \
export TERMINFO && \
tic \"\\\$IAM_HOME/terminfo/.terminfo\" && \
exec bash --rcfile \"\\\$IAM_HOME/bashrc\" -i || exec \\\$SHELL -i"
fi
}
_send_raw_term() {
if _is tmux; then
printf '\033Ptmux;'
sed -E 's/\x1B/&&/g'
printf '\033\\'
else
cat
fi
}
get() {
local file
{
printf '\033]0;__pw:%s\007' "$PWD"
for file; do
if [ -d "$file" ]; then
basename="$(basename "$file")"
rm -f "/tmp/{basename}.tar.gz"
tar czf "/tmp/${basename}.tar.gz" "$file"
printf '\033]0;__rv:%s\007' "/tmp/${basename}.tar.gz"
rm -f "/tmp/{basename}.tar.gz"
else
printf '\033]0;__rv:%s\007' "$file"
fi
done
printf '\033]0;__ti\007'
} | _send_raw_term
}
winscp() {
printf '\033];__ws:%s\007' "$PWD" | _send_raw_term
}
clip() {
{
printf '\033[5i'
cat "$@"
printf '\033[4i'
} | _send_raw_term
echo "Copied to Windows clipboard" 1>&2
}
,fix-x-permission() {
local fn
for fn; do
cat "$fn" > "${fn}.fix-permissions"
mv -f "${fn}.fix-permissions" "$fn"
done
}
LESS="-F -X -R -i -w -z-4 -P spacebar\:page ahead b\:page back /\:search ahead \?\:search back h\:help q\:quit"
export LESS
_hasnot moar || export PAGER="moar -quit-if-one-screen"
shopt -s histappend
shopt -s cmdhist
unset HISTFILESIZE
HISTSIZE=1000000
HISTCONTROL=ignoreboth
HISTTIMEFORMAT='%F %T '
HISTIGNORE="&:[bf]g:exit:history:history *:reset:clear:export AWS_*"
HISTIGNORE="$HISTIGNORE:reload:reload current:mkcdtmp"
if _is in-container; then
HISTFILE="$IAM_HOME/bash_history"
else
HISTFILE_GLOBAL="$IAM_HOME/bash_history"
HISTFILE="$_SHELL_SESSION_DIR/bash_history"
history -cr "$HISTFILE_GLOBAL"
fi
_homify() {
local __HOMIFY_VAR __HOMIFY_DIR __HOMIFY_WIDTH=20 __HOMIFY_TRUNC='...'
[ "$1" != "-v" ] || { __HOMIFY_VAR="$2"; shift 2; }
[ -z "$COLUMNS" ] || __HOMIFY_WIDTH=$(( COLUMNS / 4 ))
[ -n "$1" ] && __HOMIFY_DIR="$1" || __HOMIFY_DIR="$PWD"
if [ "$__HOMIFY_DIR" = "$HOME" ] || _glob_match "$HOME/*" "$__HOMIFY_DIR"; then
__HOMIFY_DIR="~${__HOMIFY_DIR#"$HOME"}"
fi
if [ ${#__HOMIFY_DIR} -gt $__HOMIFY_WIDTH ]; then
__HOMIFY_DIR="$__HOMIFY_TRUNC${__HOMIFY_DIR:$(( ${#__HOMIFY_DIR} - __HOMIFY_WIDTH + ${#__HOMIFY_TRUNC} ))}"
fi
[ -n "$__HOMIFY_VAR" ] && printf -v "$__HOMIFY_VAR" '%s' "$__HOMIFY_DIR" || echo "$__HOMIFY_DIR"
}
__kubectl_status() {
if ! _has kubectl || [ ! -e "$IAM_HOME/state/on_kube" ]; then
return 0
fi
[ "$1" != "-check" ] || return 1
local CONFIG CONFIG_MSG MSG STDERR
if [ -z "$KUBECONFIG" ]; then
CONFIG="$HOME/.kube/config"
else
CONFIG="$KUBECONFIG"
fi
_homify -v CONFIG_MSG "$CONFIG"
cprintf -v MSG '~K~[~W~K8S~K~: ~c~%s' "$CONFIG_MSG"
if [ ! -e "$CONFIG" ]; then
cprintf -A MSG "- ~r~DOESN'T EXIST"
else
cprintf -a MSG '~K~; ~d~cluster~K~:'
local CONTEXT
if ! _catch CONTEXT STDERR \
command kubectl config view --minify \
-o=jsonpath="{.contexts[0].name}|{.contexts[0].context.namespace}"
then
STDERR="${STDERR#* }"
cprintf -A MSG '~R~%s' "$STDERR"
elif [ -n "$STDERR" ]; then
cprintf -A MSG '~R~%s' "$STDERR"
else
local NAMESPACE="${CONTEXT#*|}"
CONTEXT="${CONTEXT%|*}"
[ -n "$NAMESPACE" ] || NAMESPACE="default"
cprintf -A MSG '~m~%s~K~; ~d~namespace~K~: ~B~%s' "$CONTEXT" "$NAMESPACE"
fi
fi
cprintf -a MSG '~K~]'
_ps1_show_status "$MSG"
}
__aws_status() {
_has aws || return 0
if [ -z "$__AWS_INSTANCE_HAS_ROLE" ]; then
local USERID
_is aws \
&& USERID="$(aws sts get-caller-identity --query 'UserId' --output text 2>&1)" \
&& _glob_match "*:i-*" "$USERID" \
&& __AWS_INSTANCE_HAS_ROLE=1 \
|| __AWS_INSTANCE_HAS_ROLE=0
fi
[ "$__AWS_INSTANCE_HAS_ROLE" -eq 0 ] \
&& [ -z "$AWS_ACCESS_KEY_ID$AWS_SECRET_ACCESS_KEY$AWS_SESSION_TOKEN$AWS_PROFILE" ] \
&& [ ! -e "$IAM_HOME/state/on_aws" ] \
&& return 0 \
|| true
if [ -n "$AWS_ACCESS_KEY_ID$AWS_SECRET_ACCESS_KEY$AWS_SESSION_TOKEN" ] && [ -n "$AWS_PROFILE" ]; then
AWS_PROFILE_INACTIVE="$AWS_PROFILE"
unset AWS_PROFILE
fi
[ "$1" != "-check" ] || return 1
local MSG
cprintf -v MSG '~K~[~W~AWS~K~:'
if [ -e "$IAM_HOME/state/on_aws_localstack" ]; then
cprintf -A MSG 'localstack~K~:'
if ! _has curl; then
cprintf -A MSG "~y~unknown (curl doesn't exist)"
elif curl --silent --fail -o /dev/null http://localhost:4566; then
cprintf -A MSG "~g~running"
else
cprintf -A MSG "~r~not running"
fi
cprintf -a MSG '~K~]'
_ps1_show_status "$MSG"
return 0
fi
if [ -n "$AWS_PROFILE" ]; then
cprintf -A MSG 'profile~K~: ~m~%s' "$AWS_PROFILE"
elif [ -z "$AWS_ACCESS_KEY_ID$AWS_SECRET_ACCESS_KEY$AWS_SESSION_TOKEN" ] && [ "$__AWS_INSTANCE_HAS_ROLE" -eq 1 ]; then
cprintf -A MSG 'instance-profile~K~: ~g~Y'
else
local KEY SECRET SESSION
[ -z "$AWS_ACCESS_KEY_ID" ]     && KEY="~r~N"     || KEY="~g~Y"
[ -z "$AWS_SECRET_ACCESS_KEY" ] && SECRET="~r~N"  || SECRET="~g~Y"
[ -z "$AWS_SESSION_TOKEN" ]     && SESSION="~r~N" || SESSION="~g~Y"
cprintf -A MSG "key~K~: $KEY~K~; ~d~secret~K~: $SECRET~K~; ~d~session~K~: $SESSION"
[ -z "$AWS_PROFILE_INACTIVE" ] \
|| cprintf -a MSG '~K~; ~y~inactive-profile~K~: ~g~%s' "$AWS_PROFILE_INACTIVE"
fi
cprintf -a MSG '~K~; ~d~region~K~:'
local REGION
if [ -n "$AWS_PROFILE" ] && [ -z "$AWS_DEFAULT_REGION" ]; then
REGION="$(command aws configure list 2>/dev/null | awk '$1 == "region" { print $2 }')"
[ "$REGION" != "<not" ] || unset REGION
fi
if [ -z "$REGION" ] && [ -n "$AWS_DEFAULT_REGION" ]; then
REGION="$AWS_DEFAULT_REGION"
fi
[ -n "$REGION" ] \
&& cprintf -A MSG '~c~%s' "$REGION" \
|| cprintf -A MSG '~r~%s' "N"
cprintf -a MSG '~K~; ~d~indentity~K~:'
local INDENTITY
if ! INDENTITY="$(aws sts get-caller-identity --query 'Arn' --output text 2>&1)"; then
INDENTITY="${INDENTITY//$'\n'/}"
INDENTITY="${INDENTITY#*:}"
_trim -v INDENTITY -- "$INDENTITY"
cprintf -A MSG '~R~%s' "$INDENTITY"
else
cprintf -A MSG '~g~%s' "$INDENTITY"
fi
cprintf -a MSG '~K~]'
_ps1_show_status "$MSG"
}
_ps1_show_status() {
if _isnot tmux; then
echo "$1"
return
fi
[ -n "$_PS1_TMUX_CURRENT_WINDOW" ] || _PS1_TMUX_CURRENT_WINDOW="$(command tmux display-message -p -t "$TMUX_PANE" '#{window_id}')"
if [ -z "$_PS1_TMUX_CURRENT_STATUS" ]; then
_PS1_TMUX_CURRENT_STATUS="$(command tmux list-panes -t "$_PS1_TMUX_CURRENT_WINDOW" -F '#{pane_pid} #{pane_id}' | grep '^0 ' | awk '{print $2}' | tail -n 1)"
[ -n "$_PS1_TMUX_CURRENT_STATUS" ] || _PS1_TMUX_CURRENT_STATUS="$(command tmux split-window -d -l 1 -v -t "$TMUX_PANE" -P -F '#{pane_id}' '')"
command tmux set -p -t "$TMUX_PANE" pane-border-style 'bg=default,fg=colour238'
command tmux set -p -t "$TMUX_PANE" pane-active-border-style 'bg=default,fg=colour238'
command tmux set -p -t "$_PS1_TMUX_CURRENT_STATUS" pane-border-style 'bg=default,fg=colour238'
command tmux set -p -t "$_PS1_TMUX_CURRENT_STATUS" pane-active-border-style 'bg=default,fg=colour238'
fi
if [ "$1" = "-reserve" ]; then
command tmux resize-pane -y "$2" -t "$_PS1_TMUX_CURRENT_STATUS"
else
local PRE_FORMAT='\033[H'
[ -n "$_PS1_STATUS_DEFER" ] && PRE_FORMAT='\n' || _PS1_STATUS_DEFER=1
printf "${PRE_FORMAT}\033[2K\033[?7l%s\033[?7h" "$1" | command tmux display-message -t "$_PS1_TMUX_CURRENT_STATUS" -I
fi
}
function promptcmd () {
local exitcode="$1" i
if [ -z "$__PROMPTCMD_NO_CURPOS" ] && [ -z "$FARPID" ]; then
local CURPOS SAVE_STTY
SAVE_STTY="$(stty -g)"
stty raw -echo min 0
echo -en "\033[6n"
if ! read -r -s -t 0.2 -dR CURPOS; then
CURPOS=1
__PROMPTCMD_NO_CURPOS=1
fi
stty "$SAVE_STTY"
[ "${CURPOS##*;}" -eq 1 ] || cprintf '~Wr~%%'
fi
if [ "$exitcode" -ne 0 ] && [ -n "$PS1_COMMAND" ]; then
local SIG
if [ "$exitcode" -eq 130 ]; then
SIG="<Ctrl-C>"
elif [ "$exitcode" -eq 127 ]; then
SIG="command is not found"
elif [ "$exitcode" -eq 126 ]; then
SIG="command is not executable"
elif [ "$exitcode" -gt 128 ] && SIG="$(builtin kill -l "$exitcode" 2>/dev/null)"; then
SIG="SIG$SIG"
elif [ "$exitcode" -ge 64 ] && [ "$exitcode" -le 78 ] && SIG="$(echo ':64:USAGE:65:DATAERR:66:NOINPUT:67:NOUSER:68:NOHOST:69:UNAVAILABLE:70:SOFTWARE:71:OSERR:72:OSFILE:73:CANTCREAT:74:IOERR:75:TEMPFAIL:76:PROTOCOL:77:NOPERM:78:CONFIG:' | grep -o ":${exitcode}:[^:]*")"; then
SIG="EX_${SIG##*:}"
fi
[ -z "$SIG" ] || SIG=" ~K~[~y~${SIG}~K~]"
cprintf "~r~Exit code~K~: ~R~%i$SIG" "$exitcode"
fi
if [ -n "$_TMUX_WINDOW_DUMP_FILE" ]; then
command tmux capture-pane -t "$TMUX_PANE" -e -p -S -1000 > "$_TMUX_WINDOW_DUMP_FILE" 2>/dev/null &
disown $!
fi
if [ ! -d "$PWD" ]; then
_warn "Warning: Current directory doesn't exist"
elif _check stat -c '%i' . && [ ! -L "$PWD" ] && [ "$(stat -c '%i' . 2>&1)" != "$(stat -c '%i' "$PWD")" ]; then
cprintf '~y~Current directory is a zombie. Fixing it.'
cd ../"${PWD##*/}" || :
fi
if [ -n "$_TERM_SESSION_DIR" ]; then
echo "$PWD" > "$_TERM_SESSION_DIR/pwd"
fi
echo "$PWD" > "$IAM_HOME/jumplist_last_pwd"
if [ -n "$HISTFILE_GLOBAL" ]; then
(builtin history -a "$HISTFILE_GLOBAL")
fi
builtin history -a
local SCRIPT
for SCRIPT in "$IAM_HOME"/shell.rc/*; do
[ -e "$SCRIPT" ] || continue
! _once "PS1 -> source $SCRIPT" && [ "$_SHELL_SESSION_STAMP" -nt "$SCRIPT" ] || source "$SCRIPT"
done
if [ -z "$VIRTUAL_ENV" ]; then
if [ -f "$PWD/.venv/bin/activate" ]; then
source "$PWD/.venv/bin/activate" || true
elif _is windows && [ -f "$PWD/.venv/Scripts/activate" ]; then
source "$PWD/.venv/Scripts/activate" || true
fi
else
unset __VENV_DEACTIVATE
if [ ! -d "$VIRTUAL_ENV" ]; then
__VENV_DEACTIVATE=1
else
__VENV_HOME="${VIRTUAL_ENV%/*}"
if [ "$__VENV_HOME" != "$PWD" ]; then
__VENV_HOME="$__VENV_HOME/"
if [ "${PWD:0:${#__VENV_HOME}}" != "$__VENV_HOME" ]; then
__VENV_DEACTIVATE=1
fi
fi
unset __VENV_HOME
fi
if [ -n "$__VENV_DEACTIVATE" ]; then
deactivate || unset VIRTUAL_ENV
unset __VENV_DEACTIVATE
fi
fi
if _isnot tmux; then
__aws_status
__kubectl_status
! _has_function __git_status || __git_status
else
local _PS1_STATUS_AWS=0 _PS1_STATUS_K8S=0 _PS1_STATUS_GIT=0
__aws_status -check || _PS1_STATUS_AWS=1
__kubectl_status -check || _PS1_STATUS_K8S=1
if _has_function __git_status; then
__git_status -check || _PS1_STATUS_GIT=1
fi
local _PS1_STATUS_COUNT=$(( _PS1_STATUS_AWS + _PS1_STATUS_K8S + _PS1_STATUS_GIT ))
if [ "$_PS1_STATUS_COUNT" != "0" ]; then
_ps1_show_status -reserve "$_PS1_STATUS_COUNT"
(
[ "$_PS1_STATUS_AWS" = "0" ] || __aws_status
[ "$_PS1_STATUS_K8S" = "0" ] || __kubectl_status
[ "$_PS1_STATUS_GIT" = "0" ] || __git_status
) &
disown $!
elif [ -n "$_PS1_TMUX_CURRENT_STATUS" ]; then
command tmux kill-pane -t "$_PS1_TMUX_CURRENT_STATUS"
command tmux set-hook -u -w -t "$TMUX_PANE" 'pane-exited[879]'
unset _PS1_TMUX_CURRENT_STATUS
fi
fi
if _is tmux && [ -n "$TMUX_PANE" ]; then
command tmux set-hook -R -t "$TMUX_PANE" window-renamed >/dev/null 2>&1 &
disown $!
fi
local _HOSTNAME='\h'
[ ! -f "$IAM_HOME/hostname" ] || _HOSTNAME="$(cat "$IAM_HOME/hostname")"
PS1=""
if _isnot tmux; then
case ${TERM} in
xterm*)
PS1="${PS1}\[\033]0;${_HOSTNAME}:\w\007\]"
;;
esac
fi
local USER_COLOR
if [ "$UID" -eq 0 ] ; then
if [ "$USER" = "$LOGNAME" ]; then
[ -n "$SUDO_USER" ] \
&& USER_COLOR="~r~" \
|| USER_COLOR="~R~"
else
USER_COLOR="~Y~"
fi
else
[ "$USER" = "$LOGNAME" ] \
&& USER_COLOR="~g~" \
|| USER_COLOR="~y~"
fi
cprintf -a PS1 "~K~[${USER_COLOR}%s~K~@~B~%s" '\u' "$_HOSTNAME"
if _is wsl; then
cprintf -a PS1 '~K~[~d~WSL~K~]'
elif _is in-docker; then
cprintf -a PS1 '~K~[~d~docker~K~]'
elif _is in-container; then
cprintf -a PS1 '~K~[~d~container~K~]'
elif _is aws; then
cprintf -a PS1 '~K~[~m~AWS~K~]'
fi
if [ -n "$VIRTUAL_ENV" ]; then
cprintf -a PS1 '~K~[~y~VENV~K~]'
fi
local PWD_MSG PWD_COLOR
_homify -v PWD_MSG "$PWD"
[ -w "$PWD" ] \
&& PWD_COLOR="~g~" \
|| PWD_COLOR="~r~"
cprintf -a PS1 "~K~:${PWD_COLOR}%s~K~]" "$PWD_MSG"
if [ -n "$_BASHRC_STAMP_FILE" ] && [ ! -e "$_BASHRC_STAMP_FILE" ]; then
cprintf -a PS1 "~K~[~r~bashrc is obsolete~K~]"
fi
[ "$UID" -eq 0 ] \
&& cprintf -a PS1 '~r~# ~d~' \
|| cprintf -a PS1 '~136~$ ~d~'
unset PS1_COMMAND
if _is tmux && [ -n "$__TMUX_FUNCTIONS_AVAILABLE" ]; then
,tmux autosave
fi
echo > "$_SHELL_SESSION_STAMP"
}
__debug_trap() {
: "$BASH_COMMAND"
[ "$1" != "on"  ] || { unset __BASH_DEBUG_TRAP_IGNORE; return "${2-0}"; }
[ "$1" != "off" ] || { __BASH_DEBUG_TRAP_IGNORE=1; return "${2-0}"; }
[ "${BASH_COMMAND%% *}" != "__debug_trap" ] || return
[ -z "$__BASH_DEBUG_TRAP_IGNORE" ] || return
: echo "PRE> PS1_COMMAND = '$BASH_COMMAND'"
[ "$BASH_SUBSHELL" -eq 0 ] || return
[ -z "$COMP_LINE" ] || return
[ -z "$PS1_COMMAND" ] || return
PS1_COMMAND="$BASH_COMMAND"
: echo "> PS1_COMMAND = $PS1_COMMAND '$IN_PS_COMMAND'"
}
__cleanup_trap() {
local RC=$?
rm -rf "$_SHELL_SESSION_DIR"
exit $RC
}
PROMPT_COMMAND="{ __debug_trap off \$? && __EC=0 || __EC=\$?; promptcmd \$__EC; unset __EC; __debug_trap on; } 2>/dev/null"
trap '{ __debug_trap; } 2>/dev/null' DEBUG
trap '__cleanup_trap' EXIT
if _is hpux; then
stty intr '^C' kill '^U' susp '^Z'
elif _is macos; then
BASH_SILENCE_DEPRECATION_WARNING=1
export BASH_SILENCE_DEPRECATION_WARNING
elif _is windows; then
shopt -s nocaseglob
bind "set completion-ignore-case on"
shopt -s completion_strip_exe
bind "set meta-flag on"
bind "set convert-meta off"
bind "set output-meta on"
KUBECONFIG=$(cygpath -m "$KUBECONFIG")
export KUBECONFIG
USE_GKE_GCLOUD_AUTH_PLUGIN=True
export USE_GKE_GCLOUD_AUTH_PLUGIN
if [ "$SSH_TTY" ]; then
PROGRAMFILESX86="$(cmd.exe /C "echo %ProgramFiles(x86)%" | tr -d '\r')"
set -- \
/proc/registry/HKEY_CURRENT_USER/Volatile\ Environment/* \
/proc/registry/HKEY_CURRENT_USER/Environment/* \
/proc/registry/HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/Control/Session\ Manager/Environment/*
for fn; do
[ -f "$fn" ] || continue
__var="${fn##*/}"
__var="${__var^^}"
if [ "${__var/ /}" != "$__var" ]; then
echo "Warning! Space in environment variable name '${__var}'"
continue
fi
[ -z "${!__var}" ] || continue
if [ "$__var" = "TEMP" ] || [ "$__var" = "TMP" ]; then
continue
fi
IFS= read -d $'\0' -r __val < "$fn"
__val="${__val/\%SystemRoot\%/$SYSTEMROOT}"
__val="${__val/\%ProgramFiles\%/$PROGRAMFILES}"
__val="${__val/\%USERPROFILE\%/$USERPROFILE}"
__val="${__val/\%ProgramFiles(x86)\%/$PROGRAMFILESX86}"
__val="${__val/\%HomeDrive\%\%HomePath\%/$USERPROFILE}"
echo "Added environment variable: $__var"
if [ "${__val/\%/}" != "$__val" ]; then
echo "Warning! Percent in environment variable '${__var}': '${__val}'"
fi
export "$__var"="$__val" >/dev/null 2>&1
done
unset fn __var __val
fi
fi
if _isnot tmux; then
unset WARN
if _is wsl; then
for fn in gsudo gsudo.exe; do
REAL_CMD="$(command -v "$fn" 2>/dev/null)"
if [ -n "$REAL_CMD" ] && [ ! -x "$REAL_CMD" ]; then
if ! chmod +x "$REAL_CMD" >/dev/null 2>&1; then
[ -n "$WARN" ] || echo
_warn "could not chmod +x '%s': Permission denied. Run it using gsudo or run WSL under elevated powershell." "$REAL_CMD"
WARN=1
fi
fi
done
for fn in vagrant VBoxManage net sc notepad explorer reg; do
REAL_CMD="$(command -v "${fn}.exe" 2>/dev/null)"
if [ -n "$REAL_CMD" ]; then
ln -sf "$REAL_CMD" "$IAM_HOME/tools/bin/$fn"
if [ ! -x "$REAL_CMD" ]; then
if ! chmod +x "$REAL_CMD" >/dev/null 2>&1; then
[ -n "$WARN" ] || echo
_warn "could not chmod +x '%s': Permission denied. Run it using gsudo." "$REAL_CMD"
WARN=1
fi
fi
fi
done
fi
[ -z "$WARN" ] || echo
unset fn REAL_CMD WARN
fi
if [ -f ~/."${IAM}"_customrc ]; then
. ~/."${IAM}"_customrc
fi
for VAR in LD_LIBRARY_PATH LIBPATH SHLIB_PATH DYLD_LIBRARY_PATH LD_PRELOAD LD_RUN_PATH; do
if [ ! -z "${!VAR}" ]; then
FOUND=1
_warn 'environment variable defined: %s = "%s"' "$VAR" "${!VAR}"
fi
done; unset VAR
if [ ! -z "$FOUND" ]; then
echo ""
unset FOUND
fi
if _has ssh && _isnot in-container && _isnot tmux; then
if ! RESULT="$(ssh -G 127.0.0.1 2>&1)"; then
_warn 'unknown error while checking SSH ServerAliveInterval\n'
else
if ! RESULT="$(echo "$RESULT" | grep '^serveraliveinterval ')"; then
_warn 'could not find ServerAliveInterval in SSH output\n'
else
RESULT="${RESULT#* }"
case "$RESULT" in
''|*[!0-9]*)
_warn 'SSH ServerAliveInterval is expected to be a number, but got: "%s"\n' "$RESULT"
;;
*)
if [ "$RESULT" -ne 60 ]; then
_info 'SSH ServerAliveInterval is "%s". Adding correct value (60) to ~/.ssh/config' "$RESULT"
if [ ! -d ~/.ssh ]; then
mkdir -p ~/.ssh
chmod 0700 ~/.ssh
fi
if [ -f ~/.ssh/config ]; then
TEMP_FILE="$(mktemp)"
echo 'ServerAliveInterval 60' > "$TEMP_FILE"
cat ~/.ssh/config >> "$TEMP_FILE"
cat "$TEMP_FILE" > ~/.ssh/config
rm -f "$TEMP_FILE"
unset TEMP_FILE
else
echo 'ServerAliveInterval 60' >> ~/.ssh/config
chmod 0600 ~/.ssh/config
fi
echo
fi
;;
esac
fi
fi
unset RESULT
fi
if getent group docker >/dev/null 2>&1; then
if ! id -nG | grep -qw "docker"; then
_warn 'Current user is not in docker group. Run: ~c~sudo usermod -a -G docker %s\n' "$USER"
fi
fi
if [ "$TERM" != "xterm-256color" ] && [ "$TERM" != "tmux-256color" ]; then
unset TERMINFO
_warn 'Unexpected TERM type: "%s"\n' "$TERM"
elif [ ! -e "$(echo "$IAM_HOME/terminfo"/*/xterm-256color)" ]; then
_warn 'Terminfo file "%s" not found. Perhaps the "tic" command does not exist in the environment.\n' "$IAM_HOME/terminfo/*/xterm-256color"
unset TERMINFO
fi
if _has git && _vercomp 1.7.9 '>' "$__GIT_VERSION"; then
_warn 'git v%s is too old and does not support signatures, v1.7.9 or higher is required.\n' "$__GIT_VERSION"
fi
if ! _is in-container; then
SSH_PUB_KEY_ONLY="$(echo "$SSH_PUB_KEY" | awk '{print $2}')"
if [ -z "$SSH_PUB_KEY_ONLY" ]; then
_warn 'SSH key is not defined\n'
else
if [ ! -d ~/.ssh ]; then
mkdir ~/.ssh
chmod 0700 ~/.ssh
fi
if [ ! -f ~/.ssh/authorized_keys ]; then
echo "$SSH_PUB_KEY" > ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
_info 'SSH key installed\n'
elif ! grep "$SSH_PUB_KEY_ONLY" ~/.ssh/authorized_keys >/dev/null 2>&1; then
echo "$SSH_PUB_KEY" >> ~/.ssh/authorized_keys
_info 'SSH key installed\n'
fi
fi
unset SSH_PUB_KEY_ONLY
fi
if [ ! -x "$IAM_HOME/tools/bin/geturl" ]; then
[ -d "$IAM_HOME/tools/bin" ] || mkdir -p "$IAM_HOME/tools/bin"
{
echo '#!/usr/bin/env bash'
declare -f _is _isnot _hash _hash_in _check _has _catch _get_url
echo '_get_url "$@"'
} > "$IAM_HOME/tools/bin/geturl"
chmod +x "$IAM_HOME/tools/bin/geturl"
fi
if _isnot tmux && _isnot in-container; then
! _has_function __gpgconf_validate || __gpgconf_validate
fi
if _isnot tmux; then
if _is wsl; then
if [ ! -f /etc/wsl.conf ] || ! grep -q -E '^options\s*=.*metadata' /etc/wsl.conf; then
_warn 'etc/wsl.conf does not contain "option=metadata" in the section "[autoconf]". This is necessary to preserve the linux permissions on the Windows file system.'
echo "Launch 'sudo vi /etc/wsl.conf' and add the following under the section '[automount]':"
echo "    options = \"metadata,umask=22,fmask=11,case=off\""
echo "Restart WSL after that."
echo
fi
if [ ! -d /usr/bin/windows/System32 ]; then
_warn "/usr/bin/windows/System32 is unavailable. Windows standard exes will not work. Do the following:"
echo "\$ sudo mkdir -p /usr/bin/windows"
echo "\$ sudo vi /etc/fstab"
echo 'c:\\Windows /usr/bin/windows drvfs ro,noatime,metadata 0 0'
echo "\$ sudo vi /etc/wsl.conf"
echo "Make sure that 'mountFsTab = true' exists under the section '[automount]'"
echo
fi
if __RESULT="$(systemctl is-enabled wsl-pro.service 2>&1)" && [ "$__RESULT" = "enabled" ]; then
_warn '~B~%s~d~ is enabled. Run the following command to disable it: ~c~%s' \
"wsl-pro.service" "sudo systemctl disable --now wsl-pro.service"
echo
fi
unset __RESULT
fi
{ # disable messages duing +x
V="$(__magic_ssh)"
} 2>/dev/null
if [ "${#V}" -ge 131072 ]; then
_warn "__magic_ssh() returns a string of length %s, which exceeds the maximum allowed length of 131071.\n" "${#V}"
fi
unset V
tools check quick update
[ -z "$__JUMPLIST_FUNCTIONS_AVAILABLE" ] || j -prompt
if _has tmux; then
if command tmux list-sessions -F '#{session_attached}' 2>/dev/null | grep --silent --fixed-strings '0'; then
cprintf "~K~[~c~TMUX~K~] ~d~Current environment has the following unattached tmux sessions: \"%s\"" \
"$(command tmux list-sessions -F '#{session_attached} #{session_name}' | grep '^0' | sed -E 's/^[[:digit:]][[:space:]]+//' | sed ':a;N;$!ba; s/\n/", "/g')"
cprintf "~K~[~c~TMUX~K~] ~d~Type to attach: tmux attach-session -t <session name>"
fi
fi
if [ -n "$_TERM_SESSION_DIR" ]; then
if [ -r "$_TERM_SESSION_DIR/pwd" ]; then
if [ $(( "$(date +"%s")" - "$(date -r "$_TERM_SESSION_DIR/pwd" +"%s")" )) -gt 259200 ]; then
rm -rf "$_TERM_SESSION_DIR"/*
else
NEW_PWD="$(< "$_TERM_SESSION_DIR/pwd")"
if [ -d "$NEW_PWD" ]; then
cd "$NEW_PWD" || :
else
_warn "previous PWD '%s' is not reachable" "$NEW_PWD"
fi
unset NEW_PWD
fi
fi
[ ! -r "$_TERM_SESSION_DIR/vim" ] || vim
fi
fi
EOF

cat <<'EOF' > "$IAM_HOME/shellrc"
if [ -x /bin/bash ]; then
BASH_BIN=/bin/bash
elif [ -x /usr/bin/bash ]; then
BASH_BIN=/usr/bin/bash
elif [ -x "$IAM_HOME/tools/bin/bash" ]; then
BASH_BIN="$IAM_HOME/tools/bin/bash"
elif ! BASH_BIN="$(command -v bash 2>/dev/null)"; then
unset BASH_BIN
OS="$(uname -o):$(uname -m)"
if [ "$OS" = "GNU/Linux:x86_64" ] || [ "$OS" = "Linux:x86_64" ]; then
[ -d "$IAM_HOME/tools/bin" ] || mkdir -p "$IAM_HOME/tools/bin"
BASH_BIN="$IAM_HOME/tools/bin/bash"
URL="https://github.com/chpock/dotfiles/releases/download/v0.0.0/bash-portable.5.2.21.linux.x86_64"
if command -v curl >/dev/null 2>&1 && curl --silent -L "$URL" -o "$BASH_BIN" >/dev/null 2>&1; then
SUCCESS=1
elif command -v wget >/dev/null 2>&1 && wget -q -O "$BASH_BIN" "$URL" >/dev/null 2>&1; then
SUCCESS=1
elif [ -x /usr/lib/apt/apt-helper ] && /usr/lib/apt/apt-helper -oAcquire::https::Verify-Peer=false download-file "$URL" "$BASH_BIN" >/dev/null 2>&1; then
SUCCESS=1
fi
if [ -z "$SUCCESS" ]; then
rm -f "$BASH_BIN"
unset BASH_BIN
else
chmod +x "$BASH_BIN"
unset SUCCESS
fi
fi
fi
[ -z "$BASH_BIN" ] || exec "$BASH_BIN" --rcfile "$IAM_HOME/bashrc" -i
[ -z "$SHELL" ] || exec "$SHELL" -i
exec /bin/sh -i
EOF
chmod +x "$IAM_HOME/shellrc"

# Magic: try to restore current directory. Only for SSH.
if [ -n "$SSH_CLIENT" ] || [ -n "$WSL_HOST_IP" ]; then
    # get win title
    printf "\033]0;__ti\007"
    read __WIN_TITLE_1
    # cursor up & erase line
    printf "\033[1A\033[K"
    __WIN_TITLE_2="${__WIN_TITLE_1#*KITTYID:}"
    # if KITTEID: found
    if [ "$__WIN_TITLE_1" != "$__WIN_TITLE_2" ]; then
        # strip quote "
        __KITTY_ID="${__WIN_TITLE_2%\"*}"
        export __KITTY_ID
    fi
    unset __WIN_TITLE_1
    unset __WIN_TITLE_2
fi

exec "$IAM_HOME/shellrc"
