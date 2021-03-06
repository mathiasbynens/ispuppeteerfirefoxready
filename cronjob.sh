set -e
set -x

git reset --hard origin/master
git pull origin master

if [ -e ./puppeteer ]; then
  cd puppeteer
  git pull origin master
else
  git clone --depth 1 https://github.com/GoogleChrome/puppeteer
  cd puppeteer
fi

npm i
cd experimental/puppeteer-firefox
npm i
cd ../..

cp ../generateStatus.js .
node generateStatus.js > ../status.json
cd ..
# npm run funit -- --firefox-status | tail -1 > ../status.json

if [ -z "$(git status --untracked-files=no --porcelain)" ]; then
  echo 'NO CHANGES'
  exit 0;
fi

git commit -am 'chore: update status.json'
git push origin master

echo 'PUSHED NEW STATUS!'
