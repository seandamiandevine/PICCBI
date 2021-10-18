CDF = function(x, tau, sigma) {
  pnorm((x-tau)/sigma)
}

Choice = function(p) {
  sample(c(0,1), prob = c(1-p,p), size=1)
}

ControlMod = function(resp, x, params) {
  tau=params[1]
  sigma=params[2]
  N = length(x)
  probs = c()
  for(t in 1:N){
    p = CDF(x[t], tau, sigma)
    if(resp[t]==0) p=1-p
    probs[t] = p
  }
  probs
}

MovingWindow = function(resp, x, params) {
  tau0 = params[1]
  sigma=params[2]
  alpha=params[3]
  
  N = length(x)
  probs=c()
  tau = tau0
  for(t in 1:N){
    tau = tau + alpha*(x[t]-tau)
    p = CDF(x[t], tau, sigma)    # fat
    if(resp[t]==0) p = 1-p       # not fat
    probs[t] = p
  }
  probs
}

RTF = function(resp, x, params) {
  tau0=params[1]
  sigma=params[2]
  nk=round(params[3])
  w=.5 # fixed for now, like David
  N = length(x)
  probs = c()
  for(t in 1:N){
    if(t <= nk) {
      thisRange = 1:t 
    } else {
      thisRange = (t-nk):t
    }
    maxX = max(x[thisRange])
    minX = min(x[thisRange])
    rank = match(x[t], sort(x[thisRange]))
    
    range = (x[t]-minX)/(maxX-minX)
    if(is.na(range)) range = 0
    freq = (rank-1)/(nk-1)
    y = w*range + (1-w)*freq
    
    p = CDF(y, tau0, sigma)
    if(resp[t]==0) p=1-p
    
    probs[t] = p
  }
  probs 
}
