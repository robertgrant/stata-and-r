%title: Using Stata and R Together
%author: Robert Grant
%date: 2018-08-17

-> # Using Stata and R Together <-

-> Robert Grant, BayesCamp <-
-> robert@bayescamp.com <-
-> \@robertstats <-

_Topics:_
* Comparing Stata and R
  - Graphics
  - Data management
  - User interface
  - Programming
  - Analysis
  - Outputs
  - Cost and support
* Components of passing between Stata and R
  - Defining vectors, matrices
  - Write to a text file
  - Sending results back again
  - Call the operating system
  - Run a script
* Examples
* All-in-one commands / functions

-------------------------------------------------

-> # Comparing Stata and R <-

-------------------------------------------------

-> # Comparing Stata and R: Graphics <-

R is generally more flexible but at the cost of working across different
packages with quite different syntax.

Some people manage to work entirely in ggplot2 and compatible
extensions though.

R is notably faster, which matters if you are producing lots of images

Stata's SVG output is the simplest and most human-readable I've found anywhere

Some specific tasks are very easy in Stata, like plotting marginal effects
after a model


-------------------------------------------------

-> # Comparing Stata and R: Data management <-

R can have more than one data file open, plus various arrays

R allows for lists of diverse object types

Stata language for management is easy to learn and use

R's tidyverse packages bring it up to the same ease

-------------------------------------------------

-> # Comparing Stata and R: User interface <-

Stata has drop-down menus if you want them

There are some GUIs for R but they are pretty basic

R users generally have an IDE over R, and most people choose R Studio for this

But you could make your own R GUI for certain tasks if you wanted


-------------------------------------------------

-> # Comparing Stata and R: Programming in Stata (1) <-

Stata is an imperative language, so each line begins with a recognised
command, then maybe some variable names and some options.

To get a logistic regression and then store predicted probabilities as
a new variable, and draw a histogram of them:
```
logistic survival drug age
predict predicted_risk
hist predicted_risk
```

Generally, Stata requires less typing than other analysis software

You can speed up Stata with the lower-level Mata language,
and Java/C/C++ plugins

built-in parallelisation (if you have MP flavor)

-------------------------------------------------

-> # Comparing Stata and R: Programming in R (1) <-

R is a functional language, so it evaluates functions all the time.
We can feed arguments into those functions inside brackets, and every
function returns some object, so we usually have to store it with
the <- assignment

To get a logistic regression and then store predicted probabilities as
a new variable, and draw a histogram of them:
```
myregression <- glm(survival ~ drug + age, family=binomial())
predicted_risk <- predict(myregression, type="response")
hist(predicted_risk)
```

But if you prefer, you can pipe left to right:
```
glm(survival ~ drug + age, family=binomial()) %>% predict(type="response") %>% hist()
```

R features good integration with C++ through the Rcpp package

bespoke parallelisation

-------------------------------------------------

-> # Comparing Stata and R: Programming in Stata (2) <-

You can assign a string or number to a macro in Stata like this:
```
local mymacro = 1
```

and then bring its contents into the middle of anything else you type, like this
```
display 1 + `mymacro'
2
```

There are also global macros, which persist in memory until you close Stata:
```
global mymacro = 1
display 1 + ${mymacro}
2
```

This means you can loop through a series of variable names, parameter values, or
whatever, really easily

-------------------------------------------------

-> # Comparing Stata and R: Programming in R (2) <-

Functions in R can be useful; results from one function evaluation feed
into the next:
`brackets(nested(through(out)))` or `left %>% to %>% right %>% with %>% pipes`

R's vectorisation is useful too, carrying out operations on each element

There are no macros (see
*robertgrantstats.wordpress.com/2013/12/19/giving-r-the-strengths-of-stata/*)

There is a myth that R is slow; that certainly doesn't apply in the
latest versions.

The purrr package now provides a lot of this functionality for lists too

The downside of having more object types / classes is constant conversion


-------------------------------------------------

-> # Comparing Stata and R: Analysis (1) <-

Stata has a lot of economic, econometric, and biomedical techniques
programmed in, plus many more community-contributed commands.

R has a lot of packages offering these, but often you have to work
across multiple packages to get everything you need, and the
differences between packages can complicate things

R has more access to machine learning and big data tools, like Spark,
H2O.ai, Keras etc etc...

-------------------------------------------------

-> # Comparing Stata and R: Analysis (2) <-

It's simpler to bootstrap most estimation and modelling methods in Stata than R

Stata also has simpler multiple imputation.

Stata has a neat structural equation model building interface

R is much stronger in spatial and Bayesian methods

-------------------------------------------------

-> # Comparing Stata and R: Outputs <-

Fancy graphics, like transparent grids over a background map, are
relatively easy to achieve in R

You can produce Markdown, HTML and other format outputs in R using
rmarkdown, knitr, etc. and this is well integrated in R Studio

You can produce Markdown, HTML and other format outputs in Stata
using version 15's webdoc and dyndoc, or some user-written packages

-------------------------------------------------

-> # Comparing Stata and R: Cost and support <-

Stata costs about 950 GBP for a single business user; the license lasts forever

R is free (unless you get some commercial version like Revolution Analytics)

You get official customer support with Stata (very good in my experience)

Both have strong, supportive user communities; the same cannot be said
of other stats software

-------------------------------------------------

-> # Components of passing data and code <-

-------------------------------------------------

-> # Components of passing data and code (1) <-

You can record all your data manipulation and analysis in one
.do or .R file, including sections of code for the other software

This helps with version control, audit trail and debugging

Chunks of code need to be written into files (.R / .do) that the
other software can run

Scalars, vectors, matrices need to be written out into a .R or
.do file too

Exchanging data files is best done using .dta files; R's haven
package deals with this easily

Then, send an instruction to the operating system to fire up
the software and run the script file you supplied.


-------------------------------------------------

-> # Components of passing data and code (2) <-

The basic procedure is:

* Write the data to .dta

* Write other data (matrices etc) to .R or .do format

* Write the script to .R or .do format

* Call Rscript or Stata

* Read the results back in using source() or -do-

-------------------------------------------------

-> # Components: A note on operating systems and text editors <-

OSs affect some of the code that follows

For example, file paths and naming an executable file

Windows backslashes have to be written as forward slashes in R

A text editor is useful, although you can get by in RStudio or Stata's
do-file editor. I use Atom but there are plenty of others.


-------------------------------------------------

-> # Components: Essential file paths <-

Find your Stata executable files:
Type in Stata: `sysdir`

Find your Rscript executable file:
Type in OS X / Linux terminal: `which Rscript`
Type in Windows command line: `where Rscript`

-------------------------------------------------

-> # Defining matrices and globals (Stata) <-

```
matrix A = (1, 2 \ 3, 4)

