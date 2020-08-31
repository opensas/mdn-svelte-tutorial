for d in */; do
  echo "entering $d"
  cd "$d"
  rm -fr node_modules/
  npm install
  npm outdated
  # npm update
  cd ..
  echo "----"
done