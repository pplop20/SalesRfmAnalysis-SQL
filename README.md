# SalesRfmAnalysis-SQL
My Queries and dashboards for a sales database from Kaggle

In this project I did a very basic EDA on a database I found online. I would like to give more information about it but I kind of just found it on some random blog linked to a github repository. All I know is that it is from Kaggle. I thought it was inetresting and decided to work on it, specially because it didn't require much cleaning to be done.

## The Dataset
The dataset essentially contains the sales data of a companny that it seems does bussiness within the vehicle world. Everything from ships to vintage cars, and they sell to other bussinesses around the globe. The dataset contains basic information about each order: the customer, where they are from, the status of the order, when (year and month) it was placed, what product it is, etc.

## The Analysis
I started by familiarizing myself with the data, the countries the bussiness delivered to, the products they had, the years in which the sold (that I have available to me), etc. Then I proceeded to write queries that would help me understand the relationships between several of these quantities, again to further familiarize myself with the bussiness. So for example, I found out the revenue each product made, the revenue each year brought in, and the best selling product that the bussiness had. These are some small relationships I wanted to figure out, since it would just be easier to visualize them on Tableau later (since the data is already pretty much cleaned).

Then I proceeded to do an RMF analysis to find out what types of customers the bussiness has. As in finding out who the most loyal customers are, who are the new customers, the ones that don't seems to buy as much anymore, etc. In total I categorized them in 6 different categories: Loyal, Active, Potential churners (customers likely to spend a lot), new customers, slipping away can't loose (customers who used to buy a lot, they don't anymore but it would be benefitial to keep them around); and lost customers. While this type of categorization wouldn't be useful for say, a store, in the figments of my imagination this bussiness deals in the luxury range (they sell boats and vintage cars), so they probably have close relationships with their clients; also since they do bussiness to bussiness sales, those relationships tend to be more personal.

Finally I decided to figure out which products are often bought together. Just for fun, I imagine maybe a deal can be put in place say if, people tend to buy vintage cars with planes; then maybe a "buy a plane and take your vintage car 50% off" deal could be made.

I also plotted a whole bunch of relationships together, as i mentioned before, on Tableau; just to better understand the bussiness. You can see them here: [Sales Dashboard 1](https://public.tableau.com/app/profile/jose.lopez4015/viz/Sales_Dashboard_1_16670065998270/SalesDash1?publish=yes), [Sales Dashboard 2](https://public.tableau.com/app/profile/jose.lopez4015/viz/Sales_Dashboard_2_16670065697380/SalesDash2?publish=yes)



