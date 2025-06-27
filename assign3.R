#By Prakrit Dayal

setwd("/Users/prakrit/Desktop/Data Analytics/Assignment3")
library(dplyr)
library(tm); library(NLP) ; library(slam); library(SnowballC)
rm(list = ls())

cname = file.path(".", "CorpusAssign3")
dir(cname)

docs = Corpus(DirSource((cname)))

#fixing up the probelm quotations
toSpace <- content_transformer(function(x, pattern)
  gsub(pattern, '"', x))
docs <- tm_map(docs, toSpace, '”')
docs <- tm_map(docs, toSpace, '“')

#x-ray was coming as x ray, which is incorrect
toSpace <- content_transformer(function(x, pattern)
gsub(pattern, 'xray', x))
docs <- tm_map(docs, toSpace, 'X-ray')
docs <- tm_map(docs, toSpace, 'x—ray')

#remove dashes
toSpace <- content_transformer(function(x, pattern)
  gsub(pattern, ' ', x))
docs <- tm_map(docs, toSpace, '-')
docs <- tm_map(docs, toSpace, '—')

#remove other type  of problem quotations
toSpace <- content_transformer(function(x, pattern)
  gsub(pattern, "'", x))
docs <- tm_map(docs, toSpace, '’')
docs <- tm_map(docs, toSpace, '‘')

#tokenisation
docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeWords,stopwords("english"))
docs <- tm_map(docs, stripWhitespace)
docs <- tm_map(docs, stemDocument, language ="english")

#creating base dtm
dtm <- DocumentTermMatrix(docs)

freq <- colSums(as.matrix(dtm))
ord1 = order(freq)
#freq[tail(ord1,15)]


dtms <- removeSparseTerms(dtm, 0.4) # rem. 40% empty
#dim(dtms)

#creating DTM matrix as readable format
freq2 <- colSums(as.matrix(dtms))
ord2 = order(freq2)
freq2[tail(ord2,15)]

#creating the DTM in readable format
dtm_final = as.data.frame(freq2[order(freq2,decreasing = TRUE)])
colnames(dtm_final) = "Frequencies"

#write.csv(freq2[order(freq2,decreasing = TRUE)], "dtms_Space.csv")

#calculating the cosine distance
distmatrix = proxy::dist(as.matrix(dtms), method = "cosine") #cosine distance
fit = hclust(distmatrix, method = "ward.D")
plot(fit)
plot(fit, hang = -1)
#clustering into 5 groups
rect.hclust(fit, k=5, border = "red")

topics = c("nyc_food","nyc_food","nyc_food",
           "movie_summary", "movie_summary", "movie_summary", "movie_summary",
           "dark_matter","dark_matter","dark_matter",
           "dark_matter", "dark_matter","mission_overview","mission_overview",
           "info_article", "info_article")
groups = cutree(fit, k = 5)
conf.mtx = table(GroupNames = topics, Clusters = groups)
accuracy = (conf.mtx[1,2]+conf.mtx[2,5]+conf.mtx[3,3]+conf.mtx[4,4]+conf.mtx[5,1])*100 /length(topics) 
#write.csv(conf.mtx, "conf.mtx.csv")

 library(igraph); library(igraphdata)
#5
dtmsx = as.matrix(dtms)
dtmsx = as.matrix((dtmsx > 0 ) + 0)
ByAbsMatrix = dtmsx%*%t(dtmsx)
diag(ByAbsMatrix) = 0

#write.csv(ByAbsMatrix, "abs.mtx.csv")

ByAbs = graph_from_adjacency_matrix(ByAbsMatrix, mode="undirected", weighted = TRUE)
edge_widths_abs <- E(ByAbs)$weight/5 # edge width is a measure of edge weight
vertex_sizes_abs <- (evcent(ByAbs)$vector)*25 #vertex size is a measure of eig centrality

