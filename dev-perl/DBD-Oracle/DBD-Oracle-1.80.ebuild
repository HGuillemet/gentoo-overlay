EAPI=7

DIST_AUTHOR=MJEVANS
DIST_VERSION=1.80
inherit perl-module

DESCRIPTION="DBD::Oracle"

SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="dev-perl/DBI"
BDEPEND="${RDEPEND}"

src_configure() {
    myconf="-l"
    perl-module_src_configure
}