global value1 = 3
global value2 = "Hello world"

logistic low smoke age
matrix BETA = e(b)
```

matrices are listed along the rows first in Stata and columns first in R


-------------------------------------------------

-> # Defining vectors, matrices (R) <-

```
my_vector <- c(1,4,8,3)

my_matrix <- matrix(my_vector,nrow=2)

BETA <- glm(survival ~ drug + age, family=binomial())$coefficients
```

-------------------------------------------------

-> # Components: Write to a text file from Stata (1) <-

Sergio Correia's block command

```
net from "https://raw.githubusercontent.com/sergiocorreia/stata-misc/master/"
capture ado uninstall block
net install block
block, file("myfile.txt") verbose
    Hello, world.
    This is a text file.
endblock
```

-------------------------------------------------

-> # Components: Write to a text file from Stata (2) <-

The Charles Opondo method (core Stata only)

```
    tempname handle
    file open `handle' using "myfile.txt", write replace
    #delimit ;
    foreach line in
      "Hello, world."
      "This is a text file."
    {;
      #delimit cr
      file write `handle' "`line'" _n
    }
    file close `handle'
```

-------------------------------------------------

-> # Write to a text file (Stata 3) <-

You can use this to write an R script file:

```
tempname handle
file open `handle' using "script.R", write replace
#delimit ;
foreach line in
  "library(ggplot2)"
  "library(haven)"
  "# read in the data"
  "nlsw88 <- read_dta('nlsw88.dta')"
  "# make a hexagonal bin scatterplot"
  "png('hexbin.png')"
  "ggplot(nlsw88, aes(hours, wage)) + geom_hex()"
  "dev.off()"
{;
  #delimit cr
  file write `handle' "`line'" _n
}
file close `handle'
```

-------------------------------------------------

-> # Write to a text file (Stata 4) <-

Or to send data that won't transfer in the .dta file:

```
tempname handle
file open `handle' using "moredata.R", write replace
#delimit ;
foreach line in
  "test_values <- c(1.2, 1.4, 2.5, 3.1)"
  "filename <- 'my_analysis'"
  "covariance <- matrix(c("
  "  4, 2.4, 2.4, 4"
  "), nrow=2)"
{;
  #delimit cr
  file write `handle' "`line'" _n
}
file close `handle'
```

-------------------------------------------------

-> # Write to a text file (R 1) <-

```
con <- file('myfile.txt', 'w')
write('Hello, world.',con)
write(c(
'This is a text file',
'three lines long'),con)
close(con)
```

-------------------------------------------------

-> # Write to a text file (R 2) <-

You can use this to write a Stata do-file:

```
con <- file('script.do', 'w')
write(c(
'log using stata_log.txt, text replace',
'use "nlsw88.dta", clear',
'regress wage age i.race i.married, vce(bootstrap)',
'estat bootstrap, bc',
'log close'
),con)
close(con)
```


-------------------------------------------------

-> # Write to a text file (R 3) <-

Or to send data that won't transfer in the .dta file:

```
con <- file('moredata.do', 'w')
write(c(
'global filename "my_analysis"',
'matrix define test_values = [1.2, 1.4, 2.5, 3.1]',
'matrix define covariance = [4, 2.4 \ 2.4, 4]'
),con)
close(con)
```


-------------------------------------------------

-> # Sending results back again <-