vertex_names_abs <- V(ByAbs)$media
plot(ByAbs,edge.width = edge_widths_abs,vertex.size = vertex_sizes_abs,
     edge.color="gold",vertex.frame.color= "#B59410",vertex.color="#E1D898",
     vertex.label=vertex_names_abs, vertex.label.color="black",vertex.label.cex = 0.8, main = "Abstract Network" )

##next line creates the df containing the degree, betweenness, closeness, and eig of all nodes in the network
summary.abs = cbind(as.data.frame(degree(ByAbs)),as.data.frame(betweenness(ByAbs))
                ,as.data.frame(closeness(ByAbs)),as.data.frame(evcent(ByAbs)$vector) )
colnames(summary.abs)= c("Degree", "Betweenness", "Closeness", "Eigenvector")
#round to 3 sigfigs
summary.abs = summary.abs %>% 
  mutate_all(~signif(., digits = 3))
#write.csv(summary.abs, "abs.network.summary.csv")
summary.abs


#6
ByTokenMatrix = t(dtmsx)%*%dtmsx
diag(ByTokenMatrix) = 0
#write.csv(ByTokenMatrix, "token.mtx.csv")
ByToken = graph_from_adjacency_matrix(ByTokenMatrix, mode="undirected", weighted = TRUE)

edge_widths_token <- E(ByToken)$weight/5 # edge width is a measure of edge weight
vertex_sizes_token <- (evcent(ByToken)$vector)*25 #vertex size is a measure of eig centrality
vertex_names_token <- V(ByToken)$media


plot(ByToken,edge.width = edge_widths_token,vertex.size = vertex_sizes_token,
     edge.color="gold",vertex.frame.color= "#B59410",vertex.color="#E1D898",
     vertex.label=vertex_names_token, vertex.label.color="black" ,vertex.label.cex = 0.8, main = "Token Network" )
#plot(ByToken)

##next line creates the df containing the degree, betweenness, closeness, and eig of all nodes in the network
summary.token = cbind(as.data.frame(degree(ByToken)),as.data.frame(betweenness(ByToken))
                    ,as.data.frame(closeness(ByToken)),as.data.frame(evcent(ByToken)$vector) )
colnames(summary.token)= c("Degree", "Betweenness", "Closeness", "Eigenvector")
#round to 3 sigfigs
summary.token = summary.token %>% mutate_all(~signif(., digits = 3))
#write.csv(summary.token, "token.network.summary.csv")
summary.token

#7
dtmsa = as.data.frame(as.matrix(dtms))
dtmsa$ABS= rownames(dtmsa)
dtmsb= data.frame()
for (i in 1:nrow(dtmsa)){
  for (j in 1:(ncol(dtmsa)-1)){
    touse = cbind(dtmsa[i,j], dtmsa[i,ncol(dtmsa)],colnames(dtmsa[j]))
    dtmsb = rbind(dtmsb,touse)
  }
    
}
colnames(dtmsb)= c("weight", "abs", "token")

dtmsc = dtmsb[dtmsb$weight!=0,]
dtmsc = dtmsc[,c(2,3,1)]
dtmsc
g <- graph.data.frame(dtmsc, directed=FALSE)

V(g)$type = bipartite_mapping(g)$type
V(g)$color = ifelse(V(g)$type, "lightblue", "salmon")
V(g)$frame.color = ifelse(V(g)$type, "skyblue", "darksalmon")
V(g)$shape = ifelse(V(g)$type, "circle", "square")
V(g)$size = (evcent(g)$vector)*15

E(g)$color = "lightgrey"
E(g)$width = as.numeric(E(g)$weight)*0.65

plot(g, vertex.label.color = "Black",vertex.label.cex = 0.65)

summary.bi = cbind(as.data.frame(degree(g)),as.data.frame(betweenness(g))
                      ,as.data.frame(closeness(g)),as.data.frame(evcent(g)$vector) )
colnames(summary.bi)= c("Degree", "Betweenness", "Closeness", "Eigenvector")
#round to 3 sigfigs
summary.bi = summary.bi %>% mutate_all(~signif(., digits = 3))
#write.csv(summary.bi, "bi.network.summary.csv")
summary.bi




