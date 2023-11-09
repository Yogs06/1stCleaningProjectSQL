select * 
from [DataCleaningProject].[dbo].[NashvilleHousing]

-- convert date

select SaledateConverted , CONVERT(date, SaleDate)
from [DataCleaningProject].[dbo].[NashvilleHousing]

update NashvilleHousing
set SaleDate = CONVERT(date, SaleDate)

alter table [NashvilleHousing]
add SaledateConverted Date;

Update NashvilleHousing
set SaledateConverted = CONVERT(date, SaleDate)

-- populate property address

select *
from [DataCleaningProject].[dbo].[NashvilleHousing]
--where PropertyAddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from [DataCleaningProject].[dbo].[NashvilleHousing] a
join [DataCleaningProject].[dbo].[NashvilleHousing] b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [DataCleaningProject].[dbo].[NashvilleHousing] a
join [DataCleaningProject].[dbo].[NashvilleHousing] b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


-- breaking out address to columns

select PropertyAddress
from [DataCleaningProject].[dbo].[NashvilleHousing]
--where PropertyAddress is null
--order by ParcelID

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address

from [DataCleaningProject].[dbo].[NashvilleHousing]

alter table [NashvilleHousing]
add PropertySplitAddress Nvarchar(255)

Update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


alter table [NashvilleHousing]
add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))

Select *
from [DataCleaningProject].[dbo].[NashvilleHousing]


Select OwnerAddress
from [DataCleaningProject].[dbo].[NashvilleHousing]


Select
PARSENAME(Replace(OwnerAddress,',','.'), 3),
PARSENAME(Replace(OwnerAddress,',','.'), 2),
PARSENAME(Replace(OwnerAddress,',','.'), 1)
from [DataCleaningProject].[dbo].[NashvilleHousing]


alter table [NashvilleHousing]
add OwnerSplitAddress Nvarchar(255)

Update NashvilleHousing
set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'), 3)


alter table [NashvilleHousing]
add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'), 2)

alter table [NashvilleHousing]
add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'), 1)

Select *
from [DataCleaningProject].[dbo].[NashvilleHousing]

-- Change Y and N to Yes and No in SoldasVacant column 

Select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from [DataCleaningProject].[dbo].[NashvilleHousing]
group by SoldAsVacant

Select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end
from [DataCleaningProject].[dbo].[NashvilleHousing]

update [NashvilleHousing]
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end

-- Remove Duplicates

with RowNumCTE as(
Select *,
ROW_NUMBER() over (
partition by ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 order by 
			  UniqueID
			  ) row_num
from [DataCleaningProject].[dbo].[NashvilleHousing]
--order by ParcelID
)

Select *
from RowNumCTE
where row_num > 1
order by PropertyAddress

Select *
from [DataCleaningProject].[dbo].[NashvilleHousing]


-- Delete Unsused Columns

Select *
from [DataCleaningProject].[dbo].[NashvilleHousing]

Alter Table [DataCleaningProject].[dbo].[NashvilleHousing]
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table [DataCleaningProject].[dbo].[NashvilleHousing]
Drop Column SaleDate

Select *
from [DataCleaningProject].[dbo].[NashvilleHousing]

-- Done Well Done!!