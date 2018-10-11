
library(plyr)
library(splines)

crsp = read.csv("crsp.csv")
compustat = read.csv("compustat.csv")
Compustatvariable = read.csv("Compustat variables.csv") 


crsp<-transform(crsp,RET=as.double(as.character(RET)))
crsp<-transform(crsp,RETX=as.double(as.character(RETX)))


compustat<-rename(compustat,c("datadate"="date"))
BigData<- merge(crsp, compustat, by = c("PERMNO","date"), all = FALSE)
BigData3<-BigData2[!is.na(BigData2$RET),]

hist((BigData$RET),1000)

#filtring the data of outstanding companies
BigData1<-BigData[BigData$RET<1,]

hist((BigData1$RET),1000)

hist((BigData1$PRC),1000) # 1000- how many bars is gonna give
hist(log10(BigData1$PRC),1000)

BigData2<-BigData1[BigData1$PRC<300,] # we delated outstanding companies 
BigData2<-BigData2[BigData2$PRC>0,] # we want price bigger than 0 

BigData3<-BigData2[!is.na(BigData2$RET),]

hist((BigData2$PRC),1000)

for (i in seq(9,155)){
  print(i)
  plot(x=BigData3[,i],y=(BigData3$PRC),ylim=c(0,1000))
  Sys.sleep(1)
}


for (i in seq(9,155)){
  print(i)
  plot(x=BigData3[,i],y=(BigData3$RET),ylim=c(-0.5,0.5))
  Sys.sleep(1)
}

#####################splines#####We will only implement balancesheet variables , no P&L


plot(x=BigData2$act, y=BigData2$RET)

## Regression splines.  We put the

spline.loss <- function (fit, indices, fin_data) {
  x <- fin_data$x[indices];
  y <- fin_data$y[indices];
  mean((y-predict(fit, data.frame(x=x)))^2)
}

data_for_spline<-data.frame(x=BigData3$gp, y=BigData3$RET)
data_for_spline_cleaned<-data_for_spline[!is.na(data_for_spline$x),]# delating NA in act

N<-nrow(data_for_spline_cleaned)


train.indices <- 1:floor(N*0.6);
valid.indices <- floor(N*0.6+1):floor(N*0.8); 
test.indices  <- floor(N*0.8+1):N 


spline.dfs <- 1:10;
spline.fits <- lapply(spline.dfs, function (i) lm(y ~ ns(x, df=i), data=data_for_spline_cleaned[train.indices,]));
spline.train.losses <- sapply(spline.fits, spline.loss, indices=train.indices, 
                              fin_data=data_for_spline_cleaned); 
spline.valid.losses <- sapply(spline.fits, spline.loss, indices=valid.indices, fin_data=data_for_spline_cleaned);

plot(x=spline.dfs,y=spline.train.losses) 
plot(x=spline.dfs,y=spline.valid.losses)

#Splines do not work, we can observe it 


plottest.xrange<-data.frame(x=seq(min(data_for_spline_cleaned$x),max(data_for_spline_cleaned$x),length.out=1000))
plottest.ypredicts <- lapply(spline.dfs, function (i) predict(spline.fits[[i]], plottest.xrange))
plot(data_for_spline_cleaned)
lines(data.frame(x=plottest.xrange,y=plottest.ypredicts[[1]]), col="black")  

lines(data.frame(x=plottest.xrange,y=plottest.ypredicts[[2]]), col="green") 

lines(data.frame(x=plottest.xrange,y=plottest.ypredicts[[3]]), col="blue") 

lines(data.frame(x=plottest.xrange,y=plottest.ypredicts[[10]]), col="red") 

