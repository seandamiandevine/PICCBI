
set.seed(10408)
setwd('~/Desktop/Ongoing/PICCBI/Full/Models/RTF_AE')
source('models.R')
d = read.csv('clean_dat.csv')

# Simulate ----------------------------------------------------------------

Nsub = 25
rand_increase = as.character(sample(unique(d$subject[d$condition=='Increase']), Nsub))
rand_stable = as.character(sample(unique(d$subject[d$condition=='Stable']), Nsub))
dsim = d[d$subject%in%c(rand_increase, rand_stable), ]

Ctl = data.frame()
MW = data.frame()
RF = data.frame()
for(id in unique(dsim$subject)){
  cat('Simulating choices for subject', match(id, unique(dsim$subject)), '/', Nsub*2, '\n')
  stim = dsim[dsim$subject==id, 'size0']
  N = length(stim)
  
  # Control model
  tau = runif(1, 0.001, 1)
  sigma = runif(1, 0.001, 1)
  resps = c()
  probs = c()
  for(t in 1:N){
    p = CDF(stim[t], tau, sigma)
    probs[t] = p
    resps[t] = Choice(p)
    }
  thissim = data.frame(id = match(id, unique(dsim$subject)),
                      condition = as.character(dsim[dsim$subject==id, 'condition'][1]),
                      true_tau = tau, 
                      true_sigma = sigma, 
                      stim = stim,
                      choices = resps, 
                      model = 'Ctl')
  Ctl = rbind(Ctl, thissim)
  
  # MW model
  tau0 =  runif(1, 0.001, 1)
  sigma = runif(1, 0.001, 1)
  alpha = runif(1, 0.001, 1)
  resps = c()
  probs = c()
  
  tau=c(tau0)
  for(t in 1:N){
    tau[t+1] = tau[t] + alpha*(stim[t]-tau[t])
    p = CDF(stim[t], tau[t+1], sigma)
    probs[t] = p
    resps[t] = Choice(p)
  }
  
  thissim = data.frame(id = match(id, unique(dsim$subject)),
                       condition = as.character(dsim[dsim$subject==id, 'condition'][1]),
                       true_tau0 = tau0, 
                       true_sigma = sigma, 
                       true_alpha = alpha,
                       stim=stim,
                       choices = resps, 
                       model = 'MW')
  MW = rbind(MW, thissim)
    
  # RTF Model
  tau = runif(1, 0.01, 1)
  sigma = runif(1, 0.01, 1)
  nk = round(runif(1, 2, 20))
  w = .5
  resps = c()
  probs = c()
  for(t in 1:N){
    if(t <= nk) {
      thisRange = 1:t 
    } else {
      thisRange = (t-nk):t
    }
    maxX = max(stim[thisRange])
    minX = min(stim[thisRange])
    rank = match(stim[t], sort(stim[thisRange]))
    
    range = (stim[t]-minX)/(maxX-minX)
    if(is.na(range)) range = 0
    freq = (rank-1)/(nk-1)
    y = w*range + (1-w)*freq
    
    p = CDF(y, tau, sigma)
    probs[t] = p
    if(t==1) resps[t] = sample(c(0,1), size=1)
    if(t!=1) resps[t] = Choice(p)
    }
  thissim = data.frame(id = match(id, unique(dsim$subject)),
                       condition = as.character(dsim[dsim$subject==id, 'condition'][1]), 
                       true_tau0 = tau, 
                       true_sigma = sigma, 
                       true_nk = nk,
                       stim=stim,
                       choices = resps, 
                       model = 'RTF')
    RF = rbind(RF, thissim)
  }

# Fit ---------------------------------------------------------------------

Niter = 1

