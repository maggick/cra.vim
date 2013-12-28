if exists("b:current_ayntax")
    finish
endif

syntax keyword craKeyword WW FE
highlight link craKeyword Keyword

syntax keyword qqqKeyword XX
highlight link qqqKeyword Comment

syntax keyword wwwKeyword CP CE RT
highlight link wwwKeyword Error

syntax keyword rrrKeyword MA
highlight link rrrKeyword Debug


let b:current_syntax = "cra"
