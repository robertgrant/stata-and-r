library(haven)
library(glmnet)
library(dplyr)
source('moredata.R') # get scalar
auto <- read_dta('auto.dta') # get data
predictors <- as.matrix(select(auto, -one_of(c('mpg'))))
mpg <- unlist(select(auto, mpg))
lasso <- glmnet(x=predictors, y=mpg, family='gaussian', alpha=myalpha)
crossval <- cv.glmnet(x=predictors, y=mpg, family='gaussian', alpha=myalpha)
png('crossvalidation.png'); plot(crossval); dev.off();
beta_lasso <- as.matrix(coef(crossval, s = 'lambda.min'))
#statado(matrices='beta_lasso', dofile='results.do'
print(as.matrix(beta_lasso))