# Control model
RecoveryCtl = data.frame()
for(id in unique(Ctl$id)) {
  cat('----------', match(id,unique(Ctl$id)), '/', length(unique(Ctl$id)), '----------\n')
  sub = Ctl[Ctl$id==id, ]
  true_tau = sub$true_tau[1]
  true_sigma = sub$true_sigma[1]
  choices = sub$choices
  stim = sub$stim
  
  bestCtlLL = 1e6
  bestCtlOpt = list()
  for(iter in 1:Niter){
    cat('*** iteration', iter, '/', Niter, '***\n')
    obfunc = function(x) {
      LL = -sum(log(ControlMod(choices, stim, x)))
      min(LL, 1e6)
    }
    tau0 = runif(1, 0.001, 1)
    sigma0 = runif(1, 0.001, 1)
    x0 = c(tau0, sigma0)
    optControl = optim(par=x0, fn=obfunc)
    if(optControl$value<bestCtlLL) {
      bestCtlLL = optControl$value
      bestCtlOpt = optControl
    }
  }
  if(length(bestCtlOpt)==0) {
    cat('FAILED TO FIT!\n')
    next  # failed to fit 
  }
  thisRecov = data.frame(id=id, true_tau=true_tau, true_sigma=true_sigma, 
                         est_tau=bestCtlOpt$par[1], est_sigma=bestCtlOpt$par[2]) 
  RecoveryCtl = rbind(RecoveryCtl, thisRecov)
}

pdf('CtlRecoveryPlots.pdf')
r = cor(RecoveryCtl$true_tau, RecoveryCtl$est_tau)
plot(RecoveryCtl$true_tau, RecoveryCtl$est_tau, 
     xlab=expression('True'~tau), ylab=expression('Estimated'~tau), 
     main='Regular CDF') 
legend('topleft', bty='n', legend=paste0('r=',round(r,4)))

r = cor(RecoveryCtl$true_sigma, RecoveryCtl$est_sigma)
plot(RecoveryCtl$true_sigma, RecoveryCtl$est_sigma, 
     xlab=expression('True'~sigma), ylab=expression('Estimated'~sigma), 
     main='Regular CDF') 
legend('topleft', bty='n', legend=paste0('r=',round(r,4)))

dev.off()
 
# Moving Window model 
RecoveryMW = data.frame()
for(id in unique(MW$id)) {
  cat('----------', match(id,unique(MW$id)), '/', length(unique(MW$id)), '----------\n')
  sub = MW[MW$id==id, ]
  true_tau = sub$true_tau0[1]
  true_sigma = sub$true_sigma[1]
  true_alpha = sub$true_alpha[1]
  choices = sub$choices
  stim = sub$stim
  
  bestMWLL = 1e6
  bestMWOpt = list()
  for(iter in 1:Niter){
    cat('*** iteration', iter, '/', Niter, '***\n')
    obfunc = function(x) {
      LL = -sum(log(MovingWindow(choices, stim, x)))
      min(LL, 1e6)
    }
    tau0 = runif(1, 0.001, 1)
    sigma0 = runif(1, 0.001, 1)
    alpha0 = runif(1, 0.001, 1)
    x0 = c(tau0, sigma0, alpha0)
    tryCatch(
      {
        optMW = optim(par=x0, fn=obfunc, method = 'L-BFGS-B', lower=c(0,0,0), upper = c(1,1,1))
      }, 
      error=function(e){
        optMW = optim(par=x0, fn=obfunc, method = 'L-BFGS-B', lower=c(0,0,0))
        return(optMW)
      }
    )
    
    if(optMW$value < bestMWLL) {
      bestMWLL = optMW$value
      bestMWOpt = optMW
    }
  }
  if(length(bestMWOpt)==0) {
    cat('FAILED TO FIT!\n')
    next  # failed to fit 
  }
  thisRecov = data.frame(id=id, true_tau=true_tau, true_sigma=true_sigma, true_alpha, 
                         est_tau=bestMWOpt$par[1], est_sigma=bestMWOpt$par[2], 
                         est_alpha=bestMWOpt$par[3]) 
  RecoveryMW = rbind(RecoveryMW, thisRecov)
}

pdf('MWRecoveryPlots.pdf')

