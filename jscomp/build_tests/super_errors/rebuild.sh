# Execute this file to rebuild the snapshots manually, e.g. while developing

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export PATH=$DIR/../../../lib:$PATH
node $DIR/index.js rebuild
