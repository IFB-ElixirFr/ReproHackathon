INDEXES='/ifb/data/public/teachdata/reprohack3/ARCH2016-04-15/ZA16_organized_database.csv'


list_index='2000 3 1 2'

for i in $list_index ;
do awk -F ';'  -v ligne="$i" "NR==1 || NR==ligne" $INDEXES > "indexes/ligne_"$i".csv"
 
done 
