EAPI=5

MODULE_AUTHOR=PLICEASE
MODULE_VERSION=1.04
inherit perl-module

DESCRIPTION="Exception Class DBI"

SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="dev-perl/DBI dev-perl/Exception-Class"
DEPEND="${RDEPEND} dev-perl/Module-Build"

