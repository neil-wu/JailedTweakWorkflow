#/bin/bash

rm -f ../jailedtweak/*.h
rm -f ../jailedtweak/*.xm

cp -f ./*.xm ../jailedtweak/
cp -f ./*.h ../jailedtweak/

echo "copy done"
