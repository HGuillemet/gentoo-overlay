EAPI=5

MODULE_AUTHOR=XMIKEW
MODULE_VERSION=0.0701
inherit perl-module

DESCRIPTION="DateTime::Format::MySQL"

SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="dev-perl/DateTime dev-perl/DateTime-Format-Builder"
DEPEND="${RDEPEND} dev-perl/Module-Build"

