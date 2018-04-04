#!/bin/bash

while read catname
do
	cp Linux.html $catname.html
	sed -i "s/Linux/${catname}/g"  ${catname}.html
done


