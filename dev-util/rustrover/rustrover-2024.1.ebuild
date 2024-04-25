# Copyright 2024 Gianni Bombelli <bombo82@giannibombelli.it>
# Distributed under the terms of the GNU General Public License as published by the Free Software Foundation;
# either version 2 of the License, or (at your option) any later version.

EAPI=8

inherit desktop wrapper

DESCRIPTION="A brand new JetBrains IDE for Rust Developers"
HOMEPAGE="https://www.jetbrains.com/rust/"
SLOT="0"
VER="$(ver_cut 1-2)"
KEYWORDS="amd64"
RESTRICT="bindist mirror splitdebug"
QA_PREBUILT="opt/${P}/*"
RDEPEND="
	dev-libs/libdbusmenu
	dev-debug/lldb
	media-libs/mesa[X(+)]
	sys-devel/gcc
	sys-libs/glibc
	sys-process/audit
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
BUILD_NUMBER="241.15989.101"
SRC_URI="https://download.jetbrains.com/${SRC_URI_PATH}/${SRC_URI_PN}-${BUILD_NUMBER}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${SIMPLE_NAME}-${BUILD_NUMBER}"

src_prepare() {
	default

	rm -rv ./lib/async-profiler/aarch64 || die
	rm -rv ./plugins/intellij-rust/bin/linux/arm64/intellij-rust-native-helper || die
	rm -rf ./plugins/platform-ijent-impl/ijent-aarch64-unknown-linux-musl-release || die
}

src_install() {
	local dir="/opt/${P}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{"${MY_PN}",format,inspect,jetbrains_client,ltedit,remote-dev-server}.sh
	fperms 755 "${dir}"/bin/{fsnotifier,repair,restarter}
	fperms 755 "${dir}"/bin/gdb/linux/x64/bin/{gcore,gdb,gdb-add-index,gdbserver}
	fperms 755 "${dir}"/bin/lldb/linux/x64/bin/{lldb,lldb-argdumper,LLDBFrontend,lldb-server}

	fperms 755 "${dir}"/jbr/bin/{java,javac,javadoc,jcmd,jdb,jfr,jhsdb,jinfo,jmap,jps,jrunscript,jstack,jstat,keytool,rmiregistry,serialver}
	fperms 755 "${dir}"/jbr/lib/{chrome-sandbox,jcef_helper,jexec,jspawnhelper}

	fperms 755 "${dir}"/plugins/gateway-plugin/lib/remote-dev-workers/remote-dev-worker-linux-amd64
	fperms 755 "${dir}"/plugins/intellij-rust/bin/linux/x86-64/intellij-rust-native-helper
	fperms 755 "${dir}"/plugins/remote-dev-server/{bin/launcher.sh,selfcontained/bin/xkbcomp,selfcontained/bin/Xvfb}
	fperms 755 "${dir}"/plugins/tailwindcss/server/tailwindcss-language-server

	make_wrapper "${PN}" "${dir}"/bin/"${MY_PN}".sh
	newicon bin/"${MY_PN}".svg "${PN}".svg
	make_desktop_entry "${PN}" "${SIMPLE_NAME} ${VER}" "${PN}" "Development;IDE;"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	dodir /usr/lib/sysctl.d/
	echo "fs.inotify.max_user_watches = 524288" > "${D}/usr/lib/sysctl.d/30-${PN}-inotify-watches.conf" || die
}

