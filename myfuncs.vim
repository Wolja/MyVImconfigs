"vim:foldmethod=marker:foldclose=all:tw=78:ts=8

"================= Begin Someshit ========================================{{{
"
"
" Updates my Help file from the backup file I edit
function! Someshit()
    :silent! !copy "c:\work docs\vimutils\vimtips\commands_back.txt" C:\Progra~2\Vim\vimfiles\doc\sfcontents.txt 
    :silent! !copy "C:\work docs\vimutils\help\usefulcommands.txt" C:\Progra~2\Vim\vimfiles\doc\sfuseful.txt
    :chdir $VIM/vimfiles/doc
    :helptags $VIM/vimfiles/doc/
    :silent! !copy C:\Progra~2\vim\vim74\syntax\help.vim "c:\work docs\vimutils\vimtips\help_back.vim"
    :silent! !copy C:\Progra~2\vim\vimfiles\myfuncs.vim "c:\work docs\vimutils\vimtips\myfuncs_back.vim"
endfunction
"================= End Someshit ====================================================}}}

"=================== Begin MapKeys() ===================================================={{{

"Create a file listing current key mapping
function! MapKeys()
    :chdir C:\work\ docs\vimutils\list
    :silent! redir! > vim_maps.txt
"    :verbose map
    :silent! let 
    :silent! verbose map!
    :silent! reg
    :silent! highlight
    :redir END
endfunction

"========================== End MapKeys() =============================================}}}

"==================== Begin JoinLines() ===================={{{
"Set nowrap off, define a macro to Join text copied from someplace where it
"splits the lines
"
function! JoinLines()
    :set nowrap
    :set noexpandtab
    :let @q='0$a	Jj'
    :%s/\s*$//g
    :1
endfunction

"==================== End JoinLines() ====================}}}

"==================== Begin UnJoinLines() ================================================{{{

"fix it up
function! UnJoinLines()
    :set wrap
    :set expandtab
    :let @q=""
endfunction

"==================== Begin UnJoinLines() =============================================}}}

"=============== Begin CleanAcc ==========================================={{{

"Clean up Access Export Function
function! CleanAcc()
    "Nowrap
    :set nowrap
    "Delete empty Lines
    :g/^\s$/d
    :g/^$/d
    
    "replace all lines starting with path with blank line
    :%s/^c\:\\.*//g
    
    "Get rid of the Page Numbers and replace them with two tabs
    :%s/\v\spage:\s*\d*$/		/g

    "Change Size to Comment"
    :%s/\sSize/	Comment/g

    "Cut the size column data Out
    :%s/\v(\d+$)//g

    "Replace ^tab
    :%s/\v\s{3,}/	/g
    :%s/^\s//g

    "clean data types
    :%s/short text\|long] text/Text/g
    :%s/decimal/Numeric/g
    :%s/Date With Time/Datetime/g
    :%s/Long Integer/Integer/g
    :%s/Yes\/No/Bit/g

    "Delete the word column on it's own
    :g/\v^col\S+s$/d
endfunction
"=========== End CleanAcc ==================================================}}}

"============= Begin FixXml ==================================================={{{

"Unwrap and clean extra spaces from xml files. The @w handles moving comments
"on their own to the previous line
":let @w='ggj/^<!--kJggj@w'
function! FixXml()
    "Find a way to ignore warnings
    "
    "fix xml with spaces and unjoin the lines 
    "Replace nbsp with space
    :%s/\%xa0/ /g
    "replace >space(s)< with ><
    :%s/\v(\>)(\s+)(\<)/\1\3/g
    "Replace 2 or more spaces with one space
    :%s/\v(\s{2,})//g
    "Put a new line in between >< to make XML split out into multiple lines
    :%s/></>\r</g
    "Put a new line before <?x
    :%s/^<?x/\r&/g
    "Set filetype = xml
    :set ft=xml
endfunction
"=========== End FixXml ==================================================}}}

"==================== Begin Unfixxml ==============={{{
"Put split xml back together, ie join the lines where it ends with > and the
"next begins with <
"
"Added range command so can call it now like :.,$ call UnFixxml() or :'a,'b
"call UnFixxml() etc.
"Calling it withut a range executes the function on the current line

function! UnFixXml() range
"    echo a:firstline
"    echo a:lastline
    let froml = a:firstline 
    let tol = a:lastline 
    :execute (a:firstline) . "," . a:lastline . 's/>\s\+$/>/ge'
    :execute (a:firstline) . "," . a:lastline . 's/>\n</></g'
endfunction
"==================== End Unfixxml ===============}}}

"=========== Begin MakeDealerUnique ===================================={{{