r = cor(RecoveryMW$true_tau, RecoveryMW$est_tau)
plot(RecoveryMW$true_tau, RecoveryMW$est_tau, 
     xlab=expression('True'~tau), ylab=expression('Estimated'~tau), 
     main='Moving Window') 
legend('topleft', bty='n', legend=paste0('r=',round(r,4)))

r = cor(RecoveryMW$true_sigma, RecoveryMW$est_sigma)
plot(RecoveryMW$true_sigma, RecoveryMW$est_sigma, 
     xlab=expression('True'~sigma), ylab=expression('Estimated'~sigma), 
     main='Moving Window') 
legend('topleft', bty='n', legend=paste0('r=',round(r,4)))

r = cor(RecoveryMW$true_alpha, RecoveryMW$est_alpha)
plot(RecoveryMW$true_alpha, RecoveryMW$est_alpha, 
     xlab=expression('True'~alpha), ylab=expression('Estimated'~alpha), 
     main='Moving Window') 
legend('topleft', bty='n', legend=paste0('r=',round(r,4)))

dev.off()
    
# RTF model 
RecoveryRTF = data.frame()
for(id in unique(RF$id)) {
  cat('----------', match(id,unique(RF$id)), '/', length(unique(RF$id)), '----------\n')
  sub = RF[RF$id==id, ]
  true_tau = sub$true_tau0[1]
  true_sigma = sub$true_sigma[1]
  true_nk = sub$true_nk[1]
  choices = sub$choices
  stim = sub$stim
  
  bestRTFLL = 1e6
  bestRTFOpt = list()
  for(iter in 1:Niter){
    cat('*** iteration', iter, '/', Niter, '***\n')
    obfunc = function(x) {
      LL = -sum(log(RTF(choices, stim, x)))
      min(LL, 1e6)
    }
    tau0 = runif(1, 0.001, 100)
    sigma0 = runif(1, 0.001, 100)
    nk0 = round(runif(1, 2, 20))
    x0 = c(tau0, sigma0, nk0)
    optRTF = optim(par=x0, fn=obfunc, method='L-BFGS-B', lower=c(0,0, 0), upper=c(100,100,20))
    if(optRTF$value < bestRTFLL) {
      bestRTFLL = optRTF$value
      bestRTFOpt = optRTF
    }
  }
  if(length(bestRTFOpt)==0) {
    cat('FAILED TO FIT!\n')
    next  # failed to fit 
  }
  thisRecov = data.frame(id=id, true_tau=true_tau, true_sigma=true_sigma, true_nk=true_nk, 
                         est_tau=bestRTFOpt$par[1], est_sigma=bestRTFOpt$par[2], 
                         est_nk=bestRTFOpt$par[3]) 
  RecoveryRTF = rbind(RecoveryRTF, thisRecov)
}

pdf('RTFRecoveryPlots.pdf')

r = cor(RecoveryRTF$true_tau, RecoveryRTF$est_tau)
plot(RecoveryRTF$true_tau, RecoveryRTF$est_tau, 
     xlab=expression('True'~tau), ylab=expression('Estimated'~tau), 
     main='Moving Window') 
legend('topleft', bty='n', legend=paste0('r=',round(r,4)))

r = cor(RecoveryRTF$true_sigma, RecoveryRTF$est_sigma)
plot(RecoveryRTF$true_sigma, RecoveryRTF$est_sigma, 
     xlab=expression('True'~sigma), ylab=expression('Estimated'~sigma), 
     main='Moving Window') 
legend('topleft', bty='n', legend=paste0('r=',round(r,4)))

r = cor(RecoveryRTF$true_nk, RecoveryRTF$est_nk)
plot(RecoveryRTF$true_nk, RecoveryRTF$est_nk, 
     xlab=expression('True'~nk), ylab=expression('Estimated'~nk), 
     main='Moving Window') 
legend('topleft', bty='n', legend=paste0('r=',round(r,4)))

dev.off()

