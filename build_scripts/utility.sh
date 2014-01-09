error_check() {
  if [ $? -gt 0 ] ; then
    echo "Failure: $1"
    exit 1
  fi
}
