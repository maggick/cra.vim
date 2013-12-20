autocmd! BufWritePost cra.vim source ~/.vim/bundle/cra.vim/plugin/cra.vim

let g:HeaderHeight = 2

function! Bootstrap(year)
    let i = 1
    call Headerq()
    while i <= 12
        " is there a simpler way to insert newline without indent
       execute "normal! o\<ESC>0i\<c-r>=Line2(" . a:year . ", " . i . ")\<CR>\<ESC>"
       let i += 1
    endwhile
endfunction

function! Headerq()
   execute "normal! i                                                                                                    MENSUEL   |SOLDE\<ESC>"
   execute "normal! o\<ESC>0i    1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31|WW CP RT CE MA|CP RT\<ESC>"
endfunction

function! Line2(year, month)
    return printf('%2s', a:month) . ' ' . Line(a:year, a:month)
endfunction

" create a format method to format month, day, and nunber
function! Line(year, month)
    let i = 1
    let s = ''
    "todo all month don't have 31 days
    "todo use strftime instead of system call to date
    while i <= 31
        let day = system('date -d ' . a:year . '-' . a:month . '-' . i . ' +%u')
        let day = substitute(day, '\n', '', 'g')
        if (day == 6 || day == 7)
            let sday = 'XX'
        else
            let sday = '--'
        endif

        let s = s . sday . ' '
        let i = i + 1
    endwhile
    return s
endfunction

function! GenericNb(pat)
    return printf('%2s', len(split(getline('.'), a:pat))-1)
endfunction

function! NbWork()
    return GenericNb('WW')
endfunction

function! NbRT()
    return GenericNb('RT')
endfunction

function! NbCP()
    return GenericNb('CP')
endfunction

function! NbCE()
    return GenericNb('CE')
endfunction

function! NbMA()
    return GenericNb('MA')
endfunction

function! Nbs()
    return NbWork() . ' ' . NbCP() . ' ' . NbRT() . ' ' . NbCE() . ' ' .  NbMA() . '|' . printf('%2s', GetTotalCP(line('.')-8)) . ' ' .  printf('%2s', GetTotalRT(line('.')-8))
endfunction

function! Sum(pos)
    let l = 9
    let s = 0
    while l <= 20
        let s = s + substitute(strpart(getline(l), a:pos, 2), ' ', '', 'g')
        let l = l + 1
    endwhile
    return s
endfunction

function! SumWW()
    return Sum(96)
endfunction

function! SumCP()
    return Sum(99)
endfunction

function! SumRT()
    return Sum(96 + 3 + 3)
endfunction

function! SumCE()
    return Sum(96 + 3 + 3 + 3)
endfunction

function! SumMA()
    return Sum(96 + 3 + 3 + 3 + 3)
endfunction

function! GetCP(month)
    return substitute(strpart(getline(a:month+g:HeaderHeight), 99, 2), ' ', '', 'g')
endfunction

function! GetTotalCP(month)
    if (a:month == 1)
        " Solde CP2 sur la paye de janvier
        let prev = 18
    elseif (a:month == 6)
        " remove code duplicate
        let prev = 22 + substitute(strpart(getline(a:month - 1 + g:HeaderHeight), 111, 2), ' ', '', 'g')
    else
        let prev = substitute(strpart(getline(a:month - 1 + g:HeaderHeight), 111, 2), ' ', '', 'g')
    endif
    "return prev - GetCP(a:month)
    return prev - substitute(NbCP(), ' ', '', 'g')
endfunction

function! GetRT(month)
    return substitute(strpart(getline(a:month + g:HeaderHeight), 99+3, 2), ' ', '', 'g')
endfunction

function! GetTotalRT(month)
    if (a:month == 1)
        let prev = 9
    else
        let prev = substitute(strpart(getline(a:month - 1 + g:HeaderHeight), 111+3, 2), ' ', '', 'g')
    endif
    return prev - substitute(NbRT(), ' ', '', 'g')
endfunction

nnoremap <leader>cf A<c-r>=Nbs()<cr><esc>
