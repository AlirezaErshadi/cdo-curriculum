error_check() {
  if [ $? -gt 0 ] ; then
    if [[ -z "$1" ]] ; then
      echo "Failure: $1"
    fi
    exit 1
  fi
}
