while [ ! -f ./Makefile -a $PWD != "/" ]
do 
  cd ..
done;
if [ -f ./Makefile ]; then
  echo -n "exec "
  echo `realpath ./Makefile`
  make
else
  echo "error: Makefile not found in current and all parent dir."
  exit 1
fi
