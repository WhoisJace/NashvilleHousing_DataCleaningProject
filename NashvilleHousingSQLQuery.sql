Select*
FROM PortfolioProject2.dbo.NashvilleHousing

-- Standardizing Date Format

Select Saledateconverted, CONVERT(Date,SaleDate)
from PortfolioProject2.dbo.NashvilleHousing

update PortfolioProject2.dbo.NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE PortfolioProject2.dbo.NashvilleHousing
Add Saledateconverted Date;

update PortfolioProject2.dbo.NashvilleHousing
SET Saledateconverted = CONVERT(Date,SaleDate)

-- Populate property address data 

Select*
from PortfolioProject2.dbo.NashvilleHousing
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, Isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject2.dbo.NashvilleHousing a
JOIN PortfolioProject2.dbo.NashvilleHousing b
	on a.ParcelID = b. ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = Isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject2.dbo.NashvilleHousing a
JOIN PortfolioProject2.dbo.NashvilleHousing b
	on a.ParcelID = b. ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking out address into individual columns (Address, City, State)


Select
PARSENAME(REPLACE (PropertyAddress, ',', '.'), 2),
PARSENAME(REPLACE (PropertyAddress, ',', '.'), 1)
from PortfolioProject2.dbo.NashvilleHousing

ALTER TABLE PortfolioProject2.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

update PortfolioProject2.dbo.NashvilleHousing
SET PropertySplitAddress = PARSENAME(REPLACE (PropertyAddress, ',', '.'), 2)

ALTER TABLE PortfolioProject2.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

update PortfolioProject2.dbo.NashvilleHousing
SET PropertySplitCity = PARSENAME(REPLACE (PropertyAddress, ',', '.'), 1)



Select
PARSENAME(REPLACE (Owneraddress, ',', '.'), 3),
PARSENAME(REPLACE (Owneraddress, ',', '.'), 2),
PARSENAME(REPLACE (Owneraddress, ',', '.'), 1)
from PortfolioProject2.dbo.NashvilleHousing

ALTER TABLE PortfolioProject2.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

update PortfolioProject2.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE (Owneraddress, ',', '.'), 3)

ALTER TABLE PortfolioProject2.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

update PortfolioProject2.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE (Owneraddress, ',', '.'), 2)

ALTER TABLE PortfolioProject2.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

update PortfolioProject2.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE (Owneraddress, ',', '.'), 1)

-- Change Y and N to 'Yes' and 'No' in "Sold as Vacant" Field

Select Distinct(SoldAsVacant), Count(SoldAsVacant) 
FROM PortfolioProject2.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'Yes'
	when SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM PortfolioProject2.dbo.NashvilleHousing

UPDATE PortfolioProject2.dbo.NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
	when SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END

-- Remove Duplicates

----DELTE ROWS
With RowNumCTE as(
Select*,
	Row_number() Over(
	Partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	ORDER BY UniqueID) Row_num
FROM PortfolioProject2.dbo.NashvilleHousing

)

DELETE
From RowNumCTE
Where Row_num > 1

---- CHECK IF ROWS HAVE BEEN SUCCESFULLY DELETED
With RowNumCTE as(
Select*,
	Row_number() Over(
	Partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	ORDER BY UniqueID) Row_num
FROM PortfolioProject2.dbo.NashvilleHousing

)
SELECT*
From RowNumCTE
Where Row_num > 1
Order by PropertyAddress

-- Remove unused columns

ALTER TABLE PortfolioProject2.dbo.NashvilleHousing
DROP COLUMN PropertyAddress, SaleDate, TaxDistrict, OwnerAddress

-- Check
Select*
FROM PortfolioProject2.dbo.NashvilleHousing
