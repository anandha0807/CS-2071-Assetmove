#!/bin/bash

echo "Enter the fileid"
read fileid


    file=cs-2071-assetmove.csv

        echo "$(tput setaf 3)Checking for Asset filepath :$fileid $(tput setaf 7)"

        echo "$(tput setaf 3)Starting... $(tput setaf 7)"

        f=1
        function asset()

        {   
        arr=("$@")
        for i in "${arr[@]}";
        do

            sqlcmd -S PRD-DB-02.ics.com -U sa -P 'SQL h@$ N0 =' -h-1 -d ge -Q  "SET QUOTED_IDENTIFIER OFF;set nocount on;


            DECLARE @assid INT
            set @assid= $i

            declare @tempassets as table (AssetID bigint)

            insert into @tempassets select AssetID from Asset a where a.AssetID IN ($i)

            
            select CASE WHEN a.NewStorageLocation is NULL THEN CONCAT('/mnt/gestore/ge_storage/ge_assets/',REPLACE (a.StorageFolderPath, '\', '/'),'/','Archive/','*.zip')
            WHEN a.NewStorageLocation is NOT NULL THEN CONCAT('/mnt/gestore/ge_storage/ge_objects/',REPLACE (a.StorageFolderPath, '\', '/'),'/','Archive/','*.zip')
			END AS InputZipPath,
            CASE WHEN a.NewStorageLocation is NULL THEN CONCAT('/mnt/gestore/ge_storage/ge_assets/',REPLACE (a.StorageFolderPath, '\', '/'),'/')
            WHEN a.NewStorageLocation is NOT NULL THEN CONCAT('/mnt/gestore/ge_storage/ge_objects/',REPLACE (a.StorageFolderPath, '\', '/'),'/')
			END AS IsilionDestinationPath from Asset a
			where a.AssetID IN (select * from @tempassets)" -s , -W -k1 >> "$fileid".csv


            REWRITE="\e[25D\e[1A\e[K"
            echo -e "${REWRITE}$f done"
            ((f++))

        done
        }
        array=( $(cut -d ',' -f2 $file ) )
        asset "${array[@]}"

sleep 2s
echo "input zip has been generated successfully"