function! MakeDealerUnique(runvar)
    let noruns = a:runvar
    let i = 0
    
    while i <= noruns 
       "Move to end of File and moveback to first pattern to yank
        :normal! G$F<
        "Yank to end of line into register m
        :normal! "my$
        "Move to Begiining of line
        :normal! 0
        "Yank 4 words to register n
        :normal! "n4yw
        "Delete Line
        :normal! dd
        "Go back to safe spot, ie before running insert !z!# above the dedupe
        "data lines
        execute "call search('!z!#','b')"
        "Search for the data to replace
        execute "call search('".@n."','b')"
        "Arse about way to replace it
        let subCommand=". s/".@n."/".@m."/"
        execute subCommand
        let i += 1
    endwhile
endfunction
"=========== End MakeDealerUnique =======================================}}}

"==================== Begin saved regs ===================={{{
"let@l='gg:let @m="":let @n="""m3yiw/\sw"nyiw:b\mgg/contractn/\ddwin/vin>2wdw:wqdd:w'
"Run through a prepared file that needs new contract numbers.
"Then
"Go to beginning and clear @m and @n
"gg:let @m="":let @n=""
"Yank file name to @m find a space forward and yank the contract number to @n
"
"  ! "m3yiw/\sw"nyiw ! 
"
" Set @b to something like silent! sp! h:\stevep\xmls then open the file m
"  :b\m
"
" Go to the beginning in case it's got a previous swap and search for
" contractnum and change the value to the contents of @n
"  gg/contractn/\ddwin
"
" Search for vin> delete the contents. Write and quit the file and delete
" the processed line. Save the source file in case of crash
"  /vin>2wdw:wqdd:w'

"==================== End saved regs ====================}}}

"=========== End ProcessFile ================================================{{{
"gg:let @m="":let @n="""m3yiw/\sw"nyiw:b\mgg/contractn/\ddwin/vin>2wdw:wqdd:w
function! ProcessFile()
    :normal gg
    :normal qmq
    :normal qnq
    :normal "m3yiw
    :execute "call search(' ','')"
    :normal e
    :normal "nyiw
    :let @b=" h:\\stevep\\testxml\\"
    :let @c=@b.@m
    :sp! '".c."'


endfunction
"=========== End ProcessFile ================================================}}}

"=========== Begin  CleanCtrlChar ==============================================={{{
"function!  CleanCtrlChar()
"    "Remove Ctrl Chars from file eg  or  etc
"
"    :%s/[]//ge
"    :%s/[ ]//ge 
"    :%s/[]//ge
"endfunction

"============ End CleanCtrlChar =================================================}}}

"==================== Begin Old Funcs ==============={{{
"Old function
"Define a macro to join line followed by ^des*:
":let @a='ga/^des.*:kgJ2dw@a'
"function! CleanAcc()
"    "Get the Description Lines at the first column
"    :%s/\v^(\s+)(des\S+n:.*)/\2/g
"    "Move the Column Names back to First Column
"    :%s/\v^\s{9}//g
"    "Delete empty Lines
"    :g/^$/d
"    "Delete lines starting with a space
"    :g/^\s\+\S\+/d
"    "Delete all the file path 
"    :g/^c\:\\/d
"    :%s/\v^(table:)/\r&\r/g
"    "Get rid of all the other Table lines
"    :2,$ g/^table:/d
"    "Get rid of the Page Numbers and replace them with two tabs
"    :%s/\v\s+Pag\S.*$/		/g
"    "Replace 3 or more spaces with a tab
"    :%s/\v\s{3,}/	/g
"    "Delete lines starting with Columns
"    :g/^col\S\+$/d
"    "Cut the size column out
"    :%s/\v^(.*	.*	)(\S.*$)/\1/g
"    normal @a
"    :%s/^       $//g
"    :g/^$/d
""    normal! silent! @a
"    "Delete the word description. MUST follow n@a
""    :%s/\v(	)(des\S+	)(\S.*$)/\1/g
""    :%s/\v^(\s+)//g
""    :g/^na..\s\+ty/d
""    :%s/\%>54v.*$//g
""    :%s/\v\s+$//g
"    :let @q='gg/^re;�kbl\S\+$ma/^$kmb:''a,''b d'
"    "Clear the registers
"    :let @q=""
"endfunction

"==================== End Old Funcs ===============}}}

"================== Begin AutoHighlightToggle() =========================={{{
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
    let @/ = ''
    if exists('#auto_highlight')
        au! auto_highlight
        augroup! auto_highlight
        setl updatetime=4000
        echo 'Highlight current word: off'
        return 0
    else
        augroup auto_highlight
            au!
            au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
        augroup end
        setl updatetime=500
        echo 'Highlight current word: ON'
        return 1
    endif
endfunction

"==================End AutoHighlightToggle ==================================}}}

"==================== Begin SQLFormatting ==============={{{
function! SQLFormatting()
    """"""""""""""""""""""" Formatting of a SQL-Statement """"""""""""""""""""""""
    """""""""""""""""""""""""" Joachim Hofmann 01.12.2002 """""""""""""""""""""""""
    " Step 1a) before 1b): remove preceding spaces
    %s/^ \+//e
    %s/ \+$//e
    " Step 1b) break lines after common SQL keywords
    %s/[^^]\<from\>\|[^^"]\<where\>\|[^^"]\<set\>\|[^^"]\<on\>\|[^^"]\<union\>\|[^^"]\<order\>\|[^^"]\<and\>\|[^^"]\<or\>\|[^^"]\<group by\>/\r&/ge
    " --
    " Step 2a) before 2b): remove preceding spaces
    %s/^ \+//e
    " Step 2b) break lines after commas (',')
    " but *not* inside of functions (..) and *not* if comma is at the end of a line
    if v:version >= 600
        normal 1G
        %s/\(([^()]*\)\@<!,\([^$]\)\([^()]*)\)\@!/,\r\2/ge
    else
        " (older vims can not do the complex regexp above, so just break after ',')
        normal 1G
        %s/,/,\r/gce
    endif
    " --
    " Step 3) Remove remaining preceding and following spaces
    " and change remaining multiple spaces to a single space
    %s/^ \+//e
    %s/ \+$//e
    %s/ \+/ /ge
    %s/=/= /ge
    %s/</ </ge
    %s/>/ >/ge
endfunction
"==================== End SQLFormatting ===============}}}

"==================== Begin WordCount ==============={{{
" Function to display wordcount in status bar
"
let g:word_count="<unknown>"
function! WordCount()
    return g:word_count
endfunction
function! UpdateWordCount()
    let lnum = 1
    let n = 0
    while lnum <= line('$')
        let n = n + len(split(getline(lnum)))
        let lnum = lnum + 1
    endwhile
    let g:word_count = n
endfunction
" Update the count when cursor is idle in command or insert mode.
" Update when idle for 1000 msec (default is 4000 msec).
set updatetime=4000
augroup WordCounter
    au! CursorHold,CursorHoldI * call UpdateWordCount()
augroup END

"==================== End WordCount ===============}}}

"==================== Begin SavePos() ==============={{{
" Folkes auto-reindenter
function! SavePos()
    let g:restore_position_excmd = line('.').'normal! '.virtcol('.').'|'
endfun
function! RestorePos()
    exe g:restore_position_excmd
    unlet g:restore_position_excmd
endfun

"==================== End SavePos() ===============}}}

"==================== Begin ShowFunc() ==================== {{{
function! ShowFunc() 

    let gf_s = &grepformat 
    let gp_s = &grepprg 
    let &grepformat = '%*\k%*\sfunction%*\s%l%*\s%f %*\s%m' 
    let &grepprg = 'ctags -x --c-types=f --sort=no -o -' 
    write 
    silent! grep % 
    cwindow 
    let &grepformat = gf_s 
    let &grepprg = gp_s 
endfunc 
if &readonly
    if version >= 502
        function! PageSpace()
            if line(".") != line("$")
                normal L
            elseif argc() != 0 && bufnr("%") != argc()
                next
                normal L
            else
                quit
            endif
        endfunction
        noremap <Space> :call PageSpace()<CR>:<CR>
    else
        noremap <Space> :if line(".")!=line("$")<Bar>exe "norm <C-F>L"<Bar>el<Bar>q<Bar>en<CR>:<CR>
    endif
    noremap <CR> :if line(".")!=line("$")<Bar>exe "+"<Bar>el<Bar>q<Bar>en<CR>:<CR>
    noremap b <C-B>L
    noremap d <C-D>L
    noremap u <C-U>L
    noremap j <C-E>L
    noremap k <C-Y>L
    noremap <C-N> :n<CR>L
    noremap q     :q<CR>
    map     v     <Tab>ed
else
    noremap <Space> <Space>
    noremap <CR>    <CR>
    noremap b b
    noremap d d
    noremap u u
    noremap j j
    noremap k k
    noremap <C-N> :n<CR>
    noremap <C-w>  :wa<CR>
    noremap v     v
endif
"
"==================== End ShowFunc() ====================}}}

"==================== Begin Start of Cobol Fix ==============={{{
"Indent 
"%s/^@\*/     &/g
"==================== End Start of Cobol Fix ===============}}}

"==================== Test Crap ==============={{{
"Test Crap
"function Refactor()
"
"        " what is the proper syntax to do this assignment ?
"            let parent_array = /\zs\$this\[.*\]\ze = array()\_s{;
"
"                if (parent_array)
"                    jjvi{
"                    '<,'>s/\= parent_array . '\[\([^=]\+\)] = \(.*\);'/'\1' => \2,
"                endif 
"endfunction
" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.

"==================== Test Crap ===============}}}
