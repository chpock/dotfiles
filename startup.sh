IAM="kk" && \
SSH_PUB_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEApJEHtvysrpZeN7xfBS5GY0JjFD8eL5UCYZFbwcUhKXKNXsjtLl9FtwA9sS0cJhqM8CSSGAcceSirACC5L5PSLckeUh2eofYlqJPBkNzU2Uycwc7CSKJRaVTY+yNAJrdpO+7fJPxzis5H3CEB6roguEr+ZqDF9BSEZ0CO8l4wTGgsmqZ2UJuEKfVpPMg6cqGCUj6NvoADavMyrOPRKVCvKikJaWd3NJK4UXueLW0pc/lNoKvbVYRyXO0VruwsAAeciPtn/M1po/iz3+pQW9fk6uM1YContqmR3Ga7TfF249cSyml2gSO8VeNoPbm3RM/KPMZ8F9eyfwQUf6bic2IRoQ== kkushnir" && \
GIT_USER_NAME="Konstantin Kushnir" && \
GIT_USER_EMAIL="chpock@gmail.com" && \
export IAM && \
export SSH_PUB_KEY && \
export GIT_USER_NAME && \
export GIT_USER_EMAIL && \
IAM_HOME="$HOME/.${IAM}_home" && \
export IAM_HOME && \
rm -rf "$HOME/.${IAM}_terminfo" && \
rm -f "$HOME/.${IAM}_startup" && \
if [ ! -d "$IAM_HOME" ]; then mkdir "$IAM_HOME"; fi && \
rm -rf "$IAM_HOME/terminfo" && \
mkdir "$IAM_HOME/terminfo" && \
cat <<'EOF' > "$IAM_HOME/terminfo/.terminfo"
xterm-256color|xterm with 256 colors,
#  auto_right_margin: Terminal has automatic margins
  am,
#  back_color_erase: Screen erased with background colour
  bce,
#  can_change: Terminal can re-define existing colour
  ccc,
#  eat_newline_glitch: Newline ignored after 80 columns (Concept)
  xenl,
#  has_meta_key: Has a meta key (shift, sets parity bit)
  km,
#  has_status_line: Has extra "status line"
  hs,
#  move_insert_mode: Safe to move while in insert mode
  mir,
#  move_standout_mode: Safe to move in standout modes
  msgr,
#  xon_xoff: Terminal uses xon/xoff handshaking
  xon,
#  no_pad_char: Pad character doesn't exist
  npc,
#  prtr_silent: Printer won't echo on screen
  mc5i,
#  init_tabs : Tabs initially every # spaces
  it#8,
#  max_colors : Maximum number of colours on the screen
  colors#256,
#  max_pairs : Maximum number of colour-pairs on the screen
  pairs#32767,
#  acs_chars : Graphic charset pairs aAbBcC
  acsc=``aaffggiijjkkllmmnnooppqqrrssttuuvvwwxxyyzz{{||}}~~,
