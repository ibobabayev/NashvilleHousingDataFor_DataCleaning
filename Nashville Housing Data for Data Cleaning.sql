select * from PortfolioProject.dbo.Sheet1$

-- Standardize Date Format
select SaleDate,CONVERT(date,SaleDate) from PortfolioProject.dbo.Sheet1$

Alter Table Sheet1$ Add SaleDateConverted Date

Update PortfolioProject.dbo.Sheet1$ Set SaleDateConverted = CONVERT(date,SaleDate)

-- Populate Property Address data

Select * from PortfolioProject.dbo.Sheet1$ order by ParcelID 

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.Sheet1$ a join PortfolioProject.dbo.Sheet1$ b  on a.ParcelID = b.ParcelID and a.UniqueID <> b.UniqueID
where a.PropertyAddress is Null 

Update a 
Set a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress) from PortfolioProject.dbo.Sheet1$ a 
join PortfolioProject.dbo.Sheet1$ b  on a.ParcelID = b.ParcelID and a.UniqueID <> b.UniqueID
where a.PropertyAddress is Null 

-- Breaking out Address into Individual Columns (Address, City,State)

Select PropertyAddress,SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as City
from PortfolioProject.dbo.Sheet1$

Alter table PortfolioProject.dbo.Sheet1$ Add Address text
Update PortfolioProject.dbo.Sheet1$ Set Address = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter table PortfolioProject.dbo.Sheet1$ Add City text
Update PortfolioProject.dbo.Sheet1$ Set City = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

select PropertyAddress,Address,City from PortfolioProject.dbo.Sheet1$




Select OwnerAddress from PortfolioProject.dbo.Sheet1$

Select Parsename(Replace(OwnerAddress,',','.'),1),Parsename(Replace(OwnerAddress,',','.'),2),Parsename(Replace(OwnerAddress,',','.'),3) from PortfolioProject.dbo.Sheet1$

Alter table PortfolioProject.dbo.Sheet1$ Add OwnerSplitAddress text
Update PortfolioProject.dbo.Sheet1$ Set OwnerSplitAddress = Parsename(Replace(OwnerAddress,',','.'),3)

Alter table PortfolioProject.dbo.Sheet1$ Add OwnerSplitCity text
Update PortfolioProject.dbo.Sheet1$ Set OwnerSplitCity = Parsename(Replace(OwnerAddress,',','.'),2)

Alter table PortfolioProject.dbo.Sheet1$ Add OwnerSplitState text
Update PortfolioProject.dbo.Sheet1$ Set OwnerSplitState = Parsename(Replace(OwnerAddress,',','.'),1)

Select OwnerAddress,OwnerSplitAddress,OwnerSplitCity,OwnerSplitState from PortfolioProject.dbo.Sheet1$



-- Change Y and N to Yes and No in "Sold as Vacant" field

Select SoldAsVacant From PortfolioProject.dbo.Sheet1$ where SoldAsVacant = 'N' or SoldAsVacant = 'Y'

SELECT SoldAsVacant, CASE WHEN SoldAsVacant='N' THEN 'No' WHEN SoldAsVacant='Y' THEN 'Yes' ELSE SoldAsVacant END FROM PortfolioProject.dbo.Sheet1$

Update PortfolioProject.dbo.Sheet1$ set SoldAsVacant = CASE WHEN SoldAsVacant='N' THEN 'No' WHEN SoldAsVacant='Y' THEN 'Yes' ELSE SoldAsVacant END

Select SoldAsVacant From PortfolioProject.dbo.Sheet1$ where SoldAsVacant = 'N' or SoldAsVacant = 'Y'

-- Remove Duplicates
Select * From PortfolioProject.dbo.Sheet1$

With Row_Num as
(
Select *,ROW_NUMBER() OVER (Partition by ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference Order by UniqueID) as row_num
From PortfolioProject.dbo.Sheet1$ 
)
Delete from Row_Num
where row_num > 1


With Row_Num as
(
Select *,ROW_NUMBER() OVER (Partition by ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference Order by UniqueID) as row_num
From PortfolioProject.dbo.Sheet1$ 
)
Select * from Row_Num
where row_num > 1

-- Delete Unused Columns
Select * From PortfolioProject.dbo.Sheet1$

Alter Table PortfolioProject.dbo.Sheet1$ Drop Column PropertyAddress,OwnerAddress,TaxDistrict