EAPI=5

MODULE_AUTHOR=PMQS
MODULE_VERSION=0.039
inherit perl-module

DESCRIPTION="Create ZIP Archives"

SLOT="0"
KEYWORDS="amd64"
IUSE=""

# This version requires IO::Compress::Zip 2.096 released in 5.34
RDEPEND=">=dev-lang/perl-5.34"
DEPEND="${RDEPEND}"

