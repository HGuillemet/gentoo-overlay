EAPI=5

MODULE_AUTHOR=JONASBN
MODULE_VERSION=1.54
inherit perl-module

DESCRIPTION="Workflow"

SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="dev-perl/Log-Log4perl dev-perl/Class-Accessor dev-perl/Class-Observable dev-perl/Class-Factory"
DEPEND="${RDEPEND} dev-perl/Module-Build"
