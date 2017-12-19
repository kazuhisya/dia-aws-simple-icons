#!/usr/bin/env bash 

# Set Version
ICONS_VERSION="17.1.19"
BASE_DIRNAME="AWS_Simple_Icons_EPS-SVG_v${ICONS_VERSION}"

echo "----------------------------------------------------------------------"

echo "Get Original File"

if [ -e ${BASE_DIRNAME}.zip ]; then
    ls -la ./${BASE_DIRNAME}.zip
else
   curl -OL https://media.amazonwebservices.com/AWS-Design/Arch-Center/${ICONS_VERSION}_Update/${BASE_DIRNAME}.zip
fi

unzip ${BASE_DIRNAME}

echo "----------------------------------------------------------------------"

(
cd ${BASE_DIRNAME}
IFS=$'\n';
# delete space
echo "delete space: dir"
for file in *" "*/ ; do
    mv "$file" "${file// /_}";
done

# delete "&"
echo "delete \"&\": dir"
for file in *'&'*/ ; do
    mv "$file" "${file//\&/and}";
done
)

echo "----------------------------------------------------------------------"
 
# Clean Up FileName
cd ${BASE_DIRNAME}
echo "Clean Up FileName"
for dir in */ ; do
  for file in "$dir"/* ; do
    if [[ "$file" =~ "$dir" ]]; then
      echo "[OK] $file to AWS_Simple_Icons_${file}"
      mv "$file" "${dir}/AWS_Simple_Icons_${file##*/}"
    else
      echo "[Move] $file to AWS_Simple_Icons_${dir%/}_${file##*/}"
      mv "$file" "${dir}/AWS_Simple_Icons_${dir%/}_${file##*/}"
    fi
  done
done

cd ..
mkdir -p ./svg_org ./svg
cp ./${BASE_DIRNAME}/*/*.svg ./svg_org/

echo "----------------------------------------------------------------------"

echo "check xml"
for file in svg_org/* ; do
  if grep -qe 'nyt_x5F_exporter_x5F_info' ${file}; then
    ruby convert.rb ${file} > ${file/svg_org/svg}
    echo "OK: ${file}"
  else
    echo "NG, Repair: ${file}"
    cp ${file} ${file/svg_org/svg}
  fi
done

echo "----------------------------------------------------------------------"

make -j4

echo "----------------------------------------------------------------------"

echo "Finish!"
echo "Copy .output in your env"
echo "ex:"
echo "    $ cat ./.outputs/shapes.sheet  > ~/.dia/sheets/AWS.sheet"
echo "    $ cp -rf ./.outputs/shapes/* ~/.dia/shapes/"

