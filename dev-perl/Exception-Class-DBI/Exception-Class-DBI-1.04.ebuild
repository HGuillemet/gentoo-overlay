EAPI=7

DIST_AUTHOR=PLICEASE
DIST_VERSION=1.04
inherit perl-module

DESCRIPTION="Exception Class DBI"

SLOT="0"
KEYWORDS="amd64 arm64"
IUSE=""

RDEPEND="dev-perl/DBI dev-perl/Exception-Class"
BDEPEND="${RDEPEND} dev-perl/Module-Build"

