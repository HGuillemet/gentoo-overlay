EAPI=5

MODULE_AUTHOR=MJEVANS
MODULE_VERSION=1.80
inherit perl-module

DESCRIPTION="DBD::Oracle"

SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="dev-perl/DBI"
DEPEND="${RDEPEND}"

src_configure() {
    myconf="-l"
    perl-module_src_configure
}

