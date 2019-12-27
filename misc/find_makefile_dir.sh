OLDPWD=$PWD
while [ ! -f ./Makefile -a $PWD != "/" ]
do 
  cd ..
done;
if [ -f ./Makefile ]; then
  echo -n "found: "
  echo `realpath ./Makefile`
else
  echo "error: Makefile not found in current and all parent dir."
  cd $OLDPWD
  exit 1
fi
