library(tidyverse)

###### Read in data
sales2 <- read.csv('Sales.csv', sep=';')
storeinfo <- read.csv('Store.csv', sep=';')

sales <- sales2 %>% inner_join(storeinfo, by='Store')
###### Check row numbers 
nrow(sales2)
nrow(storeinfo)
nrow(sales)

# 	Sum sales data by StoreID and Year
grp <- c("Dry_Grocery", "Dairy", "Frozen_Food", "Meat", "Produce", "Floral", "Bakery", "General_Merchandise")
new_df <- sales %>% group_by(Store, Year) %>% summarise(across(grp, sum, na.rm=TRUE)) %>% mutate_at(grp, as.numeric)

#	Use percentage sales per category per store for clustering (category sales as a percentage of total store sales).
new_df['total_sales'] <- new_df %>% ungroup() %>% select(grp) %>% rowSums()
new_df <- as.data.frame(new_df)
for(i in 1:nrow(new_df)){
  new_df[i, grp] = new_df[i, grp]/new_df[i, 'total_sales']
}

# Use only 2015 sales data.
 new_df<- new_df %>% filter(Year=='2015')
 model_df <- new_df %>% select(-total_sales)
# 	Use a K-means clustering model.
library(factoextra)
# Compute k-means with k = 4
set.seed(123)
twss <- vector()
for (i in 1:20){
  twss[i] <- kmeans(model_df[grp], i, nstart = 25)$tot.withinss
}
plot(twss, type="b", xlab = 'Number of clusters', main='The Elbow Method', ylab= 'WCSS')
abline(v=4, lty=2,lwd=2,col='darkred')


km.res <- kmeans(model_df[grp], 4, nstart = 25)
head(km.res$cluster, 4)
km.res$size
km.res$centers

fviz_cluster(km.res, data = model_df[grp],
             palette = c("#01AFCB","#2E9FDF", "#F7B800", "#EE4E07"),
             ggtheme = theme_minimal(),
             main = "Partitioning Clustering Plot"
) 

group1 = data.frame(t(model_df[grp][km.res$cluster == 2,]))
summary(sapply(group1, mean))
group1_mean <- sapply(group1, mean)
hist(sapply(group1, mean), main = "Histogram of Product Group 1", xlab = "Number of Transactions")

library("FactoMineR")
res.pca <- PCA(model_df[grp],  graph = FALSE)
get_eig(res.pca)
fviz_screeplot(res.pca, addlabels = TRUE, ylim = c(0, 50))
fviz_pca_var(res.pca, col.var = "black")

# Control variable colors using their contributions
fviz_pca_var(res.pca, col.var="contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE # Avoid text overlapping
)

# Contributions of variables to PC1
fviz_contrib(res.pca, choice = "var", axes = 1, top = 10)

# Contributions of variables to PC2
fviz_contrib(res.pca, choice = "var", axes = 2, top = 10)
ind <- get_pca_ind(res.pca)
ind
head(ind$coord)
fviz_pca_ind(res.pca, col.ind = "cos2", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE # Avoid text overlapping (slow if many points)
)
fviz_pca_biplot(res.pca, repel = TRUE)

# 	Segment the 85 current stores into the different store formats.

#	Use the Sales.csv and StoreInfo.csv files.
#library(ggmap)
#register_google(key = "[our API key]")
#write.csv(file='locationsdf.csv', locations_df)
#df = storeinfo %>% mutate(ad = paste(Address, City, State))
#locations_df2 <- mutate_geocode(df, ad)
#locations_df2 <- read.csv('completelocations.csv')
#write.csv(file='completelocations.csv', locations_df2)
locations_df2 = read.csv('completelocations.csv')
df <- locations_df2 %>% right_join(new_df, by='Store')
df['cluster'] = km.res$cluster


library(plotly)
ca_lat <- c(24, 26)
ca_lon <- c(-120, -115)
g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  showland = TRUE,
  zoom =8,
  showlakes = TRUE,
  landcolor = toRGB("gray85"),
  subunitwidth = 1,
  countrywidth = 1,
  lataxis = list(range = ca_lat), # Sets vertical zoom
  lonaxis = list(range = ca_lon), # Sets horizontal zoom
  center = list(lat = 33.9, lon = -117.3),
  subunitcolor = toRGB("white"),
  countrycolor = toRGB("white")
)

fig <- plot_geo(df, locationmode = 'USA-states', sizes = c(1, 250))
fig <- fig %>% add_markers(
  x = ~lon, y = ~lat, size = ~total_sales, color=~cluster, hoverinfo = "text",
  text = ~paste(df$Store, "<br />","$", df$total_sales)
)
# fig <- fig %>% layout(
#   mapbox=list(
#     style="carto-positron",
#     zoom =6,
#     center=list(lon=-73.7073, lat=45.5517))
# 
# )
fig <- fig %>% layout(title = 'Stores and Clusters on the Map', geo = g)

fig

library(htmlwidgets)

# Assuming your object is called fig
saveWidget(fig, "index.html", selfcontained = TRUE)








