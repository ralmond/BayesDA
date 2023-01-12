library(magrittr)
library(rstan)
library(lme4)

data1 = read.csv("http://www.stat.columbia.edu/~gelman/arm/examples/cd4/allvar.csv")

data1 = na.omit(data1)

data1$VDATE = as.Date(data1$VDATE, format = "%m/%d/%Y")

N = length(data1$CD4PCT)

J = data1$newpid[N]

K = ncol(data1)

CD4PCT = data1$CD4PCT

VDATE = data1$visage - data1$baseage
newpid = data1$newpid

data = list(N = N, J = J, newpid = newpid, 
            CD4PCT_ik = CD4PCT, 
            VDATE_1ik = VDATE,
            baseage=data1$baseage,
            treat=data1$treatmnt)


fileName <- "Bayesian/GH16.3b.stan_code.stan"
#stan_code <- readChar(fileName, file.info(fileName)$size)
#cat(stan_code)


resStanb <- stan(fileName, data = data, chains = 3, iter = 3000, warmup = 500, thin = 10)

library(shinystan)
launch_shinystan(resStanb)

plot(resStanb,pars=c("beta_0","beta_1","sigma_e0","sigma_u0k"))
pairs(resStanb,pars=c("sigma_u0k","u_0k[1]","u_0k[2]"))
pairs(resStanb,pars=c("beta_0","sigma_u0k","beta_0k[1]","beta_0k[2]"))




resStanExt <- rstan::extract(resStan, permuted = TRUE)
rstan::traceplot(resStan, pars = c("beta_0","beta_1","sigma_e0","sigma_u0k"), inc_warmup = FALSE)
print(resStan, pars = c("beta_0","beta_1","sigma_e0","sigma_u0k"))
