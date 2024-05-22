Select *
From PortfolioProject2.dbo.Walmart_sales$

--Check for missing data
SELECT *
From PortfolioProject2.dbo.Walmart_sales$
WHERE COALESCE(Store, [Date], Weekly_Sales, Holiday_Flag, Temperature, Fuel_Price, CPI, Unemployment) IS NULL;

--Standarize date by MM-DD-YYYY and update table.
Select [Date],
CONVERT(VARCHAR(10),CONVERT(DATE,[Date], 103),32) as DateConverted
From PortfolioProject2.dbo.Walmart_sales$

Update Walmart_sales$
SET [Date] = CONVERT(VARCHAR(10),CONVERT(DATE,[Date], 103),32)


--Sorting Data by store number-ascending and by date-ascending.
Select *
From PortfolioProject2.dbo.Walmart_sales$
Order BY Store ASC, Cast([Date] as DATE)

--Round Weekly_Sales to nearest 2 decimal places
Select CAST(Weekly_Sales as DECIMAL(10,2))
From PortfolioProject2.dbo.Walmart_sales$

ALTER TABLE Walmart_sales$
Add Weekly_Sales_Rounded DECIMAL(10,2)

UPDATE Walmart_sales$
SET Weekly_Sales_Rounded = CAST(Weekly_Sales as DECIMAL(10,2))


--Round Temperature to nearest whole number
Select ROUND(Temperature,0)
From PortfolioProject2.dbo.Walmart_sales$

ALTER TABLE Walmart_sales$
Add Temperature_Rounded INTEGER

UPDATE Walmart_sales$
SET Temperature_Rounded = ROUND(Temperature,0)


--Round fuel price to nearest 2 decimal places
Select CAST(Fuel_Price as DECIMAL(10,2))
From PortfolioProject2.dbo.Walmart_sales$

ALTER TABLE Walmart_sales$
Add Fuel_Price_Rounded DECIMAL(10,2)

UPDATE Walmart_sales$
SET Fuel_Price_Rounded = CAST(Fuel_Price as DECIMAL(10,2))


--Round CPI to Nearest 3 Decimal Places
Select CAST(CPI as DECIMAL(10,3))
From PortfolioProject2.dbo.Walmart_sales$

ALTER TABLE Walmart_sales$
Add CPI_Rounded DECIMAL(10,3)

UPDATE Walmart_sales$
SET CPI_Rounded = CAST(CPI as DECIMAL(10,3))

--Round Unemployment to Nearest 3 Decimal Places
Select CAST(Unemployment as DECIMAL(10,3))
From PortfolioProject2.dbo.Walmart_sales$

ALTER TABLE Walmart_sales$
Add Unemployment_Rounded DECIMAL(10,3)

UPDATE Walmart_sales$
SET Unemployment_Rounded = CAST(Unemployment as DECIMAL(10,3))

--Drop unused columns
ALTER TABLE Walmart_sales$
DROP COLUMN Weekly_Sales, Temperature, Fuel_Price, CPI, Unemployment


