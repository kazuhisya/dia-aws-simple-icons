#!/usr/bin/env bash

# Set Version
ICONS_VERSION="16.2.22"
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
for file in `find ./ -maxdepth 1 -type d` ; do
    if [ $(echo $file | grep -e ' ') ]; then
        mv "$file" `echo $file | tr ' ' '_'`;
    fi
done

# delete "&"
echo "delete \"&\": dir"
for file in `find ./ -maxdepth 1 -type d` ; do
    if [ $(echo $file | grep -e '&') ]; then
        mv "$file" "${file/\&/and}";
    fi
done
)

echo "----------------------------------------------------------------------"

# Clean Up FileName
cd ${BASE_DIRNAME}
echo "Clean Up FileName"
for dirname in `find ./ -maxdepth 1 -type d ! -name "." |gawk -F/ '{print $NF}'` ; do
    for filename in `ls ./$dirname/` ; do
        if [ $(echo $filename | grep -e "$dirname") ]; then
            echo "[OK] $filename to AWS_Simple_Icons_${filename}"
            mv ./$dirname/$filename ./$dirname/AWS_Simple_Icons_${filename}
        else
            echo "[Move] $filename to AWS_Simple_Icons_${dirname}_${filename}"
            mv ./$dirname/$filename ./$dirname/AWS_Simple_Icons_${dirname}_${filename}
        fi
    done
done


cd ..
mkdir -p ./svg_org ./svg
cp ./${BASE_DIRNAME}/*/*.svg ./svg_org

echo "----------------------------------------------------------------------"

echo "check xml"
for file in `ls svg_org` ; do
  if [ "$(cat svg_org/$file |grep -e 'nyt_x5F_exporter_x5F_info' svg_org/${file})" ]; then
    ruby convert.rb svg_org/${file} > svg/${file}
    echo "OK: ${file}"
  else
    echo "NG, Repair: ${file}"
    cat svg_org/${file} > svg/${file}
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

