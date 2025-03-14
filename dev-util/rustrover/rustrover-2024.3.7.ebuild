# Copyright 2024 Gianni Bombelli <bombo82@giannibombelli.it>
# Distributed under the terms of the GNU General Public License as published by the Free Software Foundation;
# either version 2 of the License, or (at your option) any later version.

EAPI=8

inherit desktop wrapper

DESCRIPTION="A brand new JetBrains IDE for Rust Developers"
HOMEPAGE="https://www.jetbrains.com/rust/"
SLOT="0"
VER="$(ver_cut 1-3)"
#BUILD_NUMBER="$(ver_cut 4-6)"
BUILD_NUMBER="243.26053.17"
KEYWORDS="amd64"
RESTRICT="bindist mirror splitdebug"
QA_PREBUILT="opt/${P}/*"
RDEPEND="
	dev-libs/libdbusmenu
	llvm-core/lldb
	media-libs/mesa[X(+)]
	sys-devel/gcc
	sys-libs/glibc
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
"
#	sys-libs/libselinux

SIMPLE_NAME="RustRover"
MY_PN="${PN}"
SRC_URI_PATH="rustrover"
SRC_URI_PN="${SIMPLE_NAME}"
SRC_URI="https://download-cdn.jetbrains.com/${SRC_URI_PATH=}/${SRC_URI_PN}-${VER}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${SIMPLE_NAME}-${VER}"

src_prepare() {
	default

	rm -rv ./lib/async-profiler/aarch64 || die
	rm -rv ./plugins/gateway-plugin/lib/remote-dev-workers/remote-dev-worker-darwin* || die
	rm -rv ./plugins/gateway-plugin/lib/remote-dev-workers/remote-dev-worker-windows* || die
	rm -rv ./plugins/gateway-plugin/lib/remote-dev-workers/remote-dev-worker-linux-arm64 || die
	rm -rf ./plugins/platform-ijent-impl/ijent-aarch64-unknown-linux-musl-release || die
}

src_install() {
	local dir="/opt/${P}"

	insinto "${dir}"
	doins -r *
	# Faire find . -type f -perm 755 dans archive source pour obtenir la liste:
	fperms 755 "${dir}"/bin/{"${MY_PN}",format,inspect,jetbrains_client,ltedit,remote-dev-server}.sh
	fperms 755 "${dir}"/bin/native-helper/intellij-rust-native-helper
	fperms 755 "${dir}"/bin/{"${MY_PN}",remote-dev-server,fsnotifier,restarter}
	fperms 755 "${dir}"/bin/gdb/linux/x64/bin/{gcore,gdb,gdb-add-index,gdbserver}
	fperms 755 "${dir}"/bin/lldb/linux/x64/bin/{lldb,lldb-argdumper,LLDBFrontend,lldb-server,lldb-dap}

	fperms 755 "${dir}"/jbr/bin/{java,javac,javadoc,jcmd,jdb,jfr,jhsdb,jinfo,jmap,jps,jrunscript,jstack,jstat,jwebserver,keytool,rmiregistry,serialver}
	fperms 755 "${dir}"/jbr/lib/{chrome-sandbox,jcef_helper,jexec,jspawnhelper}

	fperms 755 "${dir}"/plugins/gateway-plugin/lib/remote-dev-workers/remote-dev-worker-linux-amd64
	fperms 755 "${dir}"/plugins/remote-dev-server/{bin/launcher.sh,selfcontained/bin/xkbcomp,selfcontained/bin/Xvfb}
	fperms 755 "${dir}"/plugins/javascript-plugin/helpers/package-version-range-matcher/node_modules/semver/bin/semver.js
	fperms 755 "${dir}"/plugins/platform-ijent-impl
	fperms 755 "${dir}"/plugins/platform-ijent-impl/ijent-x86_64-unknown-linux-musl-release
	fperms 755 "${dir}"/plugins/tailwindcss/server/tailwindcss-language-server

	make_wrapper "${PN}" "${dir}"/bin/"${MY_PN}"
	newicon bin/"${MY_PN}".svg "${PN}".svg
	make_desktop_entry "${PN}" "${SIMPLE_NAME} ${VER}" "${PN}" "Development;IDE;"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	dodir /usr/lib/sysctl.d/
	echo "fs.inotify.max_user_watches = 524288" > "${D}/usr/lib/sysctl.d/30-${PN}-inotify-watches.conf" || die
}

