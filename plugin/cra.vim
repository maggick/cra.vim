autocmd! BufWritePost cra.vim source ~/.vim/bundle/cra.vim/plugin/cra.vim

let g:HeaderHeight = 2

if !exists("g:NbCPPerYear")
    let g:NbCPPerYear = 25
endif

if !exists("g:NbRTPerYear")
    let g:NbRTPerYear = 12
endif

if !exists("g:NbRemainingCP")
    let g:NbRemainingCP = 49
endif

let g:WWCol = 96
let g:CPCol = WWCol + 3
let g:RTCol = WWCol + 3 + 3
let g:CECol = WWCol + 3 + 3 + 3
let g:MACol = WWCol + 3 + 3 + 3 + 3

"French Public Holiday
let g:FE = {'2013':['1-1', '4-1', '5-1', '5-8', '5-9', '5-20', '7-14', '8-15', '11-1', '11-11', '12-25'], 
           \'2014':['1-1', '4-21', '5-1', '5-8', '5-29', '6-9', '7-14', '8-15', '11-1', '11-11', '12-25']}

function! IsPublicHoliday(year, month, day)
    let ret = 0
    if has_key(g:FE, a:year)
        let i = 0
        while i < len(g:FE[a:year])
            if (a:month . '-' . a:day == g:FE[a:year][i])
                let ret = 1
            endif
            let i += 1 
        endwhile
    endif
    return ret
endfunction

function! Bootstrap(year, country)
    let i = 1
    call Headerq()
    while i <= 12
        " is there a simpler way to insert newline without indent
       execute "normal! o\<ESC>0i\<c-r>=Line2(" . a:year . ", " . i . ", '" . a:country . "')\<CR>\<ESC>"
       let i += 1
    endwhile
endfunction

function! Headerq()
   execute "normal! i                                                                                               |    MENSUEL   |SOLDE\<ESC>"
   execute "normal! o\<ESC>0i    1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31|WW CP RT CE MA|CP RT\<ESC>"
endfunction

function! Line2(year, month, country)
    return printf('%2s', a:month) . ' ' . Line(a:year, a:month, a:country)
endfunction

" create a format method to format month, day, and nunber
function! Line(year, month, country)
    let i = 1
    let s = ''
    "todo all month don't have 31 days
    "todo use strftime instead of system call to date
    while i <= 31
        let day = system('date -d ' . a:year . '-' . a:month . '-' . i . ' +%u')
        let day = substitute(day, '\n', '', 'g')
        if (day == 6 || day == 7)
            let sday = 'XX'
        elseif (a:country == 'fr' && IsPublicHoliday(a:year, a:month, i))
            let sday = 'FE'
        else
            let sday = '--'
        endif

        let s = s . sday . ' '
        let i = i + 1
    endwhile
    return strpart(s, 0, len(s) - 1) . '|'
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
    let monthlyCounters  = []
    call add(monthlyCounters,NbWork())
    call add(monthlyCounters,NbCP())
    call add(monthlyCounters,NbRT())
    call add(monthlyCounters,NbCE())
    call add(monthlyCounters,NbMA())

    let soldeCounters  = []
    call add(soldeCounters, printf('%2s', GetTotalCP(line('.') - g:HeaderHeight)))
    call add(soldeCounters, printf('%2s', GetTotalRT(line('.') - g:HeaderHeight)))

    return join(monthlyCounters, ' ') . '|' . join(soldeCounters, ' ')
endfunction

"method list(1,2,3) -> " 1  2  3" : 2 digits formatting and space separated

"remove beggining space for avoid vim coercion strangeness
function! GetValueAsNum(month, pos)
    return substitute(strpart(getline(a:month+g:HeaderHeight), a:pos, 2), ' ', '', 'g')
endfunction
    
function! GetCP(month)
    return GetValueAsNum(a:month, CPCol)
endfunction

function! GetTotalCP(month)
    if (a:month == 1)
        " Solde CP2 sur la paye de janvier
        let prev = g:NbRemainingCP
    elseif (a:month == 6)
        " remove code duplicate
        let prev = g:NbCPPerYear + GetValueAsNum(a:month - 1, 111)
    else
        let prev = GetValueAsNum(a:month - 1, 111)
    endif
    "return prev - GetCP(a:month)
    return prev - substitute(NbCP(), ' ', '', 'g')
endfunction

function! GetRT(month)
    return GetValueAsNum(a:month, RTCol)
endfunction

function! GetTotalRT(month)
    if (a:month == 1)
        let prev = g:NbRTPerYear
    else
        let prev = GetValueAsNum(a:month - 1, 111 + 3)
    endif
    return prev - substitute(NbRT(), ' ', '', 'g')
endfunction

nnoremap <leader>cm A<c-r>=Nbs()<cr><esc>
nnoremap <leader>cy :3,$normal <leader>cm<cr>

