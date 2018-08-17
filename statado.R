# a function to write out numeric vectors and matrices, as well as 
# atomic doubles and strings into a text file that Stata can read in.
#
# vectors and matrices in R become matrices in Stata
# zero-dimensional numerics and strings become global macros.
#
# Robert Grant, BayesCamp

statado <- function(vectors=NULL,
                    matrices=NULL,
                    strings=NULL,
                    numerics=NULL,
                    dofile='fromR.do') {
  con <- file(dofile,'w')
  if(!is.null(matrices)){
    for(m in matrices) {
      if(all(is.numeric(get(m)))){
        mr <- nrow(get(m))
        mc <- ncol(get(m))
        cat(paste('matrix ',m,' = ['),file=con)
        # loop over rows then columns
        for(i in 1:mr) {
          for(j in 1:mc) {
            cat(get(m)[i,j],file=con)
            if(j==mc & i<mr) {
              cat(" \\ ",file=con)
            }
            else if(j<mc | i<mr) {
              cat(" , ",file=con)
            }
            else{
              cat("]\n", file=con)
            }
          }
        }
      }
    }
  }
  if(!is.null(vectors)){
    for(v in vectors) {
      if(is.numeric(get(v))){
        vl<-length(get(v))
        cat(paste0('matrix ',v,' = ['),file=con)
        for(i in 1:vl) {
          cat(get(v)[i],file=con)
          if(i<vl) {
            cat(" , ",file=con)
          }
        }
        cat("]\n",file=con)
      }
    }
  }
  if(!is.null(numerics)){
    for(n in numerics) {
      if(is.numeric(get(n)) & length(get(n))==1){
        write(paste0("global ",n," = ",get(n)),file=con)
      }
    }
  }
  if(!is.null(strings)){
    for(s in strings) {
      if(is.character(get(s)) & length(get(s))==1){
        write(paste0("global ",s," = \"",get(s),"\""),file=con)
      }
    }
  }
  close(con)
}
