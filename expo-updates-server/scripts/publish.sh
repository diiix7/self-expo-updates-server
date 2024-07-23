while getopts d: flag
do
    case "${flag}" in
        d) directory=${OPTARG};;
    esac
done

cd ../app
npx expo export
cd ../expo-updates-server
rm -rf updates/$directory/
cp -r ../app/dist/ updates/$directory

node ./scripts/exportClientExpoConfig.js > updates/$directory/expoConfig.json