# AWS Simple Icons for dia

[![Circle CI](https://circleci.com/gh/kazuhisya/dia-aws-simple-icons/tree/master.svg?style=shield)](https://circleci.com/gh/kazuhisya/dia-aws-simple-icons/tree/master)


This provides Dia AWS Simple Icons shapes.

## System Requirements

- dia
- ImageMagick (`convert` command)
- ruby (`rexml/document`, it is included in the standard Ruby distribution.)

## Usage


```bash
$ git clone https://github.com/kazuhisya/dia-aws-simple-icons.git
$ cd dia-aws-simple-icons
$ ./build.sh
~~ snip ~~
$ cat ./.outputs/shapes.sheet  > ~/.dia/sheets/AWS.sheet
$ cp ./.outputs/shapes/* ~/.dia/shapes/
```

## Licence

- AWS Simple Icons
    - Not specified
    - See Also: https://aws.amazon.com/jp/blogs/aws/introducing-aws-simple-icons-for-your-architecture-diagrams/

- Makefile
    - Please observe the following
    - From: https://github.com/cipriancraciun/mosaic-blueprints/blob/master/dia-shapes/aws/makefile
