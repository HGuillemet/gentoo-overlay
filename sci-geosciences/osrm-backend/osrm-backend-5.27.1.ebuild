EAPI="8"

inherit cmake

DESCRIPTION="Open Source Routing Machine: The OpenStreetMap Data Routing Engine"
HOMEPAGE="http://project-osrm.org"
SRC_URI="https://github.com/Project-OSRM/osrm-backend/archive/v5.27.1.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="x86 amd64"

IUSE=""

# tbb 2021.5 removes task_scheduler_init sought for in FindTBB.cmake
#dev-libs/stxxl
DEPEND="
dev-cpp/tbb
>=dev-lang/lua-5.2
>=dev-libs/boost-1.70
"

RDEPEND="dev-cpp/tbb"

CMAKE_BUILD_TYPE=Release

src_prepare() {
# Change lib install directory from /usr/lib to /usr/lib64
	sed -i 's/{CMAKE_INSTALL_PREFIX}\/lib/{CMAKE_INSTALL_PREFIX}\/lib64/' CMakeLists.txt || die
	sed -i 's/DESTINATION lib)/DESTINATION lib64)/g' CMakeLists.txt || die

	cmake_src_prepare
}

src_install() {
	cmake_src_install
	docompress -x /usr/share/doc/${PF}/profiles
	dodoc -r profiles
}


