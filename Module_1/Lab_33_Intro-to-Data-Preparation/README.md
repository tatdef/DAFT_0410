![logo_ironhack_blue 7](https://user-images.githubusercontent.com/23629340/40541063-a07a0a8a-601a-11e8-91b5-2f13e4e6b441.png)

# Lab | Data Preparation 


## Dataset

The original dataset is available at this (link)[https://docs.google.com/spreadsheets/d/1CYSDJooG0_58AzbYNRwvtC3gXIUhZNg1/edit?usp=sharing&ouid=109198901319062172979&rtpof=true&sd=true]

## Tasks
### Part 1: Upload the data
* open with open_excel in python 

### Part 2: Analyze your data and create a plan for data preparation
Describe : 
* this seems to be data about individuals, qualified by client ID, year of birth, profession and risk level 
* this is probably an insurance database, or a lending databas 
* transactions for those individuals (identified by transaction ID) and amounts are also available
Plan : 
* remove the empty columns at the end as well as the empty row
* check data types and simplify those with a lot of numbers after the .
* harmonize professions 
* identify if possible to fill NAN or missing values 
* there seems to be an outlier in the amount column 

### Part 3: Data cleansing  (missing values, outliers, duplicates, data consistently)
* remove unnecessary columns (two last columns, department as all values are the same)
* remove empty row
* check for duplicates : not in full, but there can be several transactions for one client
* for missing values, check if client has other transactions, and based on that, fill year of birth and profession
* harmonize professions (lowercase, grouping)
* check data types and switch Year, ID, Amount and transactionID to integers 
* check for outliers : one identified (irregular amount) - drop the relevant row (there is no duplicate for this client)

### Part 4: Encode categorical data
* was already encoded (High/Medium/Low) for Risk. We could have made it into 1, 2, 3, but this is more of an analytical step. We prefer not to do it at this stage as it removes detail from our table. Ideally, we would need to know how these three categories are constructed and what  the distance/ distribution between them is. 

### Part 5: Upload the deliverables to GitHub
Here we go. 

## Resources

[Pandas - data preparation] https://towardsdatascience.com/essential-commands-for-data-preparation-with-pandas-ed01579cf214

[Pandas] https://realpython.com/python-data-cleaning-numpy-pandas/
