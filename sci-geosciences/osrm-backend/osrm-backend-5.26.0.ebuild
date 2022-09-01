EAPI="8"

inherit cmake

DESCRIPTION="Open Source Routing Machine: The OpenStreetMap Data Routing Engine"
HOMEPAGE="http://project-osrm.org"
SRC_URI="https://github.com/Project-OSRM/osrm-backend/archive/v5.26.0.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="x86 amd64"

IUSE=""

# tbb 2021.5 removes task_scheduler_init sought for in FindTBB.cmake
DEPEND="
dev-libs/stxxl
<dev-cpp/tbb-2021.5.0
>=dev-lang/lua-5.2
dev-libs/boost
"

RDEPEND="dev-cpp/tbb"

CMAKE_BUILD_TYPE=Release

src_install() {
    cmake-utils_src_install
	docompress -x /usr/share/doc/${PF}/profiles
	dodoc -r profiles
}


