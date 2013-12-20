# CRA
yearly timesheet for Vim

* realtime counter for holiday (while there is a shift of one month on paychecks)

How to use it

## Step 1 : Generate the timesheet for a given year

`:call Bootstrap(2014)`

Saturday and Sunday are pre-filled with `XX`

## Step 2 : Fill the timesheet by replacing `--` with a value

Here is the list of values

* `WW` : Work day
* `CP` : Annual leave
* `RT` : RTT
* `CE` : Exceptional leave
* `MA` : Sick leave

## Step 3 : Automatic calculation of counters

`:3,$normal ,cf`
