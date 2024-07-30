EAPI=7

DIST_AUTHOR=CPANLNCSA
DIST_VERSION=4.04
inherit perl-module

DESCRIPTION="An interface for the Sirene API of INSEE"

SLOT="0"
KEYWORDS="amd64 arm64"
IUSE=""

RDEPEND="dev-perl/JSON dev-perl/Switch"
RDEPEND="dev-perl/JSON
	dev-perl/Switch
	dev-perl/HTTP-Message
	dev-perl/libwww-perl"
BDEPEND="${RDEPEND}"

PATCHES=(
  "${FILESDIR}/v3.11.patch"
)
