# Removes the database of the go-ethereum execution client to ensure we start from a clean state.
# (geth has a `removedb` option, but it asks for a keyboard confirmation, so we use this instead)
rm -Rf ./execution/geth