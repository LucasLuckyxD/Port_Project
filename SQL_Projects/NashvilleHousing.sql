-- Data Overview
SELECT * 
FROM [Portfolio Project].dbo.Nashville_Housing


-- SALE DATE
SELECT SaleDate, convert(date, SaleDate) as Sale_Date
FROM [Portfolio Project].dbo.Nashville_Housing

UPDATE [Portfolio Project].dbo.Nashville_Housing
SET SaleDate = CONVERT(Date, SaleDate)

-- Populating Null values in Property Address Data

SELECT a.[UniqueID ], a.ParcelID, a.PropertyAddress, b.[UniqueID ],b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Portfolio Project].dbo.Nashville_Housing a
JOIN [Portfolio Project].dbo.Nashville_Housing b
ON a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
--WHERE b.PropertyAddress is NULL
--ORDER BY a.ParcelID

SELECT  a.ParcelID, a.OwnerName, b.ParcelID, b.OwnerName
FROM [Portfolio Project].dbo.Nashville_Housing a
JOIN [Portfolio Project].dbo.Nashville_Housing b
ON a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.OwnerName is NULL
ORDER BY a.ParcelID

UPDATE A
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Portfolio Project].dbo.Nashville_Housing a
JOIN [Portfolio Project].dbo.Nashville_Housing b
ON a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
WHERE A.PropertyAddress is NULL

-- Breaking out PropertyAddress into individual Columns

SELECT *
FROM [Portfolio Project].dbo.Nashville_Housing

SELECT propertyAddress,
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) - 1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) as State
FROM [Portfolio Project].dbo.Nashville_Housing

ALTER TABLE [Portfolio Project].dbo.Nashville_Housing
add PropertySplitAddress varchar (255),
	PropertySplitState varchar(255)

UPDATE [Portfolio Project].dbo.Nashville_Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) - 1), 
	PropertySplitState = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))

-- Breaking Out Owner Address to Individual Columns

SELECT *
FROM [Portfolio Project].dbo.Nashville_Housing

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),1) as OwnerSplitState,
PARSENAME(REPLACE(OwnerAddress,',','.'),2) as OwnerSplitCity,
PARSENAME(REPLACE(OwnerAddress,',','.'),3) as OwnerSplitAddress
FROM [Portfolio Project].dbo.Nashville_Housing

ALTER TABLE [Portfolio Project].dbo.Nashville_Housing
add OwnerSplitAddress varchar (255),
	OwnerSplitCity varchar(255),
	OwnerSplitState varchar(255)

UPDATE [Portfolio Project].dbo.Nashville_Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1),
	OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2),
	OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

-- Changing 'N' and 'Y' to 'No' and 'Yes'

SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM [Portfolio Project].dbo.Nashville_Housing
GROUP BY SoldAsVacant

UPDATE [Portfolio Project].dbo.Nashville_Housing
SET SoldAsVacant = 
CASE 
	WHEN SoldAsVacant = 'N' THEN 'No'
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'Yes' or SoldAsVacant =  'No' THEN SoldAsVacant
END 

-- Removing Duplicates (Deleting Data)

WITH RowNumCTE as (
	SELECT *, 
		ROW_NUMBER() over (
		PARTITION BY ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					ORDER BY
						UniqueID) row_num
	FROM [Portfolio Project].dbo.Nashville_Housing
)
DELETE
FROM RowNumCTE
WHERE row_num > 1