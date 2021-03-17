quickfit = T; verbose = T; checkConverge = T; 
savedir = 'Models/DDM/out/'; nFit = 100; startfrom = 1;
iterList = NULL
data = modeldata

id = 1
data = data[data$id==id,]; 
start_function = getx0; 
objective_function = ddm_loglik; 
base_pars = c("a", "t0", "sv", "sz", "z"); 
nFit=nFit;
quickfit = quickfit; verbose = verbose; checkConverge = checkConverge; 
savedir = savedir
n_drift = 5


x0s <- list()
for(z in 1:1000) {
  x0s[[z]] <- start_function(base_pars, n_drift=n_drift)
}

n0s <- c()
rt = data$RT
response = data$response_ddm
drift = factor(data$strength_bin, seq_len(n_drift))
for(x in 1:length(x0s)) {
  pars = x0s[[x]]
  
  if(any(is.na(names(pars)))) names(pars) = c("a" ,"t0",  "sv",  "sz",  "z",   "v_1", "v_2", "v_3", "v_4", "v_5")  # avoid some errors
  non_v_pars <- grep("^v", names(pars), invert = TRUE, value = TRUE)
  base_par <- length(non_v_pars)  # number of non-drift parameters
  densities <- vector("numeric", length(rt))
  for (i in 1:ndrift) {
    densities[drift == levels(drift)[i]] <- 
      ddiffusion(rt[drift == levels(drift)[i]], 
                 response = response[drift == levels(drift)[i]], 
                 a=pars["a"], t0=pars["t0"],  
                 sv=pars["sv"],
                 sz=if ("sz" %in% non_v_pars) pars["sz"] else 0.1,
                 z=if ("z" %in% non_v_pars) pars["z"]*pars["a"] else 0.5*pars["a"],
                 st0=if ("st0" %in% non_v_pars) pars["st0"] else 0, 
                 v=pars[base_par+i])
  }
  n0s[x] <- sum(densities==0)
}

layout(matrix(1:10, 2,5, byrow=T))
for(p in 1:length(x0s[[1]])) {
  param <- sapply(x0s, function(xx) xx[p])
  plot(param, n0s)
}

