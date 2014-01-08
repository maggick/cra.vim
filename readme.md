# CRA
yearly timesheet for Vim

* realtime counter for holiday (while there is a shift of one month on paychecks)
* get rid of Libreoffice (or worse Excel) to do this

How to use it

## Step 0 : (Optionnaly) Add parameters on `.vimrc`
* Please configure your remaining days of annual leave at the beginning of the year (i.e. as mentionned on the january paycheck)

    ```vim
    let g:NbRemainingCP = 18
    ```

* if you don't have 25 days of annual leave (days of seniority, part time)

    ```vim
    let g:NbCPPerYear = 22
    ```

* If you don't have 12 days of RTT

    ```vim
    let g:NbRTPerYear = 9
    ```

## Step 1 : Generate the timesheet for a given year and a country

Edit a new file with .cra extension

```vim
:call Bootstrap(2014, 'fr')
```

Saturday and Sunday are pre-filled with `XX`

Public Holiday are pre-filled with `FE`. Only french public holiday for years 2013 and 2014 are known.

## Step 2 : Fill the timesheet by replacing `--` with a value

Here is the list of values

* `WW` : Work day
* `CP` : Annual leave
* `RT` : RTT
* `CE` : Exceptional leave
* `MA` : Sick leave

## Step 3 : Automatic calculation of counters

* For one month : `<leader>cm`

* For one year : `<leader>cy`

Please define your leader key to make it work.
Default leader key is `\`.

## Example
                                                                                                   |    MENSUEL   |SOLDE
        1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31|WW CP RT CE MA|CP RT
     1 XX WW WW XX XX XX CP CP CP CP XX XX XX CP CP CP CP XX XX XX MA MA MA MA XX XX XX WW WW WW WW| 6  8  0  0  4|10  9
     2 XX XX XX CE WW WW WW XX XX XX CE WW WW WW XX XX XX WW WW WW WW XX XX XX WW WW WW WW -- -- --|14  0  0  2  0|10  9
     3 XX XX XX WW WW WW WW XX XX XX WW WW WW WW XX XX XX WW WW WW WW XX XX XX WW WW WW WW XX XX XX|16  0  0  0  0|10  9
     4 XX WW WW WW XX XX XX WW WW WW CP XX XX XX WW WW WW CE XX XX XX WW WW WW WW XX XX XX WW WW --|15  1  0  1  0| 9  9
     5 XX CP XX XX XX CP CP XX XX XX XX XX WW WW WW WW XX XX XX CP WW WW WW XX XX XX WW WW WW CE XX|10  4  0  1  0| 5  9
     6 XX XX CE WW CP WW XX XX XX WW WW WW WW XX XX XX WW WW WW WW XX XX XX CP CP CP CP XX XX XX --|10  5  0  1  0|22  9
     7 WW WW WW WW XX XX XX WW WW WW WW XX XX XX WW WW WW WW XX XX XX WW WW WW WW XX XX XX WW WW WW|19  0  0  0  0|22  9
     8 WW WW XX XX WW WW WW WW XX XX XX RT RT RT XX XX XX XX RT RT RT RT XX XX XX WW WW WW WW XX XX|10  0  7  0  0|22  2
     9 XX WW WW WW WW XX XX XX WW WW WW WW XX XX XX CE CE WW WW XX XX XX WW WW WW WW XX XX XX WW --|15  0  0  2  0|22  2
    10 WW WW WW XX XX XX WW WW WW WW XX XX XX WW WW WW WW XX XX XX WW WW WW WW XX XX XX WW WW WW WW|19  0  0  0  0|22  2
    11 WW XX XX WW WW WW WW XX XX XX XX WW WW WW XX XX XX WW WW WW WW XX XX XX WW WW WW WW XX XX --|16  0  0  0  0|22  2
    12 XX WW WW WW WW XX XX XX WW WW WW WW XX XX XX WW WW WW WW XX XX XX WW WW XX RT XX XX XX RT CP|14  1  2  0  0|21  0

## Example (with colors)

![example with colors](http://i.imgur.com/J2htPjX.png)
