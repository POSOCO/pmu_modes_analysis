library(readr)    #libraries for program
library(stringr)
library(ggplot2)
library(pracma)
library(ggplot2)
library(signal)
library(plotly)
f<-c("Freq") #frequency list defined
c<-c("Count") #count list defined
tim<-"1-6-1-7"  #Gives Dates to final file
l<-list.files(path="C:/Users/perf1/Desktop/1-6-1-7",pattern = ".csv",all.files= TRUE, full.names = TRUE) #import csv
for(i in 1:7) # 7 files for 7 modes
{
  file_name<-str_sub(string=l[i],start=46,end=-5)
  file_df<-read_csv(l[i]) #read
  assign(x="test",value = file_df,envir = .GlobalEnv)
  colnames(test)[colnames(test)=="Frequency:PDX1"] <- "F" # column name changed 
  a<-subset(test,!is.na(F)) # NA(blank) elements removed
  b=unique.default(a$F)  # finding different unique frequencies
  b<-as.data.frame(b)
  f<-rbind(f,b) # frequency list made
  d<-nrow(b) # number of different frequencies
  for(j in 1: d) #  loop for number of different frequencies
  {
    e<-length(which(a$F==b[j,1]))
    c<-rbind(c,e) # count list made for each frequency in loop
  }

}
g  <-cbind(f,c) # frequency and count table
write.table(g,file=paste("freqandcount",tim,".csv"),row.names=FALSE,na="",col.names=FALSE,sep=",") # table written to csv in documents
lol <- read_csv("~/freqandcount.csv") # table read
lol<-lol[order(lol$X1),] # sorting frequencies in order
x1<-lol$Count # counts stored in sorted format
# filtering of count plot starts for mode extraction
bf<-butter(2,0.3,type = c("pass")) # properties set
z<-filtfilt(bf,x1)
z<-as.vector(z)
z3<-as.data.frame(z)
g<-ggplot(data=lol,aes(x = lol$X1 ,y= lol$Count,color= "Count")) + geom_line(color ="blue",stat = "identity") +
       xlab("Frequency") + ylab("Count") + theme_gray() + theme(legend.title = element_blank())#+geom_line(aes(x=lol$Freq,y=z3),colour="green")   # count vs freq plot
#chggsave(filename = "C/:")
ggsave(paste("C:/Users/perf1/Desktop/Results/1month_count_vs_frequency/f_c",tim,".jpg"),plot = g) # plot saved to docs
q<-findpeaks(x1)
p<-findpeaks(z,threshold = 500) # peaks finding in count plot
n<-nrow(p)  # number of peaks
f1<-0
f2<-0

for(i in 1:n)
{
f1[i]=f<-lol[p[i,3],1] # band initial values
f<-as.numeric(f)
g<-g + geom_vline(xintercept = f, linetype="dotted", color = "brown", size=1) # making vertical line for these values
 f2[i]=f<-lol[p[i,4],1] # band final values
f<-as.numeric(f)
g<-g + geom_vline(xintercept = f, linetype="dotted", color = "black", size=1)# making vertical line for these values
}
f<-cbind(f1,f2) # bands stored
ggplotly(g) # interactive plot for bands (count and frequency)
ggsave(paste("C:/Users/perf1/Desktop/Results/1month_count_vs_frequency/f_c_plotly_",tim,".jpg"),plot = g) # plot saved to docs
write.table(f,file=paste("Frequency Bands",tim,".csv"),row.names=FALSE,na="",col.names=TRUE,sep=",") # writing freq bands (modes) to csv files in directory
