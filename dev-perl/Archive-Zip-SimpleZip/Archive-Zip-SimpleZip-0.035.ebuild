EAPI=7

DIST_AUTHOR=PMQS
DIST_VERSION=0.035
inherit perl-module

DESCRIPTION="Create ZIP Archives"

SLOT="0"
KEYWORDS="amd64 arm64"
IUSE=""

# This version requires IO::Compress::Zip 2.093 released in 5.32
RDEPEND=">=dev-lang/perl-5.32"
BDEPEND="${RDEPEND}"