#  back_tab : Back tab
  cbt=\E[Z,
#  bell : Audible signal (bell)
  bel=^G,
#  carriage_return : Carriage return
  cr=^M,
#  change_scroll_region : Change to lines #1 through #2 (VT100)
  csr=\E[%i%p1%d;%p2%dr,
#  clear_all_tabs : Clear all tab stops
  tbc=\E[3g,
#  clear_screen : Clear screen and home cursor
  clear=\E[H\E[J,
#  clr_bol : Clear to beginning of line, inclusive
  el1=\E[1K,
#  clr_eol : Clear to end of line
  el=\E[K,
#  clr_eos : Clear to end of display
  ed=\E[J,
#  column_address : Set horizontal position to absolute #1
  hpa=\E[%i%p1%dG,
# cursor_address : Move to row #1 col #2
  cup=\E[%i%p1%d;%p2%dH,
# cursor_home : Home cursor (if no cup)
  home=\E[H,
# cursor_invisible : Make cursor invisible
  civis=\E[?25l,
# cursor_left : Move left one space.
  cub1=^H,
# cursor_normal : Make cursor appear normal
  cnorm=\E[34h\E[?25h,
# cursor_down : Down one line
  cud1=\E[B,
# cursor_right : Non-destructive space (cursor or carriage right)
  cuf1=\E[C,
# cursor_up : Upline (cursor up)
  cuu1=\E[A,
# cursor_visible : Make cursor very visible
  cvvis=\E[34l\E[?25h,
# delete_character : Delete character
  dch1=\E[P,
# delete_line : Delete line
  dl1=\E[M,
# dis_status_line : Disable status line
  dsl=\E]0;\007,
# display_pc_char : Display PC character
  dispc=
    %?
      %p1%{8}%=
      %t\E%%G\342\227\230\E%%@
    %e
      %p1%{10}%=
      %t\E%%G\342\227\231\E%%@
    %e
      %p1%{12}%=
      %t\E%%G\342\231\0\E%%@
    %e
      %p1%{13}%=
      %t\E%%G\342\231\252\E%%@
    %e
      %p1%{14}%=
      %t\E%%G\342\231\253\E%%@
    %e
      %p1%{15}%=
      %t\E%%G\342\230\274\E%%@
    %e
      %p1%{27}%=
      %t\E%%G\342\206\220\E%%@
    %e
      %p1%{155}%=
      %t\E%%G\340\202\242\E%%@
    %e
      %p1%c
    %;,
# ena_acs : Enable alternate character set
  enacs=\E(B\E)0,
# enter_alt_charset_mode : Start alternate character set
  smacs=\E(0,
# enter_am_mode : Turn on automatic margins
  smam=\E[?7h,
# enter_blink_mode : Turn on blinking
  blink=\E[5m,
# enter_bold_mode : Turn on bold (extra bright) mode
  bold=\E[1m,
# enter_ca_mode : String to begin programs that use cup
  smcup=\E[?1049h,
# enter_doublewide_mode : Enable double wide printing
  swidm=\E#6,
# enter_insert_mode : Insert mode (enter)
  smir=\E[4h,
# enter_pc_charset_mode : Enter PC character display mode
  smpch=\E[11m,
# enter_reverse_mode : Turn on reverse video mode
  rev=\E[7m,
# enter_standout_mode : Begin standout mode
  smso=\E[7m,
# enter_underline_mode : Start underscore mode
  smul=\E[4m,
# erase_chars : Erase #1 characters
  ech=\E[%p1%dX,
# exit_alt_charset_mode : End alternate character set
  rmacs=\E(B,
# exit_am_mode : Turn off automatic margins
  rmam=\E[?7l,
# exit_attribute_mode : Turn off all attributes
  sgr0=\E[m\E(B,
# exit_ca_mode : String to end programs that use cup
  rmcup=\E[?1049l,
# exit_insert_mode : End insert mode
  rmir=\E[4l,
# exit_pc_charset_mode : Disable PC character display mode
  rmpch=\E[10m,
# exit_standout_mode : End standout mode
  rmso=\E[27m,
# exit_underline_mode : End underscore mode
  rmul=\E[24m,
# flash_screen : Visible bell (may move cursor)
  flash=\E[?5h$<100/>\E[?5l,
# from_status_line : Return from status line
  fsl=^G,
# init_2string : Terminal or printer initialisation string
  is2=\E[34h\E[?25h\E[4l\E[?7h\E[?1;4;6;1047l\E[2J\E[H\E>\E[r\E[m\E]R\E[?1000l\E[?1002l,
# initialize_color : Set colour #1 to RGB #2, #3, #4
  initc@,
# insert_character : Insert character
  ich1=\E[@,
# insert_line : Add new blank line
  il1=\E[L,
# key_a1 : upper left of keypad
  ka1=\EOw,
# key_a3 : upper right of keypad
  ka3=\EOy,
# key_b2 : center of keypad
  kb2=\EOu,
# key_c1 : lower left of keypad
  kc1=\EOq,
# key_c3 : lower right of keypad
  kc3=\EOs,
# key_backspace : sent by backspace key
  kbs=\177,
# key_btab : sent by back-tab key
  kcbt=\E[Z,
# key_dc : sent by delete-character key
  kdch1=\E[3~,
# key_end : 7
  kend=\E[4~,
# key_enter : 8
  kent=\EOM,
# key_fX : sent by function key f0..63
  kf1=\E[11~,
  kf2=\E[12~,
  kf3=\E[13~,
  kf4=\E[14~,
  kf5=\E[15~,
  kf6=\E[17~,
  kf7=\E[18~,
  kf8=\E[19~,
  kf9=\E[20~,
  kf10=\E[21~,
  kf11=\E[23~,
  kf12=\E[24~,
  kf13=\E[25~,
  kf14=\E[26~,
  kf15=\E[28~,
  kf16=\E[29~,
  kf17=\E[31~,
  kf18=\E[32~,
  kf19=\E[33~,
  kf20=\E[34~,
  kf21=\E[20;2~,
  kf22=\E[21;2~,
  kf23=\E[23;2~,
  kf24=\E[24;2~,
  kf25=\EO5P,
  kf26=\EO5Q,
  kf27=\EO5R,
  kf28=\EO5S,
  kf29=\E[15;5~,
  kf30=\E[17;5~,
  kf31=\E[18;5~,
  kf32=\E[19;5~,
  kf33=\E[20;5~,
  kf34=\E[21;5~,
  kf35=\E[23;5~,
  kf36=\E[24;5~,
  kf37=\EO6P,
  kf38=\EO6Q,
  kf39=\EO6R,
  kf40=\EO6S,
  kf41=\E[15;6~,
  kf42=\E[17;6~,
  kf43=\E[18;6~,
  kf44=\E[19;6~,
  kf45=\E[20;6~,
  kf46=\E[21;6~,
  kf47=\E[23;6~,
  kf48=\E[24;6~,
  kf49=\EO3P,
  kf50=\EO3Q,
  kf51=\EO3R,
  kf52=\EO3S,
  kf53=\E[15;3~,
  kf54=\E[17;3~,
  kf55=\E[18;3~,
  kf56=\E[19;3~,
  kf57=\E[20;3~,
  kf58=\E[21;3~,
  kf59=\E[23;3~,
  kf60=\E[24;3~,
  kf61=\EO4P,
  kf62=\EO4Q,
  kf63=\EO4R,
# key_home : sent by home key
  khome=\E[1~,
# key_ic : sent by ins-char/enter ins-mode key
  kich1=\E[2~,
################## key_left, key_right, key_up, key_down were \E[D,\E[C,\E[A,\E[B
################## and they are correct codes from putty
################## but they don't work with some ncurses apps
################## so, I changed them to \EOD,\EOC,\EOA,\EOB
# key_left : sent by terminal left-arrow key
  kcub1=\EOD,
# key_right : sent by terminal right-arrow key
  kcuf1=\EOC,
# key_up : sent by terminal up-arrow key
  kcuu1=\EOA,
# key_down : sent by terminal down-arrow key
  kcud1=\EOB,
# key_mouse : 0631, Mouse event has occured
  kmous=\E[M,
# key_npage : sent by next-page key
  knp=\E[6~,
# key_ppage : sent by previous-page key
  kpp=\E[5~,
# keypad_local : Out of "keypad-transmit" mode
  rmkx=\E[?1l\E>,
# keypad_xmit : Put terminal in "keypad-transmit" mode
  smkx=\E[?1h\E=,
# orig_colors : Set all colour(-pair)s to the original ones
  oc=\E]R,
# orig_pair : Set default colour-pair to the original one
  op=\E[39;49m,
# parm_dch : Delete #1 chars
  dch=\E[%p1%dP,
# parm_delete_line : Delete #1 lines
  dl=\E[%p1%dM,
# parm_down_cursor : Move down #1 lines.
  cud=\E[%p1%dB,
# parm_ich : Insert #1 blank chars
  ich=\E[%p1%d@,
# parm_index : Scroll forward #1 lines.
  indn=\E[%p1%dS,
# parm_insert_line : Add #1 new blank lines
  il=\E[%p1%dL,
# parm_left_cursor : Move cursor left #1 spaces
  cub=\E[%p1%dD,
# parm_right_cursor : Move right #1 spaces.
  cuf=\E[%p1%dC,
# parm_rindex : Scroll backward #1 lines.
  rin=\E[%p1%dT,
# parm_up_cursor : Move cursor up #1 lines.
  cuu=\E[%p1%dA,
# print_screen : Print contents of the screen
  mc0=\E[i,
# prtr_off : Turn off the printer
  mc4=\E[4i,
# prtr_on : Turn on the printer
  mc5=\E[5i,
# reset_1string : Reset terminal completely to sane modes
  rs1=\Ec,
# reset_2string : Reset terminal completely to sane modes
  rs2=\E<\E["p\E[50;6"p\Ec\E[?3l\E]R\E[?1000l,
# restore_cursor : Restore cursor to position of last sc
  rc=\E8,
# row_address : Set vertical position to absolute #1
  vpa=\E[%i%p1%dd,
# save_cursor : Save cursor position
  sc=\E7,
# scroll_forward : Scroll text up
  ind=^J,
# scroll_reverse : Scroll text down
  ri=\EM,
# set0_des_seq : Shift into codeset 0 (EUC set 0, ASCII)
  s0ds=\E[10m,
# set1_des_seq : Shift into codeset 1
  s1ds=\E[11m,
# set2_des_seq : Shift into codeset 2
  s2ds=\E[12m,
# set_a_background : Set background colour to #1 using ANSI escape
  setab=\E[
    %?
      %p1%{8}%<
      %t4%p1%d
    %e
      %p1%{16}%<
      %t10%p1%{8}%-%d
    %e48;5;
      %p1%d
    %;
    m,
# set_a_foreground : Set foreground colour to #1 using ANSI escape
  setaf=\E[
    %?
      %p1%{8}%<
      %t3%p1%d
    %e
      %p1%{16}%<
      %t9%p1%{8}%-%d
    %e38;5;
      %p1%d
    %;
    m,
# set_attributes : Define first set of video attributes #1-#9
  sgr=\E[0
    %?
      %p1%p6%|
      %t;1
    %;
    %?
      %p2
      %t;4
    %;
    %?
      %p1%p3%|
      %t;7
    %;
    %?
      %p4
      %t;5
    %;
    m
    %?
      %p9
      %t\016
    %e
      \017
    %;,
# set_tab : Set a tab in all rows, current column
  hts=\EH,
# tab : Tab to next 8-space hardware tab stop
  ht=^I,
# to_status_line : Go to status line, col #1
  tsl=\E]0;,
# userX : User string 0..9
  u6=\E[%i%d;%dR,
  u7=\E[6n,
  u8=\E[?6c,
  u9=\E[c,
EOF

TERMINFO="$IAM_HOME/terminfo"
export TERMINFO
tic "$IAM_HOME/terminfo/.terminfo"

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

cat <<EOF > "$IAM_HOME/gitconfig"
[user]
  name = $GIT_USER_NAME
  email = $GIT_USER_EMAIL
[core]
  editor = vim
  autocrlf = false
[color]
  ui = auto
EOF

cat <<'EOF' > "$IAM_HOME/vimrc"
set nocompatible
set t_Co=256           " enable 256 colors
set nowrap             " don't wrap lines
set tabstop=4          " a tab is four spaces
set backspace=indent,eol,start
                       " allow backspacing over everything in insert mode
set autoindent         " always set autoindenting on
set copyindent         " copy the previous indentation on autoindenting
set number             " always show line numbers
set shiftwidth=4       " number of spaces to use for autoindenting
set shiftround         " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch          " set show matching parenthesis
set matchtime=3        " for 3 tenths of a second (mat)
set ignorecase         " ignore case when searching
set smartcase          " ignore case if search pattern is all lowercase,
                       "    case-sensitive otherwise
set smarttab           " insert tabs on the start of a line according to
                       "    shiftwidth
set expandtab          " insert space characters whenever the tab key is pressed

set hlsearch           " highlight search terms
set incsearch          " show search matches as you type

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

set history=1000       " remember more commands and search history
set undolevels=1000    " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set notitle            " don't change the terminal's title
set visualbell         " don't beep
set noerrorbells       " don't beep

set noshowmode         " don't display the current mode (-- INSERT --)
                       " status line is used instead
set ruler              " show the cursor position always (ru)
set laststatus=2       " always display status line

if version >= 600
    filetype plugin indent on
else
    filetype on
endif

set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.
if has("autocmd")
    autocmd filetype html,xml set listchars-=tab:>.
endif

nnoremap <silent> <special> <F2> :set invpaste invnumber invlist<CR>
inoremap <silent> <special> <F2> <C-O>:set invpaste invnumber invlist<CR>
set pastetoggle=<F2>

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif

" Always show at least one line above/below the cursor
if !&scrolloff
  set scrolloff=1
endif
if !&sidescrolloff
  set sidescrolloff=5
endif
set display+=lastline

" Q command to exit
command! Q :q
command! Wq :wq
command! Wqa :wqa

" Status line
" set statusline=%<%f\ %h%m%r%=%-20.(line=%l,col=%c%V,totlin=%L%)\%h%m%r%=%-40(,bytval=0x%B,%n%Y%)\%P
" set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set statusline=
set statusline+=%#DiffAdd#%{(mode()=='n')?'\ \ NORMAL\ ':''}
set statusline+=%#DiffChange#%{(mode()=='i')?'\ \ INSERT\ ':''}
set statusline+=%#DiffDelete#%{(mode()=='r')?'\ \ RPLACE\ ':''}
set statusline+=%#Cursor#%{(mode()=='v')?'\ \ VISUAL\ ':''}
set statusline+=\ %n\                               " buffer number
set statusline+=%#Visual#                           " colour
set statusline+=%{&paste?'\ PASTE\ ':''}
set statusline+=%{&spell?'\ SPELL\ ':''}
set statusline+=%#CursorIM#                         " colour
set statusline+=%R                                  " readonly flag
set statusline+=%M                                  " modified [+] flag
set statusline+=%#Cursor#                           " colour
set statusline+=%#CursorLine#                       " colour
set statusline+=\ %t\                               " short file name
set statusline+=%=                                  " right align
set statusline+=%#CursorLine#   " colour
set statusline+=\ [FileType:%Y]\                    " file type
set statusline+=%#CursorIM#     " colour
set statusline+=\ [Line:%-3l\ Column:%-3c]\         " line + column
set statusline+=%#Cursor#       " colour
set statusline+=\ %3p%%\                            " percentage

" Monokai theme
set background=dark
highlight clear

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

" hi Comment cterm=italic
" hi Folded cterm=italic
" hi SpellBad cterm=italic,underline
" hi SpellCap cterm=italic,underline
" hi SpellLocal cterm=italic,underline
" hi SpellRare cterm=italic,underline
" hi Todo cterm=italic

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

nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" go to the position I was when last editing the file
" based on: https://github.com/farmergreg/vim-lastplace
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
au! BufWinEnter * call <SID>lastplace()

" Special file types

" YAML
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
" disable auto ident for keys: ':', '-', '#', '}', ']'
au! FileType yaml setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=0#,0},0],<:>,-

EOF

cat <<'EOF' > "$IAM_HOME/bashrc"

#if [ -f ~/.profile ]; then
#    . ~/.profile
#fi

COLOR_WHITE=$'\e[1;37m'
COLOR_LIGHTGRAY=$'\e[0;37m'
COLOR_GRAY=$'\e[1;30m'
COLOR_BLACK=$'\e[0;30m'
COLOR_RED=$'\e[0;31m'
COLOR_LIGHTRED=$'\e[1;31m'
COLOR_GREEN=$'\e[0;32m'
COLOR_LIGHTGREEN=$'\e[1;32m'
COLOR_BROWN=$'\e[0;33m'
COLOR_YELLOW=$'\e[1;33m'
COLOR_BLUE=$'\e[0;34m'
COLOR_LIGHTBLUE=$'\e[1;34m'
COLOR_PURPLE=$'\e[0;35m'
COLOR_PINK=$'\e[1;35m'
COLOR_CYAN=$'\e[0;36m'
COLOR_LIGHTCYAN=$'\e[1;36m'
COLOR_DEFAULT=$'\e[0m'
COLOR_BOLD=$'\e[1m'

COLOR_ERROR=$'\e[41m\e[1m\e[97m'
COLOR_SIGN=$'\e[38;5;136m'

case `uname -s` in
    AIX)
        # Insert path to GNU utilities for AIX platform
        PATH="/opt/freeware/bin:$PATH"
        export PATH
    ;;
    SunOS)
        # Insert path to GNU utilities for Solaris platform
        PATH="/usr/xpg4/bin:$PATH"
        export PATH
    ;;
    Linux)
        # "stat -c" is used to detect a zombie directories
        MY_STATC="stat -c"
    ;;
esac

hostinfo() {

    MSHELL_L="unknown"
    MSHELL="unknown"

    case $BASH_VERSION in *.*) { MSHELL_L="bash $BASH_VERSION";MSHELL="bash";};;esac
    case $ZSH_VERSION  in *.*) { MSHELL_L="zsh $ZSH_VERSION";MSHELL="zsh";};;esac
    case "$VERSION" in *zsh*) { MSHELL_L="$VERSION";MSHELL="zsh";};;esac
    case "$SH_VERSION" in *PD*) { MSHELL_L="$SH_VERSION";MSHELL="sh";};;esac
    case "$KSH_VERSION" in *PD*|*MIRBSD*) { MSHELL_L="$KSH_VERSION";MSHELL="ksh";};;esac
    case "$POSH_VERSION" in *.*|*POSH*) { MSHELL_L="posh $POSH_VERSION";MSHELL="posh";};; esac
    case $YASH_VERSION in *.*) { MSHELL_L="yash $YASH_VERSION";MSHELL="yash";};;esac

    UNAME_MACHINE=`(uname -m) 2>/dev/null` ||\
    UNAME_MACHINE=`(uname -p) 2>/dev/null` ||\
    UNAME_MACHINE='unknown'
    UNAME_SYSTEM=`(uname -s) 2>/dev/null`  ||\
    UNAME_SYSTEM='unknown'
    UNAME_RELEASE=`(uname -r) 2>/dev/null` ||\
    UNAME_RELEASE=`(uname -v) 2>/dev/null` ||\
    UNAME_RELEASE='unknown'

    UNAME="${UNAME_MACHINE}:${UNAME_SYSTEM}:${UNAME_RELEASE}"

    case "${UNAME}" in
        *Linux:* )
            # Linux
            if [ -f /etc/redhat-release ]; then
                # RedHat
                UNAME_RELEASE="`cat /etc/redhat-release`"
            elif [ -f /etc/SuSE-release ]; then
                # SUSE
                UNAME_RELEASE="SUSE Linux Enterprise Server `grep VERSION /etc/SuSE-release | cut -d= -f2 | awk '{print $1}'` SP`grep PATCHLEVEL /etc/SuSE-release | cut -d= -f2 | awk '{print $1}'`"
            elif [ -f /etc/lsb-release ]; then
                # Linux standard base, grep&sed in the box
                # * Ubuntu
                UNAME_RELEASE=`grep DISTRIB_DESCRIPTION= /etc/lsb-release | sed 's/DISTRIB_DESCRIPTION\s*=\s*"//' | sed 's/""*$//'`
            else
                # Linux, unknown distr
                UNAME_RELEASE="Linux, unknown distributive"
            fi
            case "$UNAME_MACHINE" in
                x86_64 )
                    UNAME_MACHINE="Intel x86-64";;
                i386 )
                    UNAME_MACHINE="Intel x86";;
            esac
        ;;
        *:AIX:* )
            # AIX
            UNAME_MACHINE="`lsattr -El proc0 -a type | cut -d ' ' -f 2` (`prtconf -c`; `prtconf -k`)"
            UNAME_RELEASE="AIX v`oslevel`"
        ;;
        *:Darwin:* )
            # MacOS
            UNAME_RELEASE="`sw_vers -productName` `sw_vers -productVersion`"
            case "$UNAME_MACHINE" in
                i386 )
                    UNAME_MACHINE="Intel x86";;
                x86-64 )
                    UNAME_MACHINE="Intel x86-64";;
                ppc )
                    UNAME_MACHINE="PowerPC";;
                ppc64 )
                    UNAME_MACHINE="PowerPC-64";;
            esac
            UNAME_MACHINE="$UNAME_MACHINE (Kernel Type: `getconf LONG_BIT`-bit)"
        ;;
        *:CYGWIN*:* )
            # Cygwin on Windows
            UNAME_RELEASE="`/usr/lib/csih/winProductName.exe`"
            case "$UNAME_MACHINE" in
                x86_64 )
                    UNAME_MACHINE="Intel x86-64";;
                i386 )
                    UNAME_MACHINE="Intel x86";;
            esac
        ;;
        *:HP-UX:* )
            # HP-UX
            UNAME_MACHINE="`model | sed -e 's/[[:space:]]*$//'` (CPU Type: `getconf HW_CPU_SUPP_BITS`-bit; Kernel Type: `getconf KERNEL_BITS`-bit)"
            UNAME_RELEASE="HP-UX $UNAME_RELEASE"
        ;;
        *:SunOS:* )
            # Solaris
            UNAME_RELEASE="`head -n 1 /etc/release | sed 's/^ *//'`"
            TMPARCH="`isainfo -kv | cut -d ' ' -f 2`"
            case "$TMPARCH" in
                i386 )
                    UNAME_MACHINE="Intel x86";;
                amd64 )
                    UNAME_MACHINE="Intel x86-64";;
                sparc* )
                    UNAME_MACHINE="SPARC ${TMPARCH:5}";;
            esac
            unset TMPARCH
            UNAME_MACHINE="$UNAME_MACHINE (Kernel Type: `isainfo -b`-bit)"
        ;;
        * )
            # Undetectable
        ;;
    esac

    printf -- "\n------------------------------------------------------------------------------\n"
    printf -- "Hostname  : %s\n" "`hostname`"
    printf -- "Kernel    : %s\n" "`uname -a`"
    printf -- "Machine   : %s\n" "$UNAME_MACHINE"
    printf -- "Release   : %s\n" "$UNAME_RELEASE"
    printf -- "------------------------------------------------------------------------[ OS ]--\n"


    case "${UNAME}" in
        *Linux:*|*:Darwin:*|*:SunOS:* )
            # https://stackoverflow.com/questions/13322485/how-to-get-the-primary-ip-address-of-the-local-machine-on-linux-and-os-x
            int2ip() {
                # avoid overflow in bash math
#               _a=$(echo "$1 / 2^16" | bc)
#               printf "%d.%d.%d.%d" $(($_a>>8&255)) $(($_a&255)) $(($1>>8&255)) $(($1&255))
                printf "%d.%d.%d.%d" $(($1>>24)) $(($1>>16&255)) $(($1>>8&255)) $(($1&255))
            }
            ip2int() {
                _a=(${1//./ })
                printf "%u" $(( _a<<24 | ${_a[1]} << 16 | ${_a[2]} << 8 | ${_a[3]} ))
            }

            runOnMac=0
            while IFS=$' :\t\r\n' read a b c d; do
                [ "$a" = "usage" ] && [ "$b" = "route" ] && runOnMac=1
                if [ "x$runOnMac" = "x1" ]; then
                    case $a in
                        gateway )    gWay=$b  ;;
                        interface )  iFace=$b ;;
                    esac
                else
                    [ "$a" = "0.0.0.0" ] && [ "$c" = "$a" ] && iFace=${d##* } gWay=$b
                fi
            done < <(/sbin/route -n 2>&1 || /sbin/route -n get 0.0.0.0/0 2>&1 || true)

            [ -z "$gWay" ] && gw=0 || gw=$(ip2int $gWay)

            while read lhs rhs; do
                [ "$lhs" ] && {
                    [ "x$lhs" != "xinet" ] && [ "x$lhs" != "xinet6" ] && iface="$lhs"
                    [ -z "${lhs#*:}" ] && iface=${lhs%:}
                    [ "x$lhs" = "xinet" ] && {
                        mask=${rhs#*netmask }
                        mask=${mask#*Mask:}
                        mask=${mask%% *}
                        case "$mask" in
                            0x*) mask="$(printf %u $mask)"; ;;
                            f*)  mask="$(printf %u 0x$mask)"; ;;
                            *)   mask="$(ip2int $mask)"; ;;
                        esac
                        myIp=${rhs%% *}
                        myIp=${myIp#*addr:}
                        ip=$(ip2int $myIp)
                        netMask=$(int2ip $mask)
                        (( ( ip & mask ) == ( gw & mask ) )) && myGway=", gw: $gWay" || myGway=
                        [ "x$myIp" != "x127.0.0.1" ] && \
                            printf -- "Interface : %s (name: '%s', mask: %s%s)\n" "$myIp" "$iface" "$netMask" "$myGway"
                    }
                }
            done < <(/sbin/ifconfig 2>&1 || /sbin/ifconfig -a)

            printf -- "-------------------------------------------------------------------[ Network ]--\n"
        ;;
    esac

    local MEM_TOTAL
    local MEM_FREE
    local SWAP_TOTAL
    local SWAP_FREE

    if [ -f /proc/meminfo ]; then

        local _buffers=0
        local _cached=0
        local _memTotal
        local _memFree
        local _swapTotal
        local _swapFree

        while IFS=$' :\t\r\n' read a b c; do
            case "$a" in
                MemTotal)
                    _memTotal="$b"
                ;;
                MemFree)
                    _memFree="$b"
                ;;
                Buffers)
                    _buffers="$b"
                ;;
                Cached)
                    _cached="$b"
                ;;
                SwapTotal)
                    _swapTotal="$b"
                ;;
                SwapFree)
                    _swapFree="$b"
                ;;
            esac
        done < /proc/meminfo

        MEM_TOTAL=$(( $_memTotal / 1024 ))
        MEM_FREE=$(( ($_memFree + $_buffers + $_cached) / 1024 ))
        SWAP_TOTAL=$(( $_swapTotal / 1024 ))
        SWAP_FREE=$(( $_swapFree / 1024 ))

    else
        MEM_TOTAL=""
    fi

    _showinfo() {
        # $1 - info type
        # $2 - total
        # $3 - free
        # $4 - additional info

        local infoType="$1"
        local total="$2"
        local free="$3"
        local add="$4"

        gauge() {
            # $1 - total
            # $2 - free
            # $3 - color
            local PRC1
            local PRC2
            PRC1=$(( 100 - 100 * ($1 - $2) / $1 ))
            PRC2=$(( $PRC1 / 4 ))
            PRC2="$(printf "%${PRC2}s")"
            PRC2="${PRC2// /=}"
            if [ "$PRC1" != '100' ]; then
                PRC1=$(printf '%02d' "$PRC1")
            fi
            printf "${COLOR_GRAY}[${COLOR_BLUE}%-25s${COLOR_GRAY}]${COLOR_DEFAULT} ${3}%3s%%${COLOR_DEFAULT}" "$PRC2" "$PRC1"
        }

        local color="$(( 100 - 100 * ($total - $free) / $total ))"

        if [ $color -gt 19 ]; then
            color="${COLOR_GREEN}"
        elif [ $color -gt 9 ]; then
            color="${COLOR_YELLOW}"
        else
            color="${COLOR_LIGHTRED}"
        fi

        local gauge=$(gauge $total $free $color)

        local units="MB"
        if [ "$total" -gt 1022976 ]; then
            total="$(( 100 * $total / 1024 / 1024 ))e-2"
            free="$(( 100 * $free / 1024 / 1024 ))e-2"
            units="TB"
        elif [ "$total" -gt 999 ]; then
            total="$(( 100 * $total / 1024 ))e-2"
            free="$(( 100 * $free / 1024 ))e-2"
            units="GB"
        else
            total="$(( 100 * $total ))e-2"
            free="$(( 100 * $free ))e-2"
        fi

        total="$(printf '%.2f %s' "$total" "$units")"
        free="$(printf '%.2f %s' "$free" "$units")"

        if [ -n "$add" ]; then
            add="  ${COLOR_WHITE}$add${COLOR_DEFAULT}"
        fi

        printf -- "%-9s : Free ${color}%9s${COLOR_DEFAULT} of %9s %s%s\n" "$infoType" "$free" "$total" "$gauge" "$add"

    }

    if [ -n "$MEM_TOTAL" ]; then

        _showinfo "RAM" "$MEM_TOTAL" "$MEM_FREE"

        if [ $SWAP_TOTAL -eq 0 ]; then

            printf -- "Swap      : %s\n" "${COLOR_BROWN}Not installed${COLOR_DEFAULT}"

        else

            _showinfo "Swap" "$SWAP_TOTAL" "$SWAP_FREE"

        fi

        printf -- "--------------------------------------------------------------------[ Memory ]--\n"

    fi

    case "${UNAME}" in
        *Linux:*)
            while IFS=$' \t\r\n' read a b c d e f; do

                [ "$f" = "/dev/shm" ] && continue
                [ "$f" = "/dev" ]     && continue
                [ "$f" = "/run" ]     && continue
                [ "$f" = "/boot" ]    && continue
                [ "${f:0:5}" = "/sys/" ] && continue
                [ "${f:0:5}" = "/run/" ] && continue

                _showinfo "Mount" "$b" "$d" "$f"

            done < <(df -m -P | tail -n +2)
        ;;
        *:Darwin:*)
            while IFS=$' \t\r\n' read a b c d e f; do
                _showinfo "Mount" "$b" "$d" "$f"
            done < <(df -m | tail -n +2 | grep -v -E ' +0 +0 +0 +100%')
        ;;
        *:SunOS:*)
            while IFS=$' \t\r\n' read a b c d e f; do

                [ "$f" = "/var/run" ] && continue
                [ "$f" = "/etc/svc/volatile" ] && continue
                [ "$f" = "/lib/libc.so.1" ]  && continue

                b="$(( $b / 1024 ))"
                d="$(( $d / 1024 ))"
                _showinfo "Mount" "$b" "$d" "$f"

            done < <(df -k -t | tail -n +2 | grep -v -E ' +0 +0 +0 +0%')
        ;;
        *:HP-UX:*)
            while IFS=$' \t\r\n' read a b c d e f; do

                b="$(( $b / 1024 ))"
                d="$(( $d / 1024 ))"
                _showinfo "Mount" "$b" "$d" "$f"

            done < <(df -P -k | tail -n +2)
        ;;
        *:AIX:*)
            while IFS=$' \t\r\n' read a b c d e f; do

                _showinfo "Mount" "$b" "$d" "$f"

            done < <(df -m -P | tail -n +2 | grep -v -E ' +- +- +0 +-')
        ;;
        *:CYGWIN*:*)
            while IFS=$' ,\t\r\n' read a b c d; do

                [ -z "$c" ] && continue

                b="$(( $b / 1024 / 1024 ))"
                c="$(( $c / 1024 / 1024 ))"

                _showinfo "Mount" "$c" "$b" "$a"

            done < <(wmic logicaldisk get Caption,FreeSpace,Size | tail -n +2)
        ;;
    esac

    printf -- "----------------------------------------------------------------[ Filesystem ]--\n"

    printf -- "Username  : %s\n" "$USER"
    printf -- "Shell     : %s\n" "$MSHELL_L"
    printf -- "----------------------------------------------------------------------[ User ]--\n\n"
    unset MSHELL_L
    unset UNAME
    unset UNAME_MACHINE
    unset UNAME_SYSTEM
    unset UNAME_RELEASE

}

hostinfo

mkdir -p "$IAM_HOME/state"

KUBECONFIG="$IAM_HOME/kubeconfig"
export KUBECONFIG

GIT_CONFIG="$IAM_HOME/gitconfig"
export GIT_CONFIG
unset GIT_USER_NAME
unset GIT_USER_EMAIL

# Don't want my shell to warn me of incoming mail.
unset MAILCHECK

# Shell options
# notify - Notify when jobs running in background terminate
set -o notify
# cdspell - If set, minor errors in the spelling of a directory component in a cd command will be corrected.
shopt -s cdspell
# dirspell - If set, Bash attempts spelling correction on directory names during word completion if the directory name initially supplied does not exist.
shopt -s dirspell 2>/dev/null || echo "FYI: 'dirspell' bash option is not supported."
# checkwinsize - If set, Bash checks the window size after each command and, if necessary, updates the values of LINES and COLUMNS.
shopt -s checkwinsize
# cmdhist - If set, Bash attempts to save all lines of a multiple-line command in the same history entry. This allows easy re-editing of multi-line commands.
shopt -s cmdhist
# mailwarn - If set, and a file that Bash is checking for mail has been accessed since the last time it was checked, the message "The mail in mailfile has been read" is displayed.
shopt -u mailwarn

# Readline options
# show-all-if-ambiguous - words which have more than one possible completion cause the matches to be listed immediately instead of ringing the bell
bind "set show-all-if-ambiguous on"
# add colors
bind "set colored-completion-prefix on"
bind "set colored-stats on"
# mark-directories - if set to `on', completed directory names have a slash appended.
bind "set mark-directories on"
# mark-symlinked-directories - if set to `on', completed names which are symbolic links to directories have a slash appended
bind "set mark-symlinked-directories on"
# visible-stats - If set to `on', a character denoting a file's type is appended to the filename when listing possible completions.
bind "set visible-stats on"
# enable blink on parens match
bind "set blink-matching-paren on"
# turn off the use of the internal pager when returning long completion lists
bind "set page-completions off"

# How to find out keys:
# 1. run "od -c"
# 2. press key
# 3. press <enter>
# 4. press <ctrl-d>

# bind arrow keys to search in history
#bind '"\e[A": history-search-backward'
#bind '"\e[B": history-search-forward'
# ctrl+arrow_left/arrow_right - word backward/word forward
bind '"\e[1;5D": backward-word'
bind '"\e[1;5C": forward-word'

# 'ls' alias
LS='ls -F -l'
ls --color=auto / >/dev/null 2>&1 && LS="$LS --color=auto"
ls -h / >/dev/null 2>&1 && LS="$LS -h"
ls --group-directories-first / >/dev/null 2>&1 && LS="$LS --group-directories-first"
alias ls=$LS
unset LS

# 'psa' alias
ps --version >/dev/null 2>&1 && PSA='ps aux' || PSA='ps -e -f'
alias psa=$PSA
unset PSA

# 'psaf' alias
ps --version >/dev/null 2>&1 && PSAF='ps auxf' || PSAF='ps -e -f'
alias psaf=$PSAF
unset PSAF

# 'grep' alias
echo|grep --color=auto '' >/dev/null 2>&1 && GREP='grep --color=auto' || GREP='grep'
alias grep=$GREP
unset GREP

#Only for 3.4+ version, I don't have such hosts to test alias
#alias diff='diff --color=auto'

alias mv='mv -i'

alias mkdir='mkdir -p'
alias mkcd='_(){ mkdir -p $1; cd $1; }; _'

alias ..='cd ..'

alias tailf='tail -F'

alias ff='find . -name'

VIM="vim -u \"$IAM_HOME/vimrc\" -i \"$IAM_HOME/viminfo\""
if command -v vim >/dev/null; then
    EDITOR="$VIM"
    alias vi=$VIM
    alias vim=$VIM
elif command -v vi >/dev/null; then
    EDITOR=vi
else
    echo "${COLOR_RED}Warning: vi/vim not found${COLOR_DEFAULT}"
fi
export EDITOR
unset VIM

apt-get() {
    echo "${COLOR_RED}The 'sudo' prefix was added automatically for the 'apt-get' command${COLOR_DEFAULT}" >&2
    sudo apt-get "$@"
}

apt() {
    case "$1" in
        install|remove|purge|autoremove|update|upgrade|full-upgrade|edit-sources)
            echo "${COLOR_RED}The 'sudo' prefix was added automatically for the 'apt' command${COLOR_DEFAULT}" >&2
            sudo apt "$@"
        ;;
        *) command apt "$@"
        ;;
    esac
}

lastbuild() {
    if [ -z "$1" ] || [ "$1" = "common64" ] || [ "$1" = "common" ]; then
        BLD="`/bin/ls -t -1 /net/chronic3build/commander-git-main-full-*/out/x86_64_Linux/nimbus/install/CloudBeesFlow-x64-* | head -1`"
    elif [ "$1" = "common32" ]; then
        BLD="`/bin/ls -t -1 /net/chronic3build/commander-git-main-full-*/out/i686_Linux/nimbus/install/CloudBeesFlow-* | head -1`"
    elif [ "$1" = "agent32" ]; then
        BLD="`/bin/ls -t -1 /net/chronic3build/commander-git-main-full-*/out/i686_Linux/nimbus/install/CloudBeesFlowAgent-x86-* | head -1`"
    elif [ "$1" = "agent64" ]; then
        BLD="`/bin/ls -t -1 /net/chronic3build/commander-git-main-full-*/out/i686_Linux/nimbus/install/CloudBeesFlowAgent-x64-* | head -1`"
    elif [ "$1" = "agent64p" ] || [ "$1" = "agent" ]; then
        BLD="`/bin/ls -t -1 /net/chronic3build/commander-git-main-full-*/out/x86_64_Linux/nimbus/install/CloudBeesFlowAgent-x64-* | head -1`"
    elif [ "$1" = "dois" ]; then
        BLD="`/bin/ls -t -1 /net/chronic3build/commander-git-main-full-*/out/i686_Linux/nimbus/install/CloudBeesFlowDevOpsInsightServer-x64-* | head -1`"
    elif [ "$1" = "dofs" ]; then
        BLD="`/bin/ls -t -1 /net/chronic3build/commander-git-main-full-*/out/x86_64_Linux/nimbus/install/CloudBeesFlowDevOpsForesightServer-x64-* | head -1`"
    else
        echo 'Usage: lastbuild [common|common32|agent|agent32|agent64|agent64p|dois|dofs]' >&2
        exit 1
    fi
    echo "Using build: `echo "$BLD" | cut -d/ -f4`" >&2
    echo "File: `basename "$BLD"`" >&2
    echo "$BLD"
}

kube() {

    local __K8S_CONF

    if [ -n "$1" ] && [ "$__K8S_NOT_AVAILABLE" != 0 ]; then
        echo "${COLOR_RED}ERROR${COLOR_GRAY}:$COLOR_DEFAULT kubectl command is not available in this environment"
        return 1
    fi

    case "$1" in
        on)
            touch "$IAM_HOME/state/on_kube"
        ;;
        off)
            rm -f "$IAM_HOME/state/on_kube"
        ;;
        conf)
            if [ -z "$2" ]; then
                echo "${COLOR_RED}ERROR${COLOR_GRAY}:$COLOR_DEFAULT the kubeconfig is not specified"
                echo
                echo "Usage: kube conf <kubeconfig file>"
                return 1
            fi
            __K8S_CONF="$2"
            if [ "${DIR:0:1}" != "/" ]; then
                __K8S_CONF="$PWD/$__K8S_CONF"
            fi
            if [ ! -f "$__K8S_CONF" ]; then
                echo "${COLOR_RED}ERROR${COLOR_GRAY}:$COLOR_DEFAULT the specified kubeconfig file doesn't exist: '$__K8S_CONF'"
                echo
                echo "Usage: kube conf <kubeconfig file>"
                return 1
            fi
            export KUBECONFIG="$__K8S_CONF"
        ;;
        ns)
            if [ -z "$2" ]; then
                echo "${COLOR_RED}ERROR${COLOR_GRAY}:$COLOR_DEFAULT the namespace is not specified"
                echo
                echo "Usage: kube ns <namespace>"
                return 1
            fi
            kubectl config set-context --current --namespace "$2"
        ;;
        *)
            [ -n "$1" ] && echo "Unknown command '$1'"
            echo "Usage: kube <command>"
            echo
            echo "Available commands:"
            echo "  conf - set the current kubeconfig"
            echo "  ns   - set the current namespace"
            echo "  on   - turn on k8s bash prompt"
            echo "  off  - turn off k8s bash prompt"
            return 1
        ;;
    esac

}

__kube_complete() {

    local __VAR

    COMPREPLY=()

    if [ $COMP_CWORD -lt 2 ]; then
        COMPREPLY=($(compgen -W "on off conf ns" "${COMP_WORDS[1]}"))
        return
    fi

    case "${COMP_WORDS[1]}" in
        conf)
            compopt -o default
        ;;
        ns)
            if ! __VAR="$(kubectl get namespace -o jsonpath='{.items[*].metadata.name}' 2>&1)"; then
                echo
                printf '%s' "${COLOR_RED}ERROR${COLOR_GRAY}:$COLOR_DEFAULT $__VAR"
                COMPREPLY=('~=~=~=~=~=~' '=~=~=~=~=~=')
            else
                COMPREPLY=($(compgen -W "$__VAR" "${COMP_WORDS[2]}"))
            fi
        ;;
    esac

}

complete -F __kube_complete kube

aws() {

    if [ -n "$1" ] && [ "$__AWS_NOT_AVAILABLE" != 0 ]; then
        echo "${COLOR_RED}ERROR${COLOR_GRAY}:$COLOR_DEFAULT aws command is not available in this environment"
        return 1
    fi

    case "$1" in
        on)
            touch "$IAM_HOME/state/on_aws"
        ;;
        off)
            rm -f "$IAM_HOME/state/on_aws"
        ;;
        *)
            command aws "$@"
        ;;
    esac

}

#magic
myssh() {
   ssh -t $* "IAM=\"$IAM\" && export IAM && \
              SSH_PUB_KEY=\"$SSH_PUB_KEY\" && export SSH_PUB_KEY && \
              IAM_HOME=\"\$HOME/.${IAM}_home\" && export IAM_HOME &&
              rm -rf \"\$HOME/.${IAM}_terminfo\" && \
              rm -f \"\$HOME/.${IAM}_startup\" && \
              if [ ! -d \"\$IAM_HOME\" ]; then mkdir \"\$IAM_HOME\"; fi && \
              rm -rf \"\$IAM_HOME/terminfo\" && \
              mkdir \"\$IAM_HOME/terminfo\" && \
              echo \"$(cat ${IAM_HOME}/terminfo/.terminfo | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/terminfo/.terminfo\" &&
              TERMINFO=\"\$IAM_HOME/terminfo\" && \
              export TERMINFO && \
              tic \"\$IAM_HOME/terminfo/.terminfo\" && \
              echo \"$(cat ${IAM_HOME}/gitconfig | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/gitconfig\" && \
              echo \"$(cat ${IAM_HOME}/vimrc | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/vimrc\" && \
              echo \"$(cat ${HOME}/.tclshrc | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$HOME/.tclshrc\" && \
              echo \"$(cat ${IAM_HOME}/bashrc | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/bashrc\"; exec bash --rcfile \"\$IAM_HOME/bashrc\" -i || exec \$SHELL -i"
}
mydocker() {
   docker exec -ti $1 /bin/bash -c "IAM=\"$IAM\" && export IAM && \
              SSH_PUB_KEY=\"$SSH_PUB_KEY\" && export SSH_PUB_KEY && \
              IAM_HOME=\"\$HOME/.${IAM}_home\" && export IAM_HOME &&
              rm -rf \"\$HOME/.${IAM}_terminfo\" && \
              rm -f \"\$HOME/.${IAM}_startup\" && \
              if [ ! -d \"\$IAM_HOME\" ]; then mkdir \"\$IAM_HOME\"; fi && \
              rm -rf \"\$IAM_HOME/terminfo\" && \
              mkdir \"\$IAM_HOME/terminfo\" && \
              echo \"$(cat ${IAM_HOME}/terminfo/.terminfo | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/terminfo/.terminfo\" &&
              TERMINFO=\"\$IAM_HOME/terminfo\" && \
              export TERMINFO && \
              tic \"\$IAM_HOME/terminfo/.terminfo\" && \
              echo \"$(cat ${IAM_HOME}/gitconfig | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/gitconfig\" && \
              echo \"$(cat ${IAM_HOME}/vimrc | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/vimrc\" && \
              echo \"$(cat ${HOME}/.tclshrc | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$HOME/.tclshrc\" && \
              echo \"$(cat ${IAM_HOME}/bashrc | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/bashrc\"; stty cols $COLUMNS; exec bash --rcfile \"\$IAM_HOME/bashrc\" -i || exec \$SHELL -i"
}
mysudo() {
    local sudo_cmd
    if [ -z "$1" ]; then
        sudo_cmd="sudo"
    else
        sudo_cmd="sudo -u $1"
    fi
    $sudo_cmd -H bash -c "IAM=\"$IAM\" && export IAM && \
              SSH_PUB_KEY=\"$SSH_PUB_KEY\" && export SSH_PUB_KEY && \
              IAM_HOME=\"\$HOME/.${IAM}_home\" && export IAM_HOME &&
              rm -rf \"\$HOME/.${IAM}_terminfo\" && \
              rm -f \"\$HOME/.${IAM}_startup\" && \
              if [ ! -d \"\$IAM_HOME\" ]; then mkdir \"\$IAM_HOME\"; fi && \
              rm -rf \"\$IAM_HOME/terminfo\" && \
              mkdir \"\$IAM_HOME/terminfo\" && \
              echo \"$(cat ${IAM_HOME}/terminfo/.terminfo | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/terminfo/.terminfo\" &&
              TERMINFO=\"\$IAM_HOME/terminfo\" && \
              export TERMINFO && \
              tic \"\$IAM_HOME/terminfo/.terminfo\" && \
              echo \"$(cat ${IAM_HOME}/gitconfig | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/gitconfig\" && \
              echo \"$(cat ${IAM_HOME}/vimrc | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/vimrc\" && \
              echo \"$(cat ${HOME}/.tclshrc | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$HOME/.tclshrc\" && \
              echo \"$(cat ${IAM_HOME}/bashrc | sed 's/\([$"\`\\]\)/\\\1/g')\">\"\$IAM_HOME/bashrc\"; exec bash --rcfile \"\$IAM_HOME/bashrc\" -i || exec \$SHELL -i"
}

# one-liner:
# export ROLE=arn:aws:iam::<AWS ACCOUNT>:role/<AWS ROLE> && unset AWS_ACCESS_KEY_ID && unset AWS_SECRET_ACCESS_KEY && unset AWS_SESSION_TOKEN && set -- $(SESS_NAME=$(hostname -s); set -x; aws sts assume-role --role-arn "$ROLE" --role-session-name $SESS_NAME --output text --query '[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken]') && unset ROLE && export AWS_ACCESS_KEY_ID="$1" && export AWS_SECRET_ACCESS_KEY="$2" && export AWS_SESSION_TOKEN="$3" && export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-us-east-1}" && set --
aws_role() {
    if [ -z "$1" ]; then
        echo "Usage: aws_role <role ARN>"
        echo
        echo "Example: aws_role arn:aws:iam::<AWS ACCOUNT>:role/<AWS ROLE>"
        exit 1
    fi
    echo "Assume role: $1"
    if [ -n "$AWS_SESSION_TOKEN" ]; then
        unset AWS_SESSION_TOKEN
        unset AWS_ACCESS_KEY_ID
        unset AWS_SECRET_ACCESS_KEY
    fi
    export __ROLE="$1"
    export __SESS_NAME="$(hostname -s)"
    set -- $(set -x; aws sts assume-role --role-arn "$__ROLE" --role-session-name $__SESS_NAME --output text --query '[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken]')
    unset __ROLE
    unset __SESS_NAME
    export AWS_ACCESS_KEY_ID="$1"
    export AWS_SECRET_ACCESS_KEY="$2"
    export AWS_SESSION_TOKEN="$3"
    export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-us-east-1}"
    set --
}

# KiTTY functions to receive file(s) and launch winscp
get() {
    printf "\033]0;__pw:"`pwd`"\007"
    for file in $*
    do
        if [ -d "$file" ]; then
            basename="`basename "$file"`"
            rm -f "/tmp/{basename}.tar.gz"
            tar czf "/tmp/${basename}.tar.gz" "$file"
            printf "\033]0;__rv:"/tmp/${basename}.tar.gz"\007"
        else
            printf "\033]0;__rv:"${file}"\007"
        fi
    done
    printf "\033]0;__ti\007"
}
winscp() {
    echo -ne "\033];__ws:${PWD}\007"
}
clip() {
    echo -ne '\e''[5i'
    cat $*
    echo -ne '\e''[4i'
    echo "Copied to Windows clipboard" 1>&2
}

# 'less' settings
# -F Causes less to automatically exit if the entire file can be displayed on the first screen
# -X Disables sending the termcap initialization and deinitialization strings to the terminal.
#    It allows to see text when 'less' exited because of the above option (-F). Without this
#    option screen will be initialized and deinitialized, and console will be cleared.
# -R Turn on ANSI "color" escape sequences in output
# -i Causes searches to ignore case
# -w Temporarily highlights the first "new" line after a forward movement of a full page
# -z-4 Changes the default scrolling window size to "screen-4" lines
# -P Prompt. Must be last option
LESS="-F -X -R -i -w -z-4 -P spacebar\:page ahead b\:page back /\:search ahead \?\:search back h\:help q\:quit"
export LESS
#PAGER=less
#export PAGER
# LESS man page colors (makes Man pages more readable).
LESS_TERMCAP_mb=$'\E[01;31m'
LESS_TERMCAP_md=$'\E[01;31m'
LESS_TERMCAP_me=$'\E[0m'
LESS_TERMCAP_se=$'\E[0m'
LESS_TERMCAP_so=$'\E[01;44;33m'
LESS_TERMCAP_ue=$'\E[0m'
LESS_TERMCAP_us=$'\E[01;32m'
export LESS_TERMCAP_mb
export LESS_TERMCAP_md
export LESS_TERMCAP_me
export LESS_TERMCAP_se
export LESS_TERMCAP_so
export LESS_TERMCAP_ue
export LESS_TERMCAP_us

# append history rather than overwrite
shopt -s histappend
# one command per line
shopt -s cmdhist
unset HISTFILESIZE
HISTSIZE=1000000
# ignore commands that start with a space AND duplicate commands
HISTCONTROL=ignoreboth
# add the full date and time to lines
HISTTIMEFORMAT='%F %T '
HISTIGNORE="&:[bf]g:exit"
# history file
HISTFILE="$HOME/.${IAM}_history"

(set +e; command -v git >/dev/null 2>&1)
__GIT_NOT_AVAILABLE=$?

(set +e; command -v kubectl >/dev/null 2>&1)
__K8S_NOT_AVAILABLE=$?

(set +e; command -v aws >/dev/null 2>&1)
__AWS_NOT_AVAILABLE=$?

__kubectl_status() {

    local __K8S_CONTEXT
    local __K8S_CONF
    local __K8S_OUTPUT
    local __K8S_NS

    if [ "$__K8S_NOT_AVAILABLE" != 0 ] || [ ! -e "$IAM_HOME/state/on_kube" ]; then
        return
    fi

    if [ -z "$KUBECONFIG" ]; then
        __K8S_CONF="$HOME/.kube/config"
    else
        __K8S_CONF="$KUBECONFIG"
    fi

    __K8S_OUTPUT="${COLOR_GRAY}[${COLOR_WHITE}K8S${COLOR_GRAY}: $COLOR_CYAN$(prompt_workingdir "$__K8S_CONF")"

    if [ ! -e "$__K8S_CONF" ]; then
        __K8S_OUTPUT="${__K8S_OUTPUT}${COLOR_DEFAULT} - ${COLOR_RED}DOESN'T EXIST"
    else

        __K8S_OUTPUT="${__K8S_OUTPUT}${COLOR_GRAY}; ${COLOR_DEFAULT}cluster${COLOR_GRAY}: "

        if ! __K8S_CONTEXT="$(kubectl config current-context 2>&1)"; then
            # convert from:
            #   error: current-context is not set
            # to:
            #   current-context is not set
            __K8S_CONTEXT="${__K8S_CONTEXT#* }"
            __K8S_OUTPUT="${__K8S_OUTPUT}${COLOR_LIGHTRED}$__K8S_CONTEXT"
        else

            __K8S_OUTPUT="${__K8S_OUTPUT}${COLOR_PURPLE}$__K8S_CONTEXT"

            __K8S_NS="$(kubectl config view -o=jsonpath="{.contexts[?(@.name==\"$__K8S_CONTEXT\")].context.namespace}")"
            [ -z "$__K8S_NS" ] && __K8S_NS="default"
            __K8S_OUTPUT="${__K8S_OUTPUT}${COLOR_GRAY}; ${COLOR_DEFAULT}namespace${COLOR_GRAY}: ${COLOR_PURPLE}$__K8S_NS"

        fi

    fi

    __K8S_OUTPUT="${__K8S_OUTPUT}${COLOR_GRAY}]${COLOR_DEFAULT}"

    echo "$__K8S_OUTPUT"

}

__aws_status() {

    local __AWS_OUTPUT
    local __AWS_INDENTITY

    if [ "$__AWS_NOT_AVAILABLE" != 0 ] || [ ! -e "$IAM_HOME/state/on_aws" ]; then
        return
    fi

    __AWS_OUTPUT="${COLOR_GRAY}[${COLOR_WHITE}AWS${COLOR_GRAY}: "

    __AWS_OUTPUT="${__AWS_OUTPUT}${COLOR_DEFAULT}key${COLOR_GRAY}:"
    if declare -p AWS_ACCESS_KEY_ID >/dev/null 2>&1; then
        __AWS_OUTPUT="$__AWS_OUTPUT${COLOR_GREEN} Y"
    else
        __AWS_OUTPUT="$__AWS_OUTPUT${COLOR_RED} N"
    fi

    __AWS_OUTPUT="${__AWS_OUTPUT}${COLOR_GRAY}; ${COLOR_DEFAULT}secret${COLOR_GRAY}:"
    if declare -p AWS_SECRET_ACCESS_KEY >/dev/null 2>&1; then
        __AWS_OUTPUT="$__AWS_OUTPUT${COLOR_GREEN} Y"
    else
        __AWS_OUTPUT="$__AWS_OUTPUT${COLOR_RED} N"
    fi

    __AWS_OUTPUT="${__AWS_OUTPUT}${COLOR_GRAY}; ${COLOR_DEFAULT}session${COLOR_GRAY}:"
    if declare -p AWS_SESSION_TOKEN >/dev/null 2>&1; then
        __AWS_OUTPUT="$__AWS_OUTPUT${COLOR_GREEN} Y"
    else
        __AWS_OUTPUT="$__AWS_OUTPUT${COLOR_RED} N"
    fi

    __AWS_OUTPUT="${__AWS_OUTPUT}${COLOR_GRAY}; ${COLOR_DEFAULT}region${COLOR_GRAY}:"
    if declare -p AWS_DEFAULT_REGION >/dev/null 2>&1; then
        __AWS_OUTPUT="$__AWS_OUTPUT${COLOR_CYAN} $AWS_DEFAULT_REGION"
    else
        __AWS_OUTPUT="$__AWS_OUTPUT${COLOR_RED} N"
    fi

    __AWS_OUTPUT="${__AWS_OUTPUT}${COLOR_GRAY}; ${COLOR_DEFAULT}indentity${COLOR_GRAY}:"
    if ! __AWS_INDENTITY="$(aws sts get-caller-identity --query 'Arn' 2>&1)"; then
        # convert from:
        #   An error occurred (InvalidClientTokenId) when calling the GetCallerIdentity operation: The security token included in the request is invalid.
        # to
        #   The security token included in the request is invalid.
        __AWS_INDENTITY="${__AWS_INDENTITY#*:}"
        __AWS_OUTPUT="$__AWS_OUTPUT${COLOR_LIGHTRED}$__AWS_INDENTITY"
    else
        __AWS_OUTPUT="$__AWS_OUTPUT${COLOR_GREEN} $(echo "$__AWS_INDENTITY" | tr -d '"')"
    fi

    __AWS_OUTPUT="${__AWS_OUTPUT}${COLOR_GRAY}]${COLOR_DEFAULT}"

    echo "$__AWS_OUTPUT"

}

# based on: https://github.com/magicmonty/bash-git-prompt
__git_status() {

    if [ "$__GIT_NOT_AVAILABLE" != 0 ]; then
        return
    fi

    __GIT_STATUS="$(LC_ALL=C git status --porcelain --branch 2>/dev/null)"
    if [ "$?" -ne 0 ]; then
        unset __GIT_STATUS
        return
    fi

    __GIT_REPO_ROOT="$(git rev-parse --git-dir)"

    if [ "$__GIT_REPO_ROOT" = ".git" ]; then
        __GIT_REPO_ROOT="$(pwd)"
    else
        __GIT_REPO_ROOT="$(dirname "$__GIT_REPO_ROOT")"
    fi

    __GIT_BRANCH="!ERROR!"
    __GIT_NUM_STAGED=0
    __GIT_NUM_CHANGED=0
    __GIT_NUM_CONFLICT=0
    __GIT_NUM_UNTRACKED=0

    while IFS='' read -r line || [[ -n "${line}" ]]; do
        status="${line:0:2}"
        while [[ -n ${status} ]]; do
            case "${status}" in
                \#\#) __GIT_BRANCH="${line/\.\.\./^}"; break ;;
                \?\?) ((__GIT_NUM_UNTRACKED++)); break ;;
                U?) ((__GIT_NUM_CONFLICT++)); break;;
                ?U) ((__GIT_NUM_CONFLICT++)); break;;
                DD) ((__GIT_NUM_CONFLICT++)); break;;
                AA) ((__GIT_NUM_CONFLICT++)); break;;
                ?M) ((__GIT_NUM_CHANGED++)) ;;
                ?D) ((__GIT_NUM_CHANGED++)) ;;
                ?\ ) ;;
                U) ((__GIT_NUM_CONFLICT++)) ;;
                \ ) ;;
                *) ((__GIT_NUM_STAGED++)) ;;
            esac
            status="${status:0:(${#status}-1)}"
        done
    done <<< "${__GIT_STATUS}"

    unset line
    unset status

    IFS="^" read -ra __GIT_BRANCH_FIELDS <<< "${__GIT_BRANCH/\#\# }"
    __GIT_BRANCH="${__GIT_BRANCH_FIELDS[0]}"

    __GIT_OUTPUT="${COLOR_GRAY}[${COLOR_WHITE}GIT${COLOR_GRAY}: $COLOR_CYAN$(prompt_workingdir "$__GIT_REPO_ROOT")"
    __GIT_OUTPUT="${__GIT_OUTPUT}${COLOR_GRAY}; ${COLOR_DEFAULT}branch${COLOR_GRAY}: $COLOR_PURPLE$__GIT_BRANCH"

    if [ "$__GIT_NUM_CONFLICT" -ne 0 ]; then
        __GIT_OUTPUT="${__GIT_OUTPUT}${COLOR_GRAY}; ${COLOR_LIGHTRED}conflict${COLOR_GRAY}: $COLOR_DEFAULT$__GIT_NUM_CONFLICT"
    fi

    if [ "$__GIT_NUM_STAGED" -ne 0 ]; then
        __GIT_OUTPUT="${__GIT_OUTPUT}${COLOR_GRAY}; ${COLOR_GREEN}staged${COLOR_GRAY}: $COLOR_DEFAULT$__GIT_NUM_STAGED"
    fi

    if [ "$__GIT_NUM_CHANGED" -ne 0 ]; then
        __GIT_OUTPUT="${__GIT_OUTPUT}${COLOR_GRAY}; ${COLOR_BROWN}changed${COLOR_GRAY}: $COLOR_DEFAULT$__GIT_NUM_CHANGED"
    fi

    if [ "$__GIT_NUM_UNTRACKED" -ne 0 ]; then
        __GIT_OUTPUT="${__GIT_OUTPUT}${COLOR_GRAY}; ${COLOR_DEFAULT}untracked${COLOR_GRAY}: $COLOR_LIGHTRED$__GIT_NUM_UNTRACKED"
    fi

    __GIT_OUTPUT="${__GIT_OUTPUT}${COLOR_GRAY}]${COLOR_DEFAULT}"

    echo "$__GIT_OUTPUT"

    unset __GIT_REPO_ROOT
    unset __GIT_BRANCH
    unset __GIT_BRANCH_FIELDS
    unset __GIT_NUM_STAGED
    unset __GIT_NUM_CHANGED
    unset __GIT_NUM_CONFLICT
    unset __GIT_NUM_UNTRACKED
    unset __GIT_OUTPUT
}

# Function to set prompt_command to.
function promptcmd () {
    # Exit status of the last command run.
    let exitcode=$?

    # fix cursor position not on new line
    echo -en "\033[6n" && read -sdR CURPOS
    [[ ${CURPOS##*;} -gt 1 ]] && echo "${COLOR_ERROR}%${COLOR_DEFAULT}"

    # print error exist status of previous command
    if [[ $exitcode != 0 ]] ; then
       echo "${COLOR_RED}Exit code: $exitcode${COLOR_DEFAULT}"
    fi

    # if inside of zombie directory
    if [ ! -z "$MY_STATC" ]; then
        if [ ! -d "$PWD" ]; then
            echo "${COLOR_RED}Warning: Current directory doesn't exist${COLOR_DEFAULT}"
        elif [ "`$MY_STATC '%i' .`" != "`$MY_STATC '%i' "$PWD"`" ]; then
            echo "${COLOR_BROWN}Current directory is a zombie. Fixing it.${COLOR_DEFAULT}"
            cd ../"`basename "$PWD"`"
        fi
    fi

    # update history file
    history -a

    # Titlebar
    case ${TERM} in
        xterm*  )
            # No username in tab title
            #local TITLEBAR='\[\033]0;\u@\h:\w\007\]'
            local TITLEBAR='\[\033]0;\h:\w\007\]'
        ;;
        *       )
            local TITLEBAR=''
        ;;
    esac

    __aws_status
    __kubectl_status
    __git_status

    PS1="${TITLEBAR}"

    PS1="${PS1}\[${COLOR_GRAY}${COLOR_BOLD}\][\[${COLOR_DEFAULT}\]"

#    # Test for day change.
#    if [ -z $DAY ] ; then
#        export DAY=$(date +%A)
#    else
#        local today=$(date +%A)
#        if [ "${DAY}" != "${today}" ]; then
#            PS1="${PS1}\n\[${COLOR_GREEN}\]Day changed to $(date '+%A, %d %B %Y').\n"
#            export DAY=$today
#       fi
#    fi

    # User
    if [ ${UID} -eq 0 ] ; then
        if [ "${USER}" == "${LOGNAME}" ]; then
            if [[ ${SUDO_USER} ]]; then
                PS1="${PS1}\[${COLOR_RED}\]"
            else
                PS1="${PS1}\[${COLOR_LIGHTRED}\]"
            fi
        else
            PS1="${PS1}\[${COLOR_YELLOW}\]"
        fi
    else
        if [ ${USER} == ${LOGNAME} ]; then
            PS1="${PS1}\[${COLOR_GREEN}\]"
        else
            PS1="${PS1}\[${COLOR_BROWN}\]"
        fi
    fi

    # @
    PS1="${PS1}\u\[${COLOR_GRAY}\]@\[${COLOR_DEFAULT}\]"

    # Host
    PS1="${PS1}\[${COLOR_LIGHTBLUE}\]\h\[${COLOR_DEFAULT}\]"

    # :
    PS1="${PS1}\[${COLOR_GRAY}${COLOR_BOLD}\]:\[${COLOR_DEFAULT}\]"

    # Working directory
    if [ -w "${PWD}" ]; then
        PS1="${PS1}\[${COLOR_GREEN}\]$(prompt_workingdir)"
    else
        PS1="${PS1}\[${COLOR_RED}\]$(prompt_workingdir)"
    fi

    PS1="${PS1}\[${COLOR_GRAY}${COLOR_BOLD}\]]\[${COLOR_DEFAULT}\]"

    # Backgrounded running jobs
    local BKGJBS=$(jobs -r | wc -l )
    if [ ${BKGJBS} -gt 2 ]; then
        PS1="${PS1}\[${COLOR_RED}\][bg:${BKGJBS}]\[${COLOR_DEFAULT}\]"
    elif [ ${BKGJBS} -gt 0 ]; then
        PS1="${PS1}\[${COLOR_YELLOW}\][bg:${BKGJBS}]\[${COLOR_DEFAULT}\]"
    fi

    # Stopped Jobs
    local STPJBS=$(jobs -s | wc -l )
    if [ ${STPJBS} -gt 2 ]; then
        PS1="${PS1}\[${COLOR_RED}\][stp:${STPJBS}]\[${COLOR_DEFAULT}\]"
    elif [ ${STPJBS} -gt 0 ]; then
        PS1="${PS1}\[${COLOR_YELLOW}\][stp:${STPJBS}]\[${COLOR_DEFAULT}\]"
    fi

    PS1="${PS1}\[${COLOR_SIGN}\]\\$\[${COLOR_DEFAULT}\] "

#    export PS1
}
#export -f promptcmd

# Trim working dir to 1/4 the screen width
function prompt_workingdir () {
  local MY_PWD
  if [ "x$COLUMNS" = "x" ]; then
      local pwdmaxlen=20
  else
      local pwdmaxlen=$(($COLUMNS/4))
  fi
  local trunc_symbol="..."
  if [ -z "$1" ]; then
      MY_PWD="$PWD"
  else
      MY_PWD="$1"
  fi
  if [[ $MY_PWD == $HOME* ]]; then
    newPWD="~${MY_PWD#$HOME}"
  else
    newPWD="$MY_PWD"
  fi
  if [ ${#newPWD} -gt $pwdmaxlen ]; then
    local pwdoffset=$(( ${#newPWD} - $pwdmaxlen + 3 ))
    newPWD="${trunc_symbol}${newPWD:$pwdoffset:$pwdmaxlen}"
  fi
  echo $newPWD
}
#export -f prompt_workingdir

PROMPT_COMMAND=promptcmd
#export PROMPT_COMMAND

#PS1="[\u@\\H:\w] \\$ "

# Fixes for specific OS

case `uname -s` in
    *HP-UX*)
        # added support for ctrl-C / ctrl-U / ctrl-Z
        stty intr '^C' kill '^U' susp '^Z'
    ;;
    CYGWIN*)
        # Ignore case for filenames
        shopt -s nocaseglob
        bind "set completion-ignore-case on"

        # Strip '.exe' suffix for completions
        shopt -s completion_strip_exe

        # Make Bash 8bit clean
        bind "set meta-flag on"
        bind "set convert-meta off"
        bind "set output-meta on"

        # Initialize environment variables
        # http://www.smithii.com/node/44
        if [ "$SSH_TTY" ]; then
            # special var
            PROGRAMFILESX86="$(cmd.exe /C "echo %ProgramFiles(x86)%" | tr -d '\r')"
            pushd . >/dev/null
            for __dir in \
                /proc/registry/HKEY_CURRENT_USER/Volatile\ Environment \
                /proc/registry/HKEY_CURRENT_USER/Environment \
                /proc/registry/HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/Control/Session\ Manager/Environment
            do
                # Ignoring non-existing registry keys
                if [ ! -d "$__dir" ]; then
                    continue
                fi
                cd "$__dir"
                for __var in *
                do
                    # Ignoring directories
                    if [ -d "$__var" ]; then
                        continue
                    fi
                    __var=`echo $__var | tr '[a-z]' '[A-Z]'`
                    if [ "x${!__var}" = "x" ]; then
                        __val=`tr -d '\0' < "$__var"`
                        # Replace Windows system variables
                        __val="${__val/\%SystemRoot\%/$SYSTEMROOT}"
                        __val="${__val/\%ProgramFiles\%/$PROGRAMFILES}"
                        __val="${__val/\%USERPROFILE\%/$USERPROFILE}"
                        __val="${__val/\%ProgramFiles(x86)\%/$PROGRAMFILESX86}"
                        echo "Adding environment variable '${__var}'"
                        if [ "${__val/\%/}" != "$__val" ]; then
                            echo "Warning! Percent in environment variable '${__var}': '${__val}'"
                        fi
                        export $__var="$__val" >/dev/null 2>&1
                    fi
                done
            done
            unset __dir
            unset __var
            unset __val
            popd >/dev/null
        fi
#        set +x
    ;;
esac

if [ -f ~/.${IAM}_customrc ]; then
    . ~/.${IAM}_customrc
fi

for VAR in LD_LIBRARY_PATH LIBPATH SHLIB_PATH DYLD_LIBRARY_PATH LD_PRELOAD LD_RUN_PATH; do
    if [ ! -z "${!VAR}" ]; then
        FOUND=1
        echo "${COLOR_GRAY}[${COLOR_LIGHTRED}Warning${COLOR_GRAY}]${COLOR_DEFAULT} $VAR ${COLOR_GRAY}=${COLOR_DEFAULT} ${!VAR}"
    fi
done; unset VAR

if [ ! -z "$FOUND" ]; then
    echo ""
    unset FOUND
fi

# --------------

EFAG=()

case `uname -s` in
    Linux)
        while IFS= read -r line; do
            # workaround for old bash: https://unix.stackexchange.com/questions/64427/bash-3-0-not-supporting-lists
            EFAG[${#EFAG[@]}]="$line"
        done < <(ps -o args= -C ecmdrAgent | grep -oP '^.*(?=/ecmdrAgent)')
        unset line
    ;;
    CYGWIN*)
        while IFS= read -r line; do
            if [[ $line == ExecutablePath=* ]]; then
                line="$(dirname "$(cygpath -u "${line#*=}")")"
                # workaround for old bash: https://unix.stackexchange.com/questions/64427/bash-3-0-not-supporting-lists
                EFAG[${#EFAG[@]}]="$line"
            fi
        done < <(wmic process where "name='ecmdrAgent.exe'" get ExecutablePath /FORMAT:LIST 2>/dev/null)
        unset line
    ;;
esac

# Try to detect and add path to tools-only install
if [ "${#EFAG[*]}" -eq 0 ]; then

    if [ "$(uname -o)" == "Cygwin" ]; then
        EFAG_STD="$(cygpath -u "c:/Program Files/Electric Cloud/ElectricCommander/bin")"
    else
        EFAG_STD="/opt/electriccloud/electriccommander/bin"

    fi

    if [ -d "$EFAG_STD" ]; then
        EFAG[${#EFAG[@]}]="$EFAG_STD"
    fi

    unset EFAG_STD

fi

if [ "${#EFAG[*]}" -ge 1 ]; then

    EFAG_STD=
    EFAG_NSTD=

    idx=0; while [ $idx -lt ${#EFAG[*]} ]; do
        if [[ "${EFAG[$idx]}" == "/opt/electriccloud/electriccommander/"* ]] || [[ "${EFAG[$idx]}" == "/c/Electric Cloud/ElectricCommander/"* ]] || [[ "${EFAG[$idx]}" == "/c/Program Files/Electric Cloud/ElectricCommander/"* ]]; then
            EFAG_STD="${EFAG[$idx]}"
        else
            EFAG_NSTD="${EFAG[$idx]}"
        fi
        idx=$(( $idx + 1 ))
    done; unset idx

    if [ -z "$EFAG_NSTD" ]; then
        EFAG_TO_PATH="$EFAG_STD"
    else
        EFAG_TO_PATH="$EFAG_NSTD"
    fi

    unset EFAG_STD
    unset EFAG_NSTD

    idx=0; while [ $idx -lt ${#EFAG[*]} ]; do
        if [ "${EFAG[$idx]}" = "$EFAG_TO_PATH" ]; then
            ADDON=" ${COLOR_GRAY}(${COLOR_GREEN}Added to PATH${COLOR_GRAY})${COLOR_DEFAULT}"
        fi
        echo "${COLOR_GRAY}[${COLOR_GREEN}EF location${COLOR_GRAY}]${COLOR_DEFAULT} ${EFAG[$idx]}$ADDON"
        unset ADDON
        idx=$(( $idx + 1 ))
    done; unset idx

    PATH="$EFAG_TO_PATH:$PATH"
    export PATH

    unset EFAG_TO_PATH

    echo ""

fi

unset EFAG

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
elif [ -f /etc/profile.d/bash_completion.sh ]; then
    . /etc/profile.d/bash_completion.sh
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

if ! type _init_completion >/dev/null 2>&1; then
    echo "${COLOR_RED}The original bash completion package is not installed on this machine. Some of the completions may not be available.${COLOR_DEFAULT}"
    echo ""
fi

if [ -d "$IAM_HOME/tools/bash_completion" ]; then

    if [ ! -f "$IAM_HOME/tools/bash_completion/kubectl.completion.bash" ] && type _init_completion >/dev/null 2>&1 && command -v kubectl >/dev/null 2>&1; then
        echo "Generating bash completions for kubectl..."
        kubectl completion bash >"$IAM_HOME/tools/bash_completion/kubectl.completion.bash"
    fi

    if [ ! -f "$IAM_HOME/tools/bash_completion/eksctl.completion.bash" ] && type _init_completion >/dev/null 2>&1 && command -v eksctl >/dev/null 2>&1; then
        echo "Generating bash completions for eksctl..."
        eksctl completion bash >"$IAM_HOME/tools/bash_completion/eksctl.completion.bash"
    fi

    for i in "$IAM_HOME/tools/bash_completion"/*.bash; do
        source $i
    done

    if [ -x "/usr/local/aws/bin/aws_completer" ]; then
        complete -C '/usr/local/aws/bin/aws_completer' aws
    fi

else
    echo "${COLOR_RED}Custom bash completion are not exist. Run the 'updatetools' command.${COLOR_DEFAULT}"
    echo ""
fi

if [ "$__K8S_NOT_AVAILABLE" = 0 ]; then

    alias kc=kubectl

    if type __start_kubectl >/dev/null 2>&1; then
        if [ "$(type -t compopt)" = "builtin" ]; then
            complete -o default -F __start_kubectl kc
        else
            complete -o default -o nospace -F __start_kubectl kc
        fi
    fi

fi


SSH_PUB_KEY_ONLY="`echo $SSH_PUB_KEY | awk '{print $2}'`"

if [ -z "$SSH_PUB_KEY_ONLY" ]; then
    echo "${COLOR_RED}SSH key is not defined${COLOR_DEFAULT}"
    echo ""
else

    if [ ! -d ~/.ssh ]; then
        mkdir ~/.ssh
        chmod 0700 ~/.ssh
    fi

    if [ ! -f ~/.ssh/authorized_keys ]; then
        echo "$SSH_PUB_KEY" > ~/.ssh/authorized_keys
        chmod 0600 ~/.ssh/authorized_keys
        echo "${COLOR_GREEN}SSH key installed${COLOR_DEFAULT}"
        echo ""
    # 'grep -q' is not supported on some ancient environments (solaris/solaris x86)
    elif ! grep "$SSH_PUB_KEY_ONLY" ~/.ssh/authorized_keys >/dev/null 2>&1; then
        echo "$SSH_PUB_KEY" >> ~/.ssh/authorized_keys
        echo "${COLOR_GREEN}SSH key installed${COLOR_DEFAULT}"
        echo ""
    fi

fi

unset SSH_PUB_KEY_ONLY

# https://github.com/trapd00r/LS_COLORS
# Version: 0.254
# Updated: Tue Mar 29 21:25:30 AEST 2016
# fixes:
#   1. 'ca=' is removed. It is incompatible with some environments.
LS_COLORS='bd=38;5;68:cd=38;5;113;1:di=38;5;30:do=38;5;127:ex=38;5;208;1:pi=38;5;126:fi=0:ln=target:mh=38;5;222;1:no=0:or=48;5;196;38;5;232;1:ow=38;5;220;1:sg=48;5;3;38;5;0:su=38;5;220;1;3;100;1:so=38;5;197:st=38;5;86;48;5;234:tw=48;5;235;38;5;139;3:*LS_COLORS=48;5;89;38;5;197;1;3;4;7:*README=38;5;220;1:*README.rst=38;5;220;1:*LICENSE=38;5;220;1:*COPYING=38;5;220;1:*INSTALL=38;5;220;1:*COPYRIGHT=38;5;220;1:*AUTHORS=38;5;220;1:*HISTORY=38;5;220;1:*CONTRIBUTORS=38;5;220;1:*PATENTS=38;5;220;1:*VERSION=38;5;220;1:*NOTICE=38;5;220;1:*CHANGES=38;5;220;1:*.log=38;5;190:*.txt=38;5;253:*.etx=38;5;184:*.info=38;5;184:*.markdown=38;5;184:*.md=38;5;184:*.mkd=38;5;184:*.nfo=38;5;184:*.pod=38;5;184:*.rst=38;5;184:*.tex=38;5;184:*.textile=38;5;184:*.bib=38;5;178:*.json=38;5;178:*.msg=38;5;178:*.pgn=38;5;178:*.rss=38;5;178:*.xml=38;5;178:*.yaml=38;5;178:*.yml=38;5;178:*.RData=38;5;178:*.rdata=38;5;178:*.cbr=38;5;141:*.cbz=38;5;141:*.chm=38;5;141:*.djvu=38;5;141:*.pdf=38;5;141:*.PDF=38;5;141:*.docm=38;5;111;4:*.doc=38;5;111:*.docx=38;5;111:*.eps=38;5;111:*.ps=38;5;111:*.odb=38;5;111:*.odt=38;5;111:*.rtf=38;5;111:*.odp=38;5;166:*.pps=38;5;166:*.ppt=38;5;166:*.pptx=38;5;166:*.ppts=38;5;166:*.pptxm=38;5;166;4:*.pptsm=38;5;166;4:*.csv=38;5;78:*.ods=38;5;112:*.xla=38;5;76:*.xls=38;5;112:*.xlsx=38;5;112:*.xlsxm=38;5;112;4:*.xltm=38;5;73;4:*.xltx=38;5;73:*cfg=1:*conf=1:*rc=1:*.ini=1:*.plist=1:*.viminfo=1:*.pcf=1:*.psf=1:*.git=38;5;197:*.gitignore=38;5;240:*.gitattributes=38;5;240:*.gitmodules=38;5;240:*.awk=38;5;172:*.bash=38;5;172:*.bat=38;5;172:*.BAT=38;5;172:*.sed=38;5;172:*.sh=38;5;172:*.zsh=38;5;172:*.vim=38;5;172:*.ahk=38;5;41:*.py=38;5;41:*.ipynb=38;5;41:*.rb=38;5;41:*.pl=38;5;208:*.PL=38;5;160:*.t=38;5;114:*.msql=38;5;222:*.mysql=38;5;222:*.pgsql=38;5;222:*.sql=38;5;222:*.tcl=38;5;64;1:*.r=38;5;49:*.R=38;5;49:*.gs=38;5;81:*.asm=38;5;81:*.cl=38;5;81:*.lisp=38;5;81:*.lua=38;5;81:*.moon=38;5;81:*.c=38;5;81:*.C=38;5;81:*.h=38;5;110:*.H=38;5;110:*.tcc=38;5;110:*.c++=38;5;81:*.h++=38;5;110:*.hpp=38;5;110:*.hxx=38;5;110:*.ii=38;5;110:*.M=38;5;110:*.m=38;5;110:*.cc=38;5;81:*.cs=38;5;81:*.cp=38;5;81:*.cpp=38;5;81:*.cxx=38;5;81:*.cr=38;5;81:*.go=38;5;81:*.f=38;5;81:*.for=38;5;81:*.ftn=38;5;81:*.s=38;5;110:*.S=38;5;110:*.rs=38;5;81:*.swift=38;5;219:*.sx=38;5;81:*.hi=38;5;110:*.hs=38;5;81:*.lhs=38;5;81:*.pyc=38;5;240:*.css=38;5;125;1:*.less=38;5;125;1:*.sass=38;5;125;1:*.scss=38;5;125;1:*.htm=38;5;125;1:*.html=38;5;125;1:*.jhtm=38;5;125;1:*.mht=38;5;125;1:*.eml=38;5;125;1:*.mustache=38;5;125;1:*.coffee=38;5;074;1:*.java=38;5;074;1:*.js=38;5;074;1:*.mjs=38;5;074;1:*.jsm=38;5;074;1:*.jsm=38;5;074;1:*.jsp=38;5;074;1:*.php=38;5;81:*.ctp=38;5;81:*.twig=38;5;81:*.vb=38;5;81:*.vba=38;5;81:*.vbs=38;5;81:*Dockerfile=38;5;155:*.dockerignore=38;5;240:*Makefile=38;5;155:*MANIFEST=38;5;243:*pm_to_blib=38;5;240:*.am=38;5;242:*.in=38;5;242:*.hin=38;5;242:*.scan=38;5;242:*.m4=38;5;242:*.old=38;5;242:*.out=38;5;242:*.SKIP=38;5;244:*.diff=48;5;197;38;5;232:*.patch=48;5;197;38;5;232;1:*.bmp=38;5;97:*.tiff=38;5;97:*.tif=38;5;97:*.TIFF=38;5;97:*.cdr=38;5;97:*.gif=38;5;97:*.ico=38;5;97:*.jpeg=38;5;97:*.JPG=38;5;97:*.jpg=38;5;97:*.nth=38;5;97:*.png=38;5;97:*.psd=38;5;97:*.xpm=38;5;97:*.ai=38;5;99:*.eps=38;5;99:*.epsf=38;5;99:*.drw=38;5;99:*.ps=38;5;99:*.svg=38;5;99:*.avi=38;5;114:*.divx=38;5;114:*.IFO=38;5;114:*.m2v=38;5;114:*.m4v=38;5;114:*.mkv=38;5;114:*.MOV=38;5;114:*.mov=38;5;114:*.mp4=38;5;114:*.mpeg=38;5;114:*.mpg=38;5;114:*.ogm=38;5;114:*.rmvb=38;5;114:*.sample=38;5;114:*.wmv=38;5;114:*.3g2=38;5;115:*.3gp=38;5;115:*.gp3=38;5;115:*.webm=38;5;115:*.gp4=38;5;115:*.asf=38;5;115:*.flv=38;5;115:*.ts=38;5;115:*.ogv=38;5;115:*.f4v=38;5;115:*.VOB=38;5;115;1:*.vob=38;5;115;1:*.3ga=38;5;137;1:*.S3M=38;5;137;1:*.aac=38;5;137;1:*.au=38;5;137;1:*.dat=38;5;137;1:*.dts=38;5;137;1:*.fcm=38;5;137;1:*.m4a=38;5;137;1:*.mid=38;5;137;1:*.midi=38;5;137;1:*.mod=38;5;137;1:*.mp3=38;5;137;1:*.mp4a=38;5;137;1:*.oga=38;5;137;1:*.ogg=38;5;137;1:*.opus=38;5;137;1:*.s3m=38;5;137;1:*.sid=38;5;137;1:*.wma=38;5;137;1:*.ape=38;5;136;1:*.aiff=38;5;136;1:*.cda=38;5;136;1:*.flac=38;5;136;1:*.alac=38;5;136;1:*.midi=38;5;136;1:*.pcm=38;5;136;1:*.wav=38;5;136;1:*.wv=38;5;136;1:*.wvc=38;5;136;1:*.afm=38;5;66:*.fon=38;5;66:*.fnt=38;5;66:*.pfb=38;5;66:*.pfm=38;5;66:*.ttf=38;5;66:*.otf=38;5;66:*.PFA=38;5;66:*.pfa=38;5;66:*.7z=38;5;40:*.a=38;5;40:*.arj=38;5;40:*.bz2=38;5;40:*.cpio=38;5;40:*.gz=38;5;40:*.lrz=38;5;40:*.lz=38;5;40:*.lzma=38;5;40:*.lzo=38;5;40:*.rar=38;5;40:*.s7z=38;5;40:*.sz=38;5;40:*.tar=38;5;40:*.tgz=38;5;40:*.xz=38;5;40:*.z=38;5;40:*.Z=38;5;40:*.zip=38;5;40:*.zipx=38;5;40:*.zoo=38;5;40:*.zpaq=38;5;40:*.zz=38;5;40:*.apk=38;5;215:*.deb=38;5;215:*.rpm=38;5;215:*.jad=38;5;215:*.jar=38;5;215:*.cab=38;5;215:*.pak=38;5;215:*.pk3=38;5;215:*.vdf=38;5;215:*.vpk=38;5;215:*.bsp=38;5;215:*.dmg=38;5;215:*.r[0-9]{0,2}=38;5;239:*.zx[0-9]{0,2}=38;5;239:*.z[0-9]{0,2}=38;5;239:*.part=38;5;239:*.dmg=38;5;124:*.iso=38;5;124:*.bin=38;5;124:*.nrg=38;5;124:*.qcow=38;5;124:*.sparseimage=38;5;124:*.toast=38;5;124:*.vcd=38;5;124:*.vmdk=38;5;124:*.accdb=38;5;60:*.accde=38;5;60:*.accdr=38;5;60:*.accdt=38;5;60:*.db=38;5;60:*.fmp12=38;5;60:*.fp7=38;5;60:*.localstorage=38;5;60:*.mdb=38;5;60:*.mde=38;5;60:*.sqlite=38;5;60:*.typelib=38;5;60:*.nc=38;5;60:*.pacnew=38;5;33:*.un~=38;5;241:*.orig=38;5;241:*.BUP=38;5;241:*.bak=38;5;241:*.o=38;5;241:*core=38;5;241:*.rlib=38;5;241:*.swp=38;5;244:*.swo=38;5;244:*.tmp=38;5;244:*.sassc=38;5;244:*.pid=38;5;248:*.state=38;5;248:*lockfile=38;5;248:*.err=38;5;160;1:*.error=38;5;160;1:*.stderr=38;5;160;1:*.aria2=38;5;241:*.dump=38;5;241:*.stackdump=38;5;241:*.zcompdump=38;5;241:*.zwc=38;5;241:*.pcap=38;5;29:*.cap=38;5;29:*.dmp=38;5;29:*.DS_Store=38;5;239:*.localized=38;5;239:*.CFUserTextEncoding=38;5;239:*.allow=38;5;112:*.deny=38;5;196:*.service=38;5;45:*@.service=38;5;45:*.socket=38;5;45:*.swap=38;5;45:*.device=38;5;45:*.mount=38;5;45:*.automount=38;5;45:*.target=38;5;45:*.path=38;5;45:*.timer=38;5;45:*.snapshot=38;5;45:*.application=38;5;116:*.cue=38;5;116:*.description=38;5;116:*.directory=38;5;116:*.m3u=38;5;116:*.m3u8=38;5;116:*.md5=38;5;116:*.properties=38;5;116:*.sfv=38;5;116:*.srt=38;5;116:*.theme=38;5;116:*.torrent=38;5;116:*.urlview=38;5;116:*.asc=38;5;192;3:*.bfe=38;5;192;3:*.enc=38;5;192;3:*.gpg=38;5;192;3:*.signature=38;5;192;3:*.sig=38;5;192;3:*.p12=38;5;192;3:*.pem=38;5;192;3:*.pgp=38;5;192;3:*.asc=38;5;192;3:*.enc=38;5;192;3:*.sig=38;5;192;3:*.32x=38;5;213:*.cdi=38;5;213:*.fm2=38;5;213:*.rom=38;5;213:*.sav=38;5;213:*.st=38;5;213:*.a00=38;5;213:*.a52=38;5;213:*.A64=38;5;213:*.a64=38;5;213:*.a78=38;5;213:*.adf=38;5;213:*.atr=38;5;213:*.gb=38;5;213:*.gba=38;5;213:*.gbc=38;5;213:*.gel=38;5;213:*.gg=38;5;213:*.ggl=38;5;213:*.ipk=38;5;213:*.j64=38;5;213:*.nds=38;5;213:*.nes=38;5;213:*.sms=38;5;213:*.pot=38;5;7:*.pcb=38;5;7:*.mm=38;5;7:*.pod=38;5;7:*.gbr=38;5;7:*.spl=38;5;7:*.scm=38;5;7:*.Rproj=38;5;11:*.sis=38;5;7:*.1p=38;5;7:*.3p=38;5;7:*.cnc=38;5;7:*.def=38;5;7:*.ex=38;5;7:*.example=38;5;7:*.feature=38;5;7:*.ger=38;5;7:*.map=38;5;7:*.mf=38;5;7:*.mfasl=38;5;7:*.mi=38;5;7:*.mtx=38;5;7:*.pc=38;5;7:*.pi=38;5;7:*.plt=38;5;7:*.pm=38;5;7:*.rdf=38;5;7:*.rst=38;5;7:*.ru=38;5;7:*.sch=38;5;7:*.sty=38;5;7:*.sug=38;5;7:*.t=38;5;7:*.tdy=38;5;7:*.tfm=38;5;7:*.tfnt=38;5;7:*.tg=38;5;7:*.vcard=38;5;7:*.vcf=38;5;7:*.xln=38;5;7:*.iml=38;5;166:*.xcconfig=1:*.entitlements=1:*.strings=1:*.storyboard=38;5;196:*.xcsettings=1:*.xib=38;5;208:';
export LS_COLORS
# How-to generate:
#   1. Download https://github.com/trapd00r/LS_COLORS/blob/master/LS_COLORS
#   2. Run: $ dircolors -b ./LS_COLORS

updatetools() {

    if ! command -v curl >/dev/null 2>&1; then
        echo "${COLOR_RED}ERROR:${COLOR_DEFAULT} Could not update tools: curl command not found"
        return 1
    fi

    downloadit() {
        printf "Download: $1 '`basename "$2"`'..."
        mkdir -p "`dirname "$3"`"
        if ! curl -s -k -L "$2" > "$3"; then
            echo " ERROR"
        else
            echo " OK"
        fi
    }
    downloadit \
        "bash completion" \
        "https://raw.githubusercontent.com/chpock/.ini/master/bash_completion/custom/ecconfigure.bash" \
        "$IAM_HOME/tools/bash_completion/ecconfigure.completion.bash"
    downloadit \
        "bash completion" \
        "https://raw.githubusercontent.com/chpock/.ini/master/bash_completion/custom/ectool.bash" \
        "$IAM_HOME/tools/bash_completion/ectool.completion.bash"
    downloadit \
        "bash completion" \
        "https://raw.githubusercontent.com/chpock/.ini/master/bash_completion/custom/electricflow.bash" \
        "$IAM_HOME/tools/bash_completion/electricflow.completion.bash"
    downloadit \
        "bash completion" \
        "https://raw.githubusercontent.com/docker/cli/master/contrib/completion/bash/docker" \
        "$IAM_HOME/tools/bash_completion/docker.completion.bash"
    downloadit \
        "bash completion" \
        "https://raw.githubusercontent.com/docker/machine/master/contrib/completion/bash/docker-machine.bash" \
        "$IAM_HOME/tools/bash_completion/docker-machine.completion.bash"
    downloadit \
        "bash completion" \
        "https://raw.githubusercontent.com/docker/compose/master/contrib/completion/bash/docker-compose" \
        "$IAM_HOME/tools/bash_completion/docker-compose.completion.bash"
    downloadit \
        "bash completion" \
        "https://raw.githubusercontent.com/Bash-it/bash-it/master/completion/available/virtualbox.completion.bash" \
        "$IAM_HOME/tools/bash_completion/virtualbox.completion.bash"
    downloadit \
        "tcl readline" \
        "https://raw.githubusercontent.com/suewonjp/tclsh-wrapper/master/TclReadLine/TclReadLine.tcl" \
        "$IAM_HOME/tools/tcl/TclReadLine/TclReadLine.tcl"
    downloadit \
        "tcl readline" \
        "https://raw.githubusercontent.com/suewonjp/tclsh-wrapper/master/TclReadLine/pkgIndex.tcl" \
        "$IAM_HOME/tools/tcl/TclReadLine/pkgIndex.tcl"
}

EOF

exec bash --rcfile "$IAM_HOME/bashrc" -i || exec $SHELL -i
