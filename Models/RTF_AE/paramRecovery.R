
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
  stim = round(dsim[dsim$subject==id, 'size0']*100)
  N = length(stim)
  spectrum = min(stim):max(stim)
  
  # Control model
  tau = runif(1, 0.001, 100)
  sigma = runif(1, 0.001, 100)
  resps = c()
  probs = c()
  for(t in 1:N){
    p = CDF(stim[t], spectrum, tau, sigma)
    probs[t] = p
    resps[t] = Choice(p)
    }
  thissim = data.frame(id = match(id, unique(dsim$subject)),
                      condition = as.character(dsim[dsim$subject==id, 'condition'][1]),
                      true_tau = tau, 
                      true_sigma = sigma, 
                      stim = stim,
                      probs = probs,
                      choices = resps, 
                      model = 'Ctl')
  Ctl = rbind(Ctl, thissim)
  
  # MW model
  tau0 =  runif(1, 0.001, 100)
  sigma = runif(1, 0.001, 100)
  alpha = runif(1, 0.001, 1)
  resps = c()
  probs = c()
  
  tau=c(tau0)
  for(t in 1:N){
    p = CDF(stim[t], spectrum, tau[t], sigma)
    probs[t] = p
    resps[t] = Choice(p)
    tau[t+1] = tau[t] + alpha*(stim[t]-tau[t])
  }
  
  thissim = data.frame(id = match(id, unique(dsim$subject)),
                       condition = as.character(dsim[dsim$subject==id, 'condition'][1]),
                       true_tau0 = tau0, 
                       true_sigma = sigma, 
                       true_alpha = alpha,
                       stim=stim,
                       probs = probs,
                       choices = resps, 
                       model = 'MW')
  MW = rbind(MW, thissim)
    
  # RTF Model
  tau = runif(1, 0.001, 100)
  sigma = runif(1, 0.01, 100)
  nk = sample(6:100,size=1)
  w = .5
  resps = c()
  probs = c()
  for(t in 1:N){
    if(t <= 5) {
      probs[t] = CDF(stim[t], spectrum, tau, sigma) 
      next 
    } else if(t < nk){
      thisRange = 1:t
    } else {
      thisRange = (t-nk):t
    }
    maxXk = max(stim[thisRange])
    minXk = min(stim[thisRange])
    idx = match(stim[t], stim[thisRange])
    rank = rank(stim[thisRange])[idx]
    
    range = (stim[t]-minXk)/(maxXk-minXk)
    if(is.na(range)) range=0
    freq = (rank-1)/(length(thisRange)-1)
    y = w*range + (1-w)*freq
    y = round(y*max(stim))
    y = ifelse(y<min(stim), min(stim), ifelse(y>max(stim), max(stim), y))
    
    p = CDF(y, spectrum, tau, sigma)
    probs[t] = p
    if(t!=1) resps[t] = Choice(p)
    }
    thissim = data.frame(id = match(id, unique(dsim$subject)),
                       condition = as.character(dsim[dsim$subject==id, 'condition'][1]), 
                       true_tau0 = tau, 
                       true_sigma = sigma, 
                       true_nk = nk,
                       stim=stim,
                       probs = probs,
                       choices = resps, 
                       model = 'RTF')
    RF = rbind(RF, thissim)
  }


# Visualize simulations 
Ctl$trial = unlist(by(Ctl$id, Ctl$id, FUN = function(x) 1:length(x)))
Ctl$timebin = dplyr::ntile(Ctl$trial, 4)
Ctl$stimbin = dplyr::ntile(Ctl$stim, 20)
RF$trial = unlist(by(RF$id, RF$id, FUN = function(x) 1:length(x)))
RF$timebin = dplyr::ntile(RF$trial, 4)
RF$stimbin = dplyr::ntile(RF$stim, 20)
MW$trial = unlist(by(MW$id, MW$id, FUN = function(x) 1:length(x)))
MW$timebin = dplyr::ntile(MW$trial, 4)
MW$stimbin = dplyr::ntile(MW$stim, 20)

pdf('plots/simulations.pdf')
layout(matrix(1:6, 3,2, byrow=T))
# Ctl model
# Stable
mProb = tapply(Ctl$probs, list(Ctl$stimbin, Ctl$timebin, Ctl$condition), mean)
plot(mProb[,1,'Stable'], type='b', col='red', xaxt='n', ylab='p(Blue)', xlab='', main='Control\nStable', ylim=c(0,1))
lines(mProb[,4,'Stable'], type='b', col='blue')
axis(1, at=c(1,20), labels=c('Very Purple', 'Very Blue'))
legend('topleft', bty='n', lty=1, pch=1, col=c('red', 'blue'), legend=c('First 200 Trials', 'Last 200 Trials'))

