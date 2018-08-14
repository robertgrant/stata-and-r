# Sharing data between Stata and R

rdump.ado is a Stata ado file that provides a new command, which writes selected matrices and global macros into a text file that can be read by R to bring the data into an R environment.

Example:

```
sysuse auto, clear
quietly regress mpg price
matrix BETA = e(b)
global rmse = e(rmse)
rdump, globals(rmse) matrices(BETA) rfile('mydata.R')
```
