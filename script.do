use 'nlsw88.dta', clear // get the data
do moredata.do // get the scalar
regress wage age i.race i.married, vce(bootstrap, reps(${n_reps}))
matrix BC = e(ci_bc)'
matrix list BC
rdump, matrices('BC') rfile('results.R')
