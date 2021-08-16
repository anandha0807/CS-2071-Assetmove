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


            DECLARE @assid nVARCHAR(400)
            set @assid= $i


			declare @tempassets as table (AssetID int)
			insert into @tempassets select a.AssetID from Asset a where a.Filename=$i and a.DeletetedOn is NULL

            select  a.AssetID,acc.AccountID,acc.AccountName,j.JobName,CONCAT(acc.AccountName,' \ ',j.JobName,' \ ',[dbo].[udf_GetFolderPath](jf.JobFolderID)) as FolderPath,a.Filename from JobFolder jf
            inner join job j on j.JobID=jf.JobID
            inner join Asset a on a.JobFolderID=jf.JobFolderID
            inner join Account acc on acc.AccountID=j.OwnerAccountID
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