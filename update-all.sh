for d in */; do
  echo "$d"
  cd "$d"
  rm -fr node_modules/
  npm install
  npm outdated
  npm update
  cd ..
done