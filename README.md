# Big_data_splines

The objective: Using "crsp" and "compustat" dataset and splines method assess 
if the dependent variable "return" ("RET") can be predict by independent variables from "compustat" dataset.

The first step is to merge the data sets by company name and date. Later we removed all the lines which contain "NA".
Drawing histograms we remove oustanding companies (in terms of stock price and return) and what is very important 
is that we delete the rows with negative price of the stocks - it is imposible that the company has negative price.

Using a for-loop we check if any of the variable from the "compustat" dataset has a correlation with the return ("RET"). We draw
the the plot each second to see any tendency in dependent and independent variables but as result we see that is impossible to
see the relationship between return and any other variable.

We use the training sample to create our prediction model and then validate it using the valiadtion sample. 

Conclusion: Splines do not work on gives dataset to predict the return.
   
