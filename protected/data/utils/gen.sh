#!/bin/sh
cd $(dirname $0)
ROOT="$(dirname $(pwd))"
cd -
DEFINE_DIR="${ROOT}/define"
PHP_CODE_DIR="${ROOT}/php"
THRIFT_TMP="${ROOT}/define/.thrift.tmp"

echo "generate thrift file"
for file in `find ${DEFINE_DIR} -name "*.thrift"` 
do
	echo include \"$file\" >> ${THRIFT_TMP}
done
echo "done"

echo cleanup php code dir
if [ ! -d "$PHP_CODE_DIR" ];then
	mkdir ${PHP_CODE_DIR}
else
    rm -rf ${PHP_CODE_DIR}/*
fi
echo done

echo "start generate php code to ${PHP_CODE_DIR}...."
thrift -r --gen php -out ${PHP_CODE_DIR} ${THRIFT_TMP}
echo "done"

rm ${THRIFT_TMP}
