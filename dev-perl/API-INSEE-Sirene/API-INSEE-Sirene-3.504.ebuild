EAPI=7

DIST_AUTHOR=CPANLNCSA
DIST_VERSION=3.504
inherit perl-module

DESCRIPTION="An interface for the Sirene API of INSEE"

SLOT="0"
KEYWORDS="amd64 arm64"
IUSE=""

RDEPEND="dev-perl/JSON"
BDEPEND="${RDEPEND}"