From either Stata or R, you could write out results into a .do or .R file so
that they can be read in when control returns to the original software.

However, this usually involves tedious coding to split up matrices, so I made
a Stata command called *rdump* and an R function called *statado* which will
mostly automate this for you.

rdump accepts names of global macros and matrices (and variables in the data,
if you want), and writes them into a .R file

statado does likewise with names of matrices or vectors, provided they are
numeric or string in type, and single strings, writing them into a .do file

You can get them from *github.com/robertgrant/stata-and-r*


-------------------------------------------------

-> # Call the operating system <-

Stata (Windows): `shell winver`

Stata (OS X): `shell date "+The time is %H:%M" | say`

You can replace shell with \!

Stata's shell waits for the process you start to finish before moving
ahead in the do-file; there is also winexec, which does not wait

R (Windows): `system('winver')`

R (OS X): `system('date "+The time is %H:%M" | say')`


-------------------------------------------------

-> # Calling Rscript or Stata from the command line <-

Stata to R and back:
```
shell /usr/local/bin/Rscript -e "exp(1)"
shell /usr/local/bin/Rscript -e "x <- 1:4; y <- c(10,13,12,15); summary(lm(y~x));"
shell /usr/local/bin/Rscript -e "source('script.R')"
```
(you will need to find your own Rscript location)

R to Stata and back:
```
system('"C:\Program Files\Stata15\StataMP" /e do C:\data\script.do')
system('/Applications/Stata/StataMP -e do script.do')
```


-------------------------------------------------

-> # Summing up <-

* Write the data to .dta

* Write other data (matrices etc) to .R or .do format

* Write the script to .R or .do format

* Call Rscript or Stata

* Read the results back in using source() or -do-


-------------------------------------------------

-> # Examples <-


-------------------------------------------------

-> # Example 1: Stata to R and back (1) <-

We are going to fit a lasso regression in R

Send the data and a scalar:

```
sysuse auto, clear
save "auto.dta", replace

global glmnet_alpha = 1
tempname handle
file open `handle' using "moredata.R", write replace
file write `handle' "myalpha <- ${glmnet_alpha}" _n
file close `handle'
```

-------------------------------------------------

-> # Example 1: Stata to R and back (2) <-

Send the script, including reading in data, vector,
and sending back to a .do file

```
tempname handle
file open `handle' using "script.R", write replace
#delimit ;
foreach line in
  "library(haven); library(glmnet); library(dplyr);"
  "source('moredata.R') # get scalar"
  "auto <- read_dta('auto.dta') # get data"
  "predictors <- as.matrix(select(auto, -one_of(c('mpg','make'))))"
  "mpg <- unlist(select(auto, mpg))"
  "lasso <- glmnet(x=predictors, y=mpg, family='gaussian', alpha=myalpha)"
  "crossval <- cv.glmnet(x=predictors, y=mpg, family='gaussian', alpha=myalpha)"
  "png('crossvalidation.png'); plot(crossval); dev.off();"
  "beta_lasso <- coef(crossval, s = 'lambda.min')"
  "statado(list(beta_lasso=beta_lasso), file='results.do'"
{;
  #delimit cr
  file write `handle' "`line'" _n
}
file close `handle'
```

-------------------------------------------------

-> # Example 1: Stata to R and back (3) <-

Finally, run the R script and read the results back in

```
shell /usr/local/bin/Rscript -e "source('script.R')"
do "results.do"
matrix list beta_lasso

// compare with plain regression
regress mpg price headroom trunk weight length turn displacement ///
  gear_ratio foreign
```

-------------------------------------------------

-> # Example 2: R to Stata and back (1) <-

We are fitting a regression to the NLSW88 dataset, and the outcome
variable (wage) is not really normal. So, we will use Stata's easy
bootstrapping to give us more robust confidence intervals.

Send the data and a scalar:

```
library(haven)
write_dta(nlsw88, 'nlsw88.dta')

con <- file('moredata.do', 'w')
write(c(
'global n_reps = 100'
),con)
close(con)
```


-------------------------------------------------

-> # Example 2: R to Stata and back (2) <-

Write the script.do file:

```
con <- file('script.do', 'w')
write(c(
"use "nlsw88.dta", clear // get the data",
"do moredata.do // get the scalar",
"regress wage age i.race i.married, vce(bootstrap, reps(${n_reps}))",
"matrix BC = e(ci_bc)'",
"matrix list BC",
"rdump, matrices("BC") rfile("results.R")"
),con)
close(con)
```


-------------------------------------------------

-> # Example 2: R to Stata and back (3) <-

Call Stata, and read the results back in:

```
system('/Applications/Stata/Stata.app/Contents/MacOS/StataMP -e do script.do')
source('results.R')
print(BC)
```


-------------------------------------------------

-> # Further learning <-

*R:*
* The Art of Programming R - Norman Matloff
* Advanced R - Hadley Wickham
* DataCamp courses

*Stata:*
* Programming Stata - Christopher Baum
* StataCorp / Timberlake courses


-------------------------------------------------

-> # Thanks for joining this BayesCamp workshop <-

Questions: robert@bayescamp.com
