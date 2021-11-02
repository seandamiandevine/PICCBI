CDF = function(x, spectrum, tau, sigma) {
  pdist = pnorm(spectrum, tau, sigma)
  idx   = match(x, spectrum)
  pdist[idx]
}

Choice = function(p) {
  sample(c(0,1), prob = c(1-p,p), size=1)
}


ControlMod = function(resp, x, params) {
  tau=params[1]
  sigma=params[2]
  spectrum = min(x):max(x)
  
  N = length(x)
  probs = c()
  for(t in 1:N){
    p = CDF(x[t], spectrum, tau, sigma)
    if(resp[t]==0) p=1-p
    probs[t] = p
  }
  probs
}

MovingWindow = function(resp, x, params) {
  tau0 = params[1]
  sigma=params[2]
  alpha=params[3]
  spectrum = min(x):max(x)
  
  N = length(x)
  probs=c()
  tau =c(tau0)
  for(t in 1:N){
    p = CDF(x[t], spectrum, tau[t], sigma)    # fat
    if(resp[t]==0) p = 1-p                    # not fat
    probs[t] = p
    tau[t+1] = tau[t] + alpha*(x[t]-tau[t])
  }
  probs
}

RTF = function(resp, x, params) {
  tau = params[1]
  sigma = params[2]
  nk = round(params[3])
  w = .5
  spectrum = min(x):max(x)
  
  N = length(x)
  probs = c()
  for(t in 1:N){
    if(t <= 5) {
      probs[t] = CDF(x[t], spectrum, tau, sigma) 
      next 
    } else if(t < nk){
      thisRange = 1:t
    } else {
      thisRange = (t-nk):t
    }
    maxXk = max(x[thisRange])
    minXk = min(x[thisRange])
    idx = match(x[t], x[thisRange])
    rank = rank(x[thisRange])[idx]
    
    range = (x[t]-minXk)/(maxXk-minXk)
    if(is.na(range)) range=0
    freq = (rank-1)/(length(thisRange)-1)
    y = w*range + (1-w)*freq
    y = round(y*max(x))
    y = ifelse(y<min(x), min(x), ifelse(y>max(x), max(x), y))
    
    p = CDF(y, spectrum, tau, sigma)
    if(resp[t]==0) p=1-p
    
    probs[t] = p
  }
  probs 
  
}