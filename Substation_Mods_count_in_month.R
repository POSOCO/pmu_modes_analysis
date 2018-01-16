library(readr) # libraries necessary
library(stringr)
library(ggplot2)
library(gridExtra)
library(gtools)
library(scales)
library(lubridate)
rm(list=ls()) #clear all
z<-list()
c<-c("sub","TIME","FREQ") # list for time and freq elements initialised
c<-as.data.frame(c)
c<-t(c) #transpose
#c1<-c("TIME","FREQ")
tim<-c("1-6-4-6")  
l<-list.files(path="C:/Users/perf1/Desktop/1-6-4-6/",pattern = ".csv",all.files= TRUE, full.names = TRUE) #csv files of modes read ( one month )
fil<-8 # loop for 8 modes
for(i in 1:fil)
{
  c<-c("sub","TIME","FREQ") # list for time and freq elements initialised
c<-as.data.frame(c)
c<-t(c) #transpose
  file_name<-str_sub(string=l[i],start=46,end=-5)
  file_df<-read_csv(l[i]) # read 
  assign(x="test",value = file_df,envir = .GlobalEnv)
  colnames(test)[colnames(test)=="Frequency:PDX1"] <- "F" # coulmn name changed
  test<-subset(test,!is.na(test$F)) # NA elements removed
  s<-unique(test$SubstationId)  # unique substation ids extracted
  s<-as.data.frame(s)
  n<-nrow(s)
  for(j in 1:n) # loop for 'n' substation ids
  {
    test1<-subset(test,test$SubstationId==s[j,1]) # analysis for individual substation id
    a<-test1$F # frequencies taken
    b<-test1$STARTDATE # time taken
    b1<- as.POSIXct(b)
    b1<-as.data.frame(b1)
    s1<-test1$SubstationId  # name of substation id
    d<-cbind(s1,b1,a) # table of substation, time and freq
    c<-smartbind(c,d) # global table (final)
  }
#c<-as.data.frame(c)

write.table(c,file=paste("freqvstime",tim,"_",i,".csv"),row.names=FALSE,na="",col.names=FALSE,sep=",") # freq and time table for substations written to csv
posoco <- read_csv(paste("~/freqvstime",tim,"_",i,".csv")) # data read from csv
s<-unique(posoco$X1)
s<-as.data.frame(s)
n<-nrow(s)
for(j in 1:n) # loop for plotting for multiple substations
{
  p<-subset(posoco,posoco$X1==s[j,1])
  g<-ggplot(data =p[],aes(x=p$X2,y=p$X3),color="red") + geom_line(color = "red")+  xlab("t") + ylab(s[j,1]) + theme_gray() + theme(legend.title = element_blank()) + scale_x_datetime(labels = date_format("%D %H:%M:%S")) # plotting mlutiple fvst plots for different subs
  ggsave(paste("C:/Users/perf1/Desktop/TVF1/",s[j,1],"_",i,"_",tim,".jpg"),plot = g) # plots saved
}#p2<-p3
#dev.off
#do.call(grid.arrange,c(z,ncol=2))
#grid.arrange(l,ncol=1,top="")
#ggplot(data =l[2],aes(x=l[2]$,y=posoco$X3),color= "red") + geom_point(color = "red")+  xlab("t") + ylab(posoco[2,1]) + theme_gray() + theme(legend.title = element_blank())
  } 
  
}
