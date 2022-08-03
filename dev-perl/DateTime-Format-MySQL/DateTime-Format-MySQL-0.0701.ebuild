EAPI=7

DIST_AUTHOR=XMIKEW
DIST_VERSION=0.0701
inherit perl-module

DESCRIPTION="DateTime::Format::MySQL"

SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="dev-perl/DateTime dev-perl/DateTime-Format-Builder"
BDEPEND="${RDEPEND} dev-perl/Module-Build"

