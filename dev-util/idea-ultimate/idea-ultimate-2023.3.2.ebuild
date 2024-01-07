EAPI=7
inherit wrapper desktop

SLOT="0"
MY_PN="idea"
MY_PV="233.13135.103"

KEYWORDS="amd64"
SRC_URI="https://download.jetbrains.com/idea/${MY_PN}IU-${PV}.tar.gz"

DESCRIPTION="A complete toolset for web, mobile and enterprise development"
HOMEPAGE="https://www.jetbrains.com/idea"

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 CC-BY-2.5 CDDL-1.1
	codehaus-classworlds CPL-1.0 EPL-1.0 EPL-2.0
	GPL-2 GPL-2-with-classpath-exception ISC
	JDOM LGPL-2.1 LGPL-2.1+ LGPL-3-with-linking-exception MIT
	MPL-1.0 MPL-1.1 OFL ZLIB"

RDEPEND="${DEPEND}
	dev-libs/libdbusmenu
	media-libs/harfbuzz"
BDEPEND="dev-util/patchelf"
RESTRICT="splitdebug"
S="${WORKDIR}/idea-IU-${MY_PV}"

QA_PREBUILT="opt/${PN}-${PV}/*"

src_unpack() {
	unpack ${MY_PN}IU-${PV}.tar.gz
}

src_prepare() {

	default_src_prepare
	PLUGIN_DIR="${S}/jbr/lib/"
	for file in "${PLUGIN_DIR}"/{libfxplugins.so,libjfxmedia.so,libjcef.so,jcef_helper}
	do
		if [[ -f "$file" ]]; then
		  patchelf --set-rpath '$ORIGIN' $file || die
		fi
	done

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
	local dir="/opt/${PN}-${PV}"

	insinto "${dir}"
	doins -r *

	fperms 755 "${dir}"/bin/{format.sh,idea.sh,inspect.sh,ltedit.sh,remote-dev-server.sh,repair,restarter,fsnotifier}
	JRE_DIR=jbr

	JRE_BINARIES="jcmd jhsdb jmap jstack serialver java jdb jinfo jps jstat javac javadoc jfr jrunscript keytool rmiregistry"
	if [[ -d ${JRE_DIR} ]]; then
		for jrebin in $JRE_BINARIES; do
			fperms 755 "${dir}"/"${JRE_DIR}"/bin/"${jrebin}"
		done
	fi
	fperms 755 "${dir}"/jbr/lib/jcef_helper
	fperms 755 "${dir}"/jbr/lib/jspawnhelper
	fperms 755 "${dir}"/jbr/lib/jexec
	fperms 755 "${dir}"/jbr/lib/chrome-sandbox
	fperms 755 "${dir}"/plugins/maven/lib/maven3/bin
	# fperms avec * ne marche plus
	chmod 0755 "${ED}${dir}"/plugins/maven/lib/maven3/bin/mvn* || die
	fperms 755 "${dir}"/plugins/Kotlin/kotlinc/bin/kotlin
	fperms 755 "${dir}"/plugins/Kotlin/kotlinc/bin/kotlin-dce-js
	fperms 755 "${dir}"/plugins/Kotlin/kotlinc/bin/kotlinc
	fperms 755 "${dir}"/plugins/Kotlin/kotlinc/bin/kotlinc-js
	fperms 755 "${dir}"/plugins/Kotlin/kotlinc/bin/kotlinc-jvm

	make_wrapper "${PN}" "${dir}/bin/${MY_PN}.sh"
	newicon "bin/${MY_PN}.png" "${PN}.png"
	make_desktop_entry "${PN}" "IntelliJ Idea Ultimate" "${PN}" "Development;IDE;"

#	 recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	mkdir -p "${D}/etc/sysctl.d/" || die
	echo "fs.inotify.max_user_watches = 524288" > "${D}/etc/sysctl.d/30-idea-inotify-watches.conf" || die

	# remove bundled harfbuzz
	rm -f "${D}"/lib/libharfbuzz.so || die
}
