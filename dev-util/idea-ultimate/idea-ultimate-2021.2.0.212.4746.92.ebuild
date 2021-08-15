# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils desktop

SLOT="0"
PV_STRING="$(ver_cut 4-6)"
MY_PV="$(ver_cut 1-2)"
MY_PN="idea"

# distinguish settings for official stable releases and EAP-version releases
if [[ "$(ver_cut 8)"x = "prex" ]]
then
	# upstream EAP
	KEYWORDS="~arm64"
	SRC_URI="https://download.jetbrains.com/idea/${MY_PN}IU-${PV_STRING}.tar.gz"
else
	# upstream stable
	KEYWORDS="amd64"
	SRC_URI="https://download.jetbrains.com/idea/${MY_PN}IU-${MY_PV}.tar.gz -> ${MY_PN}IU-${PV_STRING}.tar.gz"
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
	dev-libs/libdbusmenu
	media-libs/harfbuzz"
# on teste sans
# =dev-util/lldb-10*"
BDEPEND="dev-util/patchelf"
RESTRICT="splitdebug"
S="${WORKDIR}/${MY_PN}-IU-${PV_STRING}"

QA_PREBUILT="opt/${PN}-${MY_PV}/*"

src_unpack() {
	unpack ${MY_PN}IU-${PV_STRING}.tar.gz
}

src_prepare() {

	default_src_prepare
	PLUGIN_DIR="${S}/jbr/lib/"
#
#	rm -vf ${PLUGIN_DIR}/libavplugin*
#	rm -vf "${S}"/plugins/maven/lib/maven3/lib/jansi-native/*/libjansi*
#	rm -vrf "${S}"/lib/pty4j-native/linux/ppc64le
#	rm -vf "${S}"/bin/libdbm64*
#
	for file in "${PLUGIN_DIR}"/{libfxplugins.so,libjfxmedia.so,libjcef.so,jcef_helper}
	do
		if [[ -f "$file" ]]; then
		  patchelf --set-rpath '$ORIGIN' $file || die
		fi
	done

#	patchelf --replace-needed liblldb.so liblldb.so.10 "${S}"/plugins/Kotlin/bin/linux/LLDBFrontend || die "Unable to patch LLDBFrontend for lldb"
#	rm -vf "${S}"/lib/pty4j-native/linux/aarch64/libpty.so

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
	fperms 755 "${dir}"/bin/{format.sh,idea.sh,inspect.sh,printenv.py,restart.py,fsnotifier,jbr/lib/jcef_helper}
	JRE_DIR=jbr

	JRE_BINARIES="jaotc jcmd jhsdb jmap jstack pack200 serialver java jdb jinfo jps jstat rmid unpack200 javac jfr jjs jrunscript keytool rmiregistry"
	if [[ -d ${JRE_DIR} ]]; then
		for jrebin in $JRE_BINARIES; do
			fperms 755 "${dir}"/"${JRE_DIR}"/bin/"${jrebin}"
		done
	fi

	make_wrapper "${PN}" "${dir}/bin/${MY_PN}.sh"
	newicon "bin/${MY_PN}.png" "${PN}.png"
	make_desktop_entry "${PN}" "IntelliJ Idea Ultimate" "${PN}" "Development;IDE;"

#	 recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	mkdir -p "${D}/etc/sysctl.d/" || die
	echo "fs.inotify.max_user_watches = 524288" > "${D}/etc/sysctl.d/30-idea-inotify-watches.conf" || die

	# remove bundled harfbuzz
	rm -f "${D}"/lib/libharfbuzz.so || die
}
