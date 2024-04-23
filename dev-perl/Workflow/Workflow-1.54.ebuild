EAPI=7

DIST_AUTHOR=JONASBN
DIST_VERSION=1.54
inherit perl-module

DESCRIPTION="Workflow"

SLOT="0"
KEYWORDS="amd64 arm64"
IUSE=""

RDEPEND="dev-perl/Log-Log4perl dev-perl/Class-Accessor dev-perl/Class-Observable dev-perl/Class-Factory"
BDEPEND="${RDEPEND} dev-perl/Module-Build"
