GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

oops() {
  >&2 echo -e "${RED}error:${NC} $1"
  exit 1
}

#[[ "$(id -u)" -eq 0 ]] && oops "Please run this script as a regular user"

API_OUTPUT=$(curl -sS https://api.github.com/repos/dapphub/dapptools/releases/latest)
RELEASE=$(echo "$API_OUTPUT" | jq -r .tarball_url)

[[ $RELEASE == null ]] && oops "No release found in ${API_OUTPUT}"

cachix use dapp
nix-env -iA dapp hevm seth solc -f "$RELEASE"

echo -e "${GREEN}All set!${NC}"
