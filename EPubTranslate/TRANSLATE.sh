#!/bin/bash
# This script lets you present different menus to Tux.  He will only be happy
# when given a fish.  To make it more fun, we added a couple more animals.
#!/bin/bash
# This script will test if you have given a leap year or not.
rm -rf trans_text2.txt
touch trans_text2.txt
rm -rf trans_text.txt
touch trans_text.txt
rm -rf text2
touch text2
cat text | sed 's/[.!,?]  */&\n/g' >> text2

#SLANG=`sed -n '1p' $SCRIPT_AREA/tlang`
#DLANG=`sed -n '2p' $SCRIPT_AREA/tlang`
#ENGINE=`sed -n '3p' $SCRIPT_AREA/tlang`
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

while IFS='' read -r line || [[ -n "$line" ]]; do
  echo "$line" >> trans_text2.txt
  echo "{(" >> trans_text2.txt
  #trans -e 'bing' -s de -t en "$line" --brief | sed  's/.*>//g' >> trans_text2.txt

  python3 $SCRIPT_DIR/translate.py $line  | sed  's/.*>//g' >> trans_text2.txt
  
  #trans -no-auto -s $SLANG -t $DLANG -b -e $ENGINE "$line" >> trans_text2.txt
  echo ")}" >> trans_text2.txt
done < text2

#cat trans_text2.txt
cat trans_text2.txt | tr '\n' ' ' >> trans_text.txt
