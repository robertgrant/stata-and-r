# Sharing data between Stata and R

rdump.ado is a Stata ado file that provides a new command, which writes selected matrices and global macros into a text file that can be read by R to bring the data into an R environment.

Example:

```
sysuse auto, clear
quietly regress mpg price
matrix BETA = e(b)
global rmse = e(rmse)
rdump, globals(rmse) matrices(BETA) rfile(mydata.R)
```

statado.R contains an R function called statado, which writes selected numeric matrices, numeric vectors, numeric scalars and single strings into a text file that Stata can read in as a .do file.

Example:

```
matrix1 <- matrix(1:4,nrow=2)
matrix2 <- matrix1^2
my_vector <- c(5,9,1)
my_scalar <- 14.1
my_string <- "abc"
statado(matrices=c("matrix1","matrix2"),
   vectors="my_vector",
   numerics="my_scalar",
   strings="my_string",
   dofile="somedata.do")
```

The other files here relate to the [BayesCamp](https://www.bayescamp.com) online workshop "Using Stata and R Together". The stata-and-r.md Markdown file produces [mdp](https://github.com/visit1985/mdp) slides.
