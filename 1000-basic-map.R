#Basic map of historic distribution of MRRT
library(tidyverse)
library(ggrepel)
library(maps)
library(mapdata)
library(maptools)

cali<-map_data("state") %>% filter(region %in% c("california"))

#Get some river data
load("/Users/mac/Dropbox/trout/chinook/Chinook Paper/streamsSub.rda")
riversNames<-as_tibble(read.csv(file="/Users/mac/Dropbox/trout/chinook/Chinook Paper/outputs/toPlot.txt",header=T))
riversNames$Names<-as.character(riversNames$Names)

rivers<- subset(streamsSub, streamsSub$NAME %in% riversNames$Names)
riversdf<-fortify(rivers)                                                     

load("/Users/mac/Dropbox/trout/chinook/Chinook Paper/polyStreamsSub.rda")
lakes<- subset(polyStreamsSub, polyStreamsSub$NAME %in% c("Copco Lake", "Iron Gate Reservoir",
                                                          "Lewiston Lake","Clair Engle Lake",
                                                          "Pine Flat Reservoir","Isabella Lake",
                                                          "Mammoth Pool Reservoir","Millerton Lake",
                                                          "Sacramento River","Shasta Lake","Keswick Reservoir","Lake Britton",
                                                          "Folsom Lake",
                                                          "Lake Natoma","Lake Oroville",
                                                          "Little Grass Valley Reservoir","Lake Almanor",
                                                          "San Joaquin River", "Lake Success", "Lake Kaweah",
                                                          "Pardee Reservoir","Don Pedro Reservoir","Hetch Hetchy Reservoir",
                                                          "Lake McClure (Exchequer Reservoir)",
                                                          "New Melones Lake","Tulloch Reservoir",
                                                          "Upper Klamath Lake","John Boyle Reservoir","Agency Lake",
                                                          "Lake Shastina",
                                                          "Comanche Reservoir",
                                                          "Clear Lake Reservoir","Tule Lake Sump",
                                                          "Suisun Bay", "Carquinez Strait",
                                                          "Eagle Lake"
                                                          
))
lakesdf<-fortify(lakes)

map<-ggplot(cali) +
  geom_polygon(data=cali, aes(x=long, y=lat, group=group), color="black", fill=NA, alpha=0.75) +
  geom_path(data = riversdf, aes(x = long, y = lat, group=group), color="blue")+
  geom_polygon(data=lakesdf, aes(x=long, y=lat, group=group), fill="blue", color="blue")+
  coord_fixed(1.3)+
  theme_bw() +
  theme(panel.grid=element_blank())+
  xlab("Longitude")+
  ylab("Latitude")

x<--122.293309
y<-40.804313
type<-as_tibble(cbind(x,y))

x2<-mean(df$V1)
y2<-mean(df$V2)

#Now let's get that layer
range<-getKMLcoordinates("outputs/1000/histrange.kml", ignoreAltitude=TRUE)
df1<-as_tibble(range[[1]])
df2<-as_tibble(range[[2]])
df3<-as_tibble(range[[3]])
df4<-as_tibble(range[[4]])
df5<-as_tibble(range[[5]])
df6<-as_tibble(range[[6]])

#using a convex hull
df<-rbind(df1,df2,df3,df4,df5,df6)
curated<-as_tibble(cbind(x2,y2))

mrrtrange<-chull(c(df$V1,df$V2))
#geom_polygon(data=df[mrrtrange,],aes(x=V1, y=V2), alpha=0.75) + 
mrrt<-map + 
  geom_polygon(data=df1,aes(x=V1, y=V2), alpha=0.75, fill="red") +
  geom_polygon(data=df2,aes(x=V1, y=V2), alpha=0.75, fill="red") +
  geom_polygon(data=df3,aes(x=V1, y=V2), alpha=0.75, fill="red") +
  geom_polygon(data=df4,aes(x=V1, y=V2), alpha=0.75, fill="red") +
  geom_polygon(data=df5,aes(x=V1, y=V2), alpha=0.75, fill="red") +
  geom_polygon(data=df6,aes(x=V1, y=V2), alpha=0.75, fill="red") +
  geom_point(data=type, aes(x=x, y=y), pch=21, size=4, col="black", fill="red", alpha=0.5)+
  geom_label_repel(data=type, aes(x=x, y=y, label="MRRT Type Locality"), alpha=0.75)+
  geom_label_repel(data=curated, aes(x=x2, y=y2, label="Curated Historic Range"), alpha=0.75)+
  coord_fixed(ratio=1.3, xlim=c(-120,-123), ylim=c(40,42)) 

mrrt

ggsave("outputs/1000/map.pdf", width=5, height=5)

#aquilarum
aquilarum<-getKMLcoordinates("outputs/1000/aquilarum.kml", ignoreAltitude=TRUE)

#this time, seven polys....

makeDf <- function(importedKML) {
  range<-importedKML
  df1<-as_tibble(range[[1]])
  df2<-as_tibble(range[[2]])
  df3<-as_tibble(range[[3]])
  df4<-as_tibble(range[[4]])
  df5<-as_tibble(range[[5]])
  df6<-as_tibble(range[[6]])
  df<-rbind(df1,df2,df3,df4,df5,df6)
  hullrange<-chull(c(df$V1,df$V2))
  return(df[hullrange,])
}
range<-aquilarum
df1<-as_tibble(range[[1]])
df2<-as_tibble(range[[2]])
df3<-as_tibble(range[[3]])
df4<-as_tibble(range[[4]])
df5<-as_tibble(range[[5]])
df6<-as_tibble(range[[6]])
df7<-as_tibble(range[[7]])


eglk<-mrrt + 
  geom_polygon(data=df1,aes(x=V1, y=V2), alpha=0.75, fill="orange") +
  geom_polygon(data=df2,aes(x=V1, y=V2), alpha=0.75, fill="orange") +
  geom_polygon(data=df3,aes(x=V1, y=V2), alpha=0.75, fill="orange") +
  geom_polygon(data=df4,aes(x=V1, y=V2), alpha=0.75, fill="orange") +
  geom_polygon(data=df5,aes(x=V1, y=V2), alpha=0.75, fill="orange") +
  geom_polygon(data=df6,aes(x=V1, y=V2), alpha=0.75, fill="orange") +
  geom_polygon(data=df7,aes(x=V1, y=V2), alpha=0.75, fill="orange") 

eglk