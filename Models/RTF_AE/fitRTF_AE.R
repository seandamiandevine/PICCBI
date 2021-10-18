
setwd('/Users/seandevine/Documents/PICCBI/Models/RTF_AE')
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
      #tau0 = runif(1, 0.001, 1)
      sigma0 = runif(1, 0.001, 1)
      alpha0 = runif(1, 0.001, 1)
      x0 = c(sigma0, alpha0)
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
    # Grid-search for nk
    est_tau = bestRTFOpt$par[1]
    est_sigma = bestRTFOpt$par[2]
    probs = c()
    for(k in 1:100){
      probs[k] = obfunc(c(est_tau, est_sigma, k))
    }
    # plot(1:100, probs, xlab='nk', ylab='LL', type='b') # check for convexity
    probs[is.na(probs)] = 1e6
    est_nk = match(min(probs), probs)
    LLRTF = probs[est_nk]
  }
  
  # Save
  models_sub = data.frame(
    id = rep(id, 7), 
    condition = rep(sub$condition[1], 7), 
    model = c(rep('Ctl', 2), rep('MW', 2), rep('RTF', 3)), 
    pars = c(bestCtlOpt$par, bestMWOpt$par, c(est_tau, est_sigma, est_nk)), 
    LL = -c(rep(bestCtlOpt$value, 2), rep(bestMWOpt$value, 2), rep(LLRTF, 3)), 
    convergence = c(rep(bestCtlOpt$convergence, 2), rep(bestMWOpt$convergence, 2), rep(bestRTFOpt$convergence, 3))
  )
  saveRDS(list('Ctl'=bestCtlOpt, 'MW'=bestMWOpt, 'RTF'=bestRTFOpt), paste0('out/', id,'.rds'))
  models = rbind(models, models_sub)
}


npars = c('Ctl' = 2, 'MW' = 3, 'RTF'= 4)
bic = function(LL, k, n) k*log(n) - 2*log(LL)

models$npar = as.numeric(npars[models$model])
models$bic = bic(-models$LL, models$npar, 800)

write.csv(models, 'modeloutput.csv')
