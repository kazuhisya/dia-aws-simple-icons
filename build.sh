#!/usr/bin/env bash

echo "----------------------------------------------------------------------"

curl -OL http://media.amazonwebservices.com/architecturecenter/icons/AWS_Simple_Icons_svg_eps.zip
unzip AWS_Simple_Icons_svg_eps.zip

echo "----------------------------------------------------------------------"

(
cd AWS_Simple_Icons_svg_eps
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

echo "----------------------------------------------------------------------"

# delete space
echo "delete space: file"
for file in `find ./* -type f` ; do
    if [ $(echo $file | grep -e ' ') ]; then
        mv "$file" `echo $file | tr ' ' '_'`;
    fi
done

# delete "&"
echo "delete \"&\": file"
for file in `find ./* -type f` ; do
    if [ $(echo $file | grep -e '&') ]; then
        mv "$file" "${file/\&/and}";
    fi
done

# delete "_copy"
echo "delete \"_copy\": file"

for file in `find ./* -type f` ; do
    if [ $(echo $file | grep -e 'copy') ]; then
        mv $file "${file/copy_/}"
    fi
done
)

echo "----------------------------------------------------------------------"

# Clean Up FileName
cd AWS_Simple_Icons_svg_eps
echo "Clean Up FileName"
for dirname in `find ./ -maxdepth 1 -type d ! -name "." |gawk -F/ '{print $NF}'` ; do
    for filename in `ls ./$dirname/SVG/` ; do
        if [ $(echo $filename | grep -e "$dirname") ]; then
            echo "[OK] $filename to AWS_Simple_Icons_${filename}"
            mv ./$dirname/SVG/$filename ./$dirname/SVG/AWS_Simple_Icons_${filename}
        else
            echo "[Move] $filename to AWS_Simple_Icons_${dirname}_${filename}"
            mv ./$dirname/SVG/$filename ./$dirname/SVG/AWS_Simple_Icons_${dirname}_${filename}
        fi
    done
done


cd ..
mkdir -p ./svg_org ./svg
cp ./AWS_Simple_Icons_svg_eps/*/SVG/*.svg ./svg_org

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
