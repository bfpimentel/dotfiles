if [[ "$OSTYPE" == "darwin"* ]]; then
  ./macos.sh
  exit 0
fi

./linux.sh
exit 0
