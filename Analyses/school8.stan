data {
  int<lower=0> J; // number of schools
  real y[J]; // estimated treatement effects
  real<lower=0> sigma[J]; //s.e. of effects.
}
parameters {
  real mu;
  real<lower=0> tau;
  vector[J] theta;
} 
model {
  theta ~ normal(mu,tau);
  //target += normal_lpdf(theta|mu,tau);
  y ~ normal(theta,sigma);
  //target += normal_lpdf(effect|theta,see);
}
