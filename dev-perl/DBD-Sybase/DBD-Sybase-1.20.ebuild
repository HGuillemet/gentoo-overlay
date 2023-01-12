EAPI=7

DIST_AUTHOR=MEWP
DIST_VERSION=1.20
DIST_A_EXT=tgz
inherit perl-module

DESCRIPTION="DBD::Sybase"

SLOT="0"
KEYWORDS="amd64"
IUSE=""

SYBASE=/usr

RDEPEND="dev-db/freetds dev-perl/DBI"
BDEPEND="${RDEPEND}"


src_prepare() {
    export SYBASE="${EPREFIX}/usr"
    perl-module_src_prepare
}

