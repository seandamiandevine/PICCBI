
setwd('~/Desktop/Ongoing/PICCBI/Full/Models/RTF_AE')
source('models.R')

d = read.csv('clean_dat.csv')
models = data.frame()
Niter = 1
alreadyfit = list.files('out/')
alreadyfit = sapply(alreadyfit, function(x) strsplit(x,split = '\\.')[[1]][1])

for(id in unique(d$subject)){
  if(id %in% alreadyfit) next
  cat('----------', match(id,unique(d$subject)), '/', length(unique(d$subject)), '----------\n')
  sub = d[d$subject==id, ]
  choices = sub$key_press
  stim = sub$size0
  
  bestCtlLL = 1e6
  bestCtlOpt = list()
  bestMWLL = 1e6
  bestMWOpt = list()
  bestRTFLL = 1e6
  bestRTFOpt = list()
  for(iter in 1:Niter) {
    cat('*** iteration', iter, '/', Niter, '***\n')
    # Control model 
    cat('fitting Ctl model || ')
    
    obfunc = function(params) {
      LL = -sum(log(ControlMod(choices, stim, params=params)))
      min(LL, 1e6)
    }
    while(1){
      tau0 = runif(1, 0.001, 1)
      sigma0 = runif(1, 0.001, 1)
      x0 = c(tau0, sigma0)
      if(!is.na(obfunc(x0)) & obfunc(x0)<1e6) break
    }
    optControl = optim(par=x0, fn=obfunc)
    if(optControl$value<bestCtlLL) {
      bestCtlLL = optControl$value
      bestCtlOpt = optControl
    }

    # Moving Window model 
    cat('fitting Moving Window model || ')
    obfunc = function(params) {
      LL = -sum(log(MovingWindow(choices, stim, params)))
      min(LL, 1e6)
    }
    while(1){
      tau0 = runif(1, 0.001, 1)
      sigma0 = runif(1, 0.001, 1)
      alpha0 = runif(1, 0.001, 1)
      x0 = c(tau0, sigma0, alpha0)
      if(!is.na(obfunc(x0)) & obfunc(x0)<1e6) break
    }
    optMW =  optim(par=x0, fn=obfunc)
    if(optMW$value<bestMWLL) {
      bestMWLL = optMW$value
      bestMWOpt = optMW
    }
    
    # RTF model 
    cat('fitting RTF model \n')
    obfunc = function(params) {
      LL = -sum(log(RTF(choices, stim, params)))
      min(LL, 1e6)
    }
    while(1){
      tau0 = runif(1, 0.001, 1)
      sigma0 = runif(1, 0.001, 1)
      nk0 = runif(1, 1, 10)
      x0 = c(tau0, sigma0, nk0)
      if(!is.na(obfunc(x0)) & obfunc(x0)<1e6) break
    }
    optRTF = optim(par=x0, fn=obfunc)
    if(optRTF$value<bestRTFLL) {
      bestRTFLL = optRTF$value
      bestRTFOpt = optRTF
    }
  }
  
  # Save
  models_sub = data.frame(
    id = rep(id, 8), 
    condition = rep(sub$condition[1], 8), 
    model = c(rep('Ctl', 2), rep('MW', 3), rep('RTF', 3)), 
    pars = c(bestCtlOpt$par, bestMWOpt$par, bestRTFOpt$par), 
    LL = -c(rep(bestCtlOpt$value, 2), rep(bestMWOpt$value, 3), rep(bestRTFOpt$value, 3)), 
    convergence = c(rep(bestCtlOpt$convergence, 2), rep(bestMWOpt$convergence, 3), rep(bestRTFOpt$convergence, 3))
  )
  saveRDS(list('Ctl'=bestCtlOpt, 'MW'=bestMWOpt, 'RTF'=bestRTFOpt), paste0('out/', id,'.rds'))
  models = rbind(models, models_sub)
}

write.csv(models, 'modeloutput.csv')