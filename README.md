🛒 Store Format Optimization Using K-Means Clustering
📌 Project Overview
A grocery retail company operating 85 stores currently applies a uniform store format and inventory distribution strategy across all locations. This standardized approach has led to recurring product surpluses in some categories and shortages in others, indicating a misalignment between local demand and product assortment.
This project applies unsupervised machine learning (K-means clustering) to segment stores into differentiated formats based on sales composition. The goal is to enable data-driven inventory planning and improve alignment between product mix and customer demand.
________________________________________
🎯 Business Objective
•	Determine the optimal number of store formats using historical sales data
•	Segment all 85 stores into distinct formats
•	Identify meaningful differences in product mix across formats
•	Provide analytical support for improved assortment and inventory decisions
________________________________________
📂 Data Sources
•	Sales.csv
•	StoreInfo.csv
Data Preparation Steps
1.	Aggregated sales by StoreID and Year
2.	Filtered to 2015 sales data only
3.	Calculated category sales as a percentage of total store sales
4.	Standardized features for clustering
Clustering on percentage composition ensures segmentation reflects structural demand differences rather than absolute store size.
________________________________________
🧠 Methodology
Model: K-Means Clustering
K-means clustering was selected because it:
•	Provides interpretable store groupings
•	Scales efficiently across multiple locations
•	Works well with continuous, normalized features
•	Produces actionable operational segments
________________________________________
📊 Determining the Optimal Number of Formats
The optimal number of clusters was determined using the Elbow Method, which evaluates:
•	Number of clusters (k)
•	Total Within-Cluster Sum of Squares (WCSS)
The “elbow point” occurred at:
k = 4
At this point, the marginal reduction in WCSS began to slow, indicating diminishing returns from adding additional clusters. Four store formats provide the best balance between explanatory power and model simplicity.
________________________________________
📈 Results
Store Distribution by Format
Store Format	Number of Stores
Format 1	15
Format 2	12
Format 3	27
Format 4	31
The distribution shows two dominant formats (3 and 4) alongside two smaller, more distinct segments.
________________________________________
Cluster Differentiation
The clusters differ primarily in relative product category emphasis, not total sales volume.
Observed differences include:
•	Certain formats show higher concentration in specific product categories
•	Other formats exhibit more balanced category distributions
•	Structural differences in demand patterns across locations
These insights support differentiated product selection and improved inventory allocation.
________________________________________
🗺 Geospatial Visualization
An interactive map was developed using Plotly in R (plot_geo() and add_markers()):
•	📍 Marker color = Store format (cluster)
•	📏 Marker size = Total store sales
•	🖱 Interactive hover tooltips
•	📖 Legend included
This visualization provides intuitive insight into:
•	Geographic clustering of formats
•	Regional demand characteristics
•	Sales magnitude distribution
The map is hosted via GitHub Pages for public viewing.
________________________________________
🛠 Tools & Technologies
•	R
o	dplyr
o	tidyr
o	plotly
o	stats::kmeans
•	GitHub Pages (for interactive hosting)
•	Data preprocessing and feature engineering techniques
________________________________________
💡 Business Impact
This segmentation framework enables:
•	Format-specific product assortment
•	Reduction of category-level overstock and shortages
•	Improved demand alignment
•	More efficient inventory distribution
•	Scalable strategy for future store expansion
The methodology can be reused annually or extended to new locations.
________________________________________
📌 Key Skills Demonstrated
•	Unsupervised machine learning
•	Feature engineering using percentage normalization
•	Model validation using WCSS diagnostics
•	Cluster interpretation and business translation
•	Geospatial data visualization
•	Clear communication of analytical results
________________________________________
👤 Seun Komolafe
Developed as part of a retail analytics case study demonstrating practical application of clustering techniques to operational and strategic decision-making.
