data {
  int<lower=1> N; //the number of observations
  int<lower=1> J; //the number of unique child
  
  int<lower=1,upper=J> newpid[N]; //vector of group indeces

  real CD4PCT_ik[N]; //the response variable
  real VDATE_1ik[N]; // the predictor variable
  real treat[N];
  real baseage[N];
  
}

parameters {
  
 // regression slopes 
 real beta_0; //intercept
 real beta_1; // the effect of predictor 
 real beta_ba;
 real beta_tr;
 
 real<lower=0> sigma_e0;
 real<lower=0> sigma_u0k;
 vector[J] u_0k;

}

transformed parameters  {
  
  // Varying intercepts
 vector[J] beta_0k;

 // Individual mean
 vector[N] mu;
 // Level-2 (level-2 random intercepts)
//for (j in 1:J) {
  beta_0k  = beta_0 + u_0k*sigma_u0k;
//}
// Individual mean
for (i in 1:N) {
  mu[i] = beta_0k[newpid[i]] + 
          beta_1 * VDATE_1ik[i] +
          beta_ba * baseage[i] +
          beta_tr * treat[i];
}
  
}
  
model {
  
  //Random effects distribution
  u_0k  ~ normal(0, 1);

 
  // Likelihood part of Bayesian inference
  // Outcome model N(mu, sigma^2) (use SD rather than Var)
  CD4PCT_ik ~ normal(mu, sigma_e0);
}