# Decreasing
plot(mProb[,1,'Increase'], type='b', col='red', xaxt='n', ylab='p(Blue)', xlab='', main='Control\nDecreasing', ylim=c(0,1))
lines(mProb[,4,'Increase'], type='b', col='blue')
axis(1, at=c(1,20), labels=c('Very Purple', 'Very Blue'))
#legend('topleft', bty='n', lty=1, pch=1, col=c('red', 'blue'), legend=c('First 200 Trials', 'Last 200 Trials'))

# MW model
# Stable
mProb = tapply(MW$probs, list(MW$stimbin, MW$timebin, MW$condition), mean)
plot(mProb[,1,'Stable'], type='b', col='red', xaxt='n', ylab='p(Blue)', xlab='', main='MW\nStable', ylim=c(0,1))
lines(mProb[,4,'Stable'], type='b', col='blue')
axis(1, at=c(1,20), labels=c('Very Purple', 'Very Blue'))
#legend('topleft', bty='n', lty=1, pch=1, col=c('red', 'blue'), legend=c('First 200 Trials', 'Last 200 Trials'))

# Decreasing
plot(mProb[,1,'Increase'], type='b', col='red', xaxt='n', ylab='p(Blue)', xlab='', main='MW\nDecreasing', ylim=c(0,1))
lines(mProb[,4,'Increase'], type='b', col='blue')
axis(1, at=c(1,20), labels=c('Very Purple', 'Very Blue'))
#legend('topleft', bty='n', lty=1, pch=1, col=c('red', 'blue'), legend=c('First 200 Trials', 'Last 200 Trials'))


# RF model
# Stable
mProb = tapply(RF$probs, list(RF$stimbin, RF$timebin, RF$condition), mean)
plot(mProb[,1,'Stable'], type='b', col='red', xaxt='n', ylab='p(Blue)', xlab='', main='RTF\nStable', ylim=c(0,1))
lines(mProb[,4,'Stable'], type='b', col='blue')
axis(1, at=c(1,20), labels=c('Very Purple', 'Very Blue'))
#legend('topleft', bty='n', lty=1, pch=1, col=c('red', 'blue'), legend=c('First 200 Trials', 'Last 200 Trials'))

# Decreasing
plot(mProb[,1,'Increase'], type='b', col='red', xaxt='n', ylab='p(Blue)', xlab='', main='RTF\nDecreasing', ylim=c(0,1))
lines(mProb[,4,'Increase'], type='b', col='blue')
axis(1, at=c(1,20), labels=c('Very Purple', 'Very Blue'))
#legend('topleft', bty='n', lty=1, pch=1, col=c('red', 'blue'), legend=c('First 200 Trials', 'Last 200 Trials'))

dev.off()

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
    while(1){
      tau0 = runif(1, 0.001, 100)
      sigma0 = runif(1, 0.001, 100)
      x0 = c(tau0, sigma0)
      if(obfunc(x0)!=1e6 & !is.na(obfunc(x0))) break
    }
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

pdf('plots/CtlRecoveryPlots.pdf')
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
    while(1){
      tau0 = runif(1, 0.001, 100)
      sigma0 = runif(1, 0.001, 100)
      alpha0 = runif(1, 0.001, 1)
      x0 = c(tau0, sigma0, alpha0)
      if(obfunc(x0)!=1e6 & !is.na(obfunc(x0))) break
    }
    
    optMW = optim(par=x0, fn=obfunc, method = 'L-BFGS-B', lower=c(0,0,0), upper=c(100,100,1))
    
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
     xlab=expression('True'~tau[0]), ylab=expression('Estimated'~tau[0]), 
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
    while(1) {
      tau0 = runif(1, 0.001, 100)
      sigma0 = runif(1, 0.001, 100)
      nk0 = sample(1:100,size=1)
      x0 = c(tau0, sigma0, nk0)
      if(obfunc(x0)!=1e6 & !is.na(obfunc(x0))) break
    }
    optRTF = optim(par=x0, fn=obfunc)
    if(optRTF$value < bestRTFLL) {
      bestRTFLL = optRTF$value
      bestRTFOpt = optRTF
    }
  }
  if(length(bestRTFOpt)==0) {
    cat('FAILED TO FIT!\n')
    next  # failed to fit 
  }
  # Grid-search for nk
  est_tau = bestRTFOpt$par[1]
  est_sigma = bestRTFOpt$par[2]
  probs = c()
  grid = 6:100
  for(k in grid){
    probs = c(probs, obfunc(c(est_tau, est_sigma, k)))
  }
  plot(grid, probs, xlab='nk', ylab='LL', type='b') # check for convexity
  probs[is.na(probs)] = 1e6
  est_nk = grid[match(min(probs), probs)]
  legend('topright', bty='n',legend=paste0('true=',true_nk,'\nest=',est_nk))
  
  thisRecov = data.frame(id=id, true_tau=true_tau, true_sigma=true_sigma, true_nk=true_nk, 
                         est_tau=est_tau, est_sigma=est_sigma, est_nk=est_nk) 
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

