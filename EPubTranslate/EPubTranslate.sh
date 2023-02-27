#!/bin/bash
file=$(basename "$1" .epub)
cp $1 $file.zip
rm -rf ZIP
mkdir ZIP
cd ZIP
cp ../$file.zip .
unzip $file.zip
rm -rf $file.zip
rm -rf WD
mkdir WD

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


UNDERLINE_OPTION="YES"
#UNDERLINE_OPTION=`sed -n '4p' $SCRIPT_AREA/tlang`

touch html_files
find . -name "*.html" >> html_files 
find . -name "*.htm" >> html_files 
find . -name "*.xhtml" >> html_files 

for f in `cat html_files`
do
  echo "FILE : $f"
  perl -0777 -pe 's/<\/span.*?>//gs' $f | perl -0777 -pe 's/<span.*?>//gs' >> 1.html
  cp 1.html WD/test.html
  rm -rf 1.html
  cd WD
  rm -rf test2.html
  perl $SCRIPT_DIR/sc.pl
  cd ..
  extension="${f##*.}"
  if [ "$extension" = "xhtml" ]; then
    html2xhtml  WD/test2.html >> WD/test3.html
    sed -i 's/iso-8859-1/UTF-8/g'  WD/test3.html
    mv WD/test3.html WD/test2.html
  fi
  mv WD/test2.html $f
  sed -i 's/&uuml;/ü/g' $f
  sed -i 's/&auml;/ä/g' $f 
  sed -i 's/&ouml;/ö/g' $f 
  sed -i 's/&szlig;/ß/g' $f
  if [ "$extension" = "NO_UNDERLINE" ]; then 
    sed -i 's/{(//g' $f
    sed -i 's/)}//g' $f
  else 
    sed -i 's/{(/<u>/g' $f
    sed -i 's/)}/<\/u>/g' $f
  fi
done
rm -rf $file.zip
rm -rf WD
rm -rf html_files
zip -r new_file.zip *
mv new_file.zip $1
mv $1 ../TRANSLATED_$1
cd ..
rm -rf ZIP
rm -rf *.zip
ebook-convert TRANSLATED_$1 TRANSLATED_$1.mobi
