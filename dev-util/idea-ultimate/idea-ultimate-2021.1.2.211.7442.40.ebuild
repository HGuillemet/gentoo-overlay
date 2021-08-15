# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils desktop

SLOT="0"
PV_STRING="$(ver_cut 4-6)"
MY_PV="$(ver_cut 1-3)"
MY_PN="idea"
# Using the most recent Jetbrains Runtime binaries available at the time of writing. See https://jetbrains.bintray.com/intellij-jbr/
JRE11_BASE="11_0_10"
JRE11_VER="1304.4"

# distinguish settings for official stable releases and EAP-version releases
if [[ "$(ver_cut 8)"x = "prex" ]]
then
	# upstream EAP
	KEYWORDS="~arm64"
	SRC_URI="https://download.jetbrains.com/idea/${MY_PN}IU-${PV_STRING}.tar.gz"
else
	# upstream stable
	KEYWORDS="amd64 ~arm64 ~x86"
	SRC_URI="https://download.jetbrains.com/idea/${MY_PN}IU-${MY_PV}-no-jbr.tar.gz -> ${MY_PN}IU-${PV_STRING}.tar.gz
		amd64? ( https://bintray.com/jetbrains/intellij-jbr/download_file?file_path=jbr-${JRE11_BASE}-linux-x64-b${JRE11_VER}.tar.gz -> jbr-${JRE11_BASE}-linux-x64-b${JRE11_VER}.tar.gz )"
fi

DESCRIPTION="A complete toolset for web, mobile and enterprise development"
HOMEPAGE="https://www.jetbrains.com/idea"

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 CC-BY-2.5 CDDL-1.1
	codehaus-classworlds CPL-1.0 EPL-1.0 EPL-2.0
	GPL-2 GPL-2-with-classpath-exception ISC
	JDOM LGPL-2.1 LGPL-2.1+ LGPL-3-with-linking-exception MIT
	MPL-1.0 MPL-1.1 OFL ZLIB"

DEPEND="!dev-util/${PN}:14
	!dev-util/${PN}:15
	"
#	|| (
#		dev-java/openjdk:11
#		dev-java/openjdk-bin:11
#	)"
RDEPEND="${DEPEND}
	>=virtual/jdk-1.7:*
	dev-java/jansi-native
	dev-libs/libdbusmenu"
# on teste sans
# =dev-util/lldb-10*"
BDEPEND="dev-util/patchelf"
RESTRICT="splitdebug"
S="${WORKDIR}/${MY_PN}-IU-${PV_STRING}"

QA_PREBUILT="opt/${PN}-${MY_PV}/*"

src_unpack() {
	unpack ${MY_PN}IU-${PV_STRING}.tar.gz
	cd ${S} && unpack jbr-${JRE11_BASE}-linux-x64-b${JRE11_VER}.tar.gz
}

src_prepare() {

	PLUGIN_DIR="${S}/jbr/lib/"

	rm -vf ${PLUGIN_DIR}/libavplugin*
	rm -vf "${S}"/plugins/maven/lib/maven3/lib/jansi-native/*/libjansi*
	rm -vrf "${S}"/lib/pty4j-native/linux/ppc64le
	rm -vf "${S}"/bin/libdbm64*

	for file in "${PLUGIN_DIR}"/{libfxplugins.so,libjfxmedia.so,libjcef.so,jcef_helper}
	do
		if [[ -f "$file" ]]; then
		  patchelf --set-rpath '$ORIGIN' $file || die
		fi
	done

	patchelf --replace-needed liblldb.so liblldb.so.10 "${S}"/plugins/Kotlin/bin/linux/LLDBFrontend || die "Unable to patch LLDBFrontend for lldb"
	if use arm64; then
		patchelf --replace-needed libc.so libc.so.6 "${S}"/lib/pty4j-native/linux/aarch64/libpty.so || die "Unable to patch libpty for libc"
	else
		rm -vf "${S}"/lib/pty4j-native/linux/aarch64/libpty.so
	fi

	sed -i \
		-e "\$a\\\\" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$a# Disable automatic updates as these are handled through Gentoo's" \
		-e "\$a# package manager. See bug #704494" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$aide.no.platform.update=Gentoo"  bin/idea.properties

	eapply_user
}

src_install() {
	local dir="/opt/${PN}-${MY_PV}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{format.sh,idea.sh,inspect.sh,printenv.py,restart.py,fsnotifier{,64}}
	JRE_BINARIES="jaotc java javac jdb jfr jhsdb jjs jrunscript keytool pack200 rmid rmiregistry serialver unpack200"
	for jrebin in $JRE_BINARIES; do
		fperms 755 "${dir}/jbr/bin/${jrebin}"
	done

	make_wrapper "${PN}" "${dir}/bin/${MY_PN}.sh"
	newicon "bin/${MY_PN}.png" "${PN}.png"
	make_desktop_entry "${PN}" "IntelliJ Idea Ultimate" "${PN}" "Development;IDE;"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	mkdir -p "${D}/etc/sysctl.d/" || die
	echo "fs.inotify.max_user_watches = 524288" > "${D}/etc/sysctl.d/30-idea-inotify-watches.conf" || die
}
