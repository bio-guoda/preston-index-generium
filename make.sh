#!/bin/bash
#
#
set -xe
# build corpus
function track_corpus {
  curl --silent -L "https://archive.org/download/IndexGenerium/IndexGenerium_files.xml"\
  | grep -oP '[a-z/]*_data.tar.gz'\
  | sed 's+^+https://archive.org/download/IndexGenerium/+g'\
  | xargs preston track
}

function align_names {
 preston ls\
  | grep hash\
  | preston grep -l tsv ".*"\
  | grep "#value"\
  | cut -f1,3-\
  | sed 's/./\u&/'\
  | sed 's/^/\t/g'\
  | nomer append --include-header itis\
  | mlr --itsvlite --ocsv cat\
  | gzip\
  > pubs-with-taxonnames.csv.gz
}

track_corpus
align_names


