#!/bin/bash
# define variables at the start of script 
# so that it can be accessed by our function
TEST="/tmp/filename"

# write perform() function
perform(){
  mkdir "$1"
  cd "$1"
  echo "************* $1 *************"
FILES="*"
for f in $FILES
  do
    echo $f
    cp "$f" "../$1-$f"
  done
  cd ..
}


allLanguages=(en de)

for lang in "${allLanguages[@]}"
do
cd "$lang"

perform "iPhone 8"
perform "iPhone 8 Plus"
perform "iPhone 11 Pro Max"
perform "iPhone 11 Pro"

cd ..
done

