# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7
inherit eutils autotools multilib

SOURCES_NAME="linux-UFRIILT-drv-v500-fr"

DESCRIPTION="Canon UFR II LT Printer Driver"
HOMEPAGE="http://tbc"
SRC_URI="http://gdlp01.c-wss.com/gds/3/0100007003/08/${SOURCES_NAME}-18.tar.gz -> ${SOURCES_NAME}.tar.gz"

LICENSE="Canon-UFR-II"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

# Needed because GPL2 stuff miss their sources in tarball
RESTRICT="mirror"

RDEPEND="
	gnome-base/libglade
"
#	net-print/cups
#	~net-print/cndrvcups-common-lb-${PV}
#	x11-libs/gtk+:2
#	amd64? (
#		app-emulation/emul-linux-x86-baselibs
#	)
#	x86? (
#		dev-libs/libxml2
#		virtual/jpeg:62
#	)
#"
#DEPEND="${DEPEND}"

S="${WORKDIR}/${SOURCES_NAME}"
MAKEOPTS+=" -j1"

# Don't raise a fuss over pre-built binaries
#QA_PREBUILT="
#	/usr/bin/cnpkbidi
#	/usr/bin/cnpkmoduleufr2
#	/usr/$(get_abi_LIBDIR x86)/libEnoJPEG.so.1.0.0
#	/usr/$(get_abi_LIBDIR x86)/libEnoJBIG.so.1.0.0
#	/usr/$(get_abi_LIBDIR x86)/libufr2filter.so.1.0.0
#	/usr/$(get_abi_LIBDIR x86)/libcnlbcm.so.1.0
#	/usr/$(get_abi_LIBDIR x86)/libcaiocnpkbidi.so.1.0.0
#	/usr/$(get_abi_LIBDIR x86)/libcanonufr2.so.1.0.0
#"
#QA_SONAME="/usr/$(get_abi_LIBDIR x86)/libcaiocnpkbidi.so.1.0.0"

src_unpack() {
	unpack ${A}
}

src_install() {
  cd $D
  rpm2tgz -O "${WORKDIR}/${SOURCES_NAME}/64-bit_Driver/RPM/cnrdrvcups-ufr2lt-uk-5.00-1.x86_64.rpm" | tar xfz - --strip-components=2
  mkdir -p usr/libexec/cups/filter
#  mv usr/lib64/cups/filter/pstoncapcpca usr/libexec/cups/filter
  mv usr/lib64/cups/filter/rastertosfp usr/libexec/cups/filter
#  mkdir -p usr/lib32/Canon/CUPS_SFP/Libs
#  mkdir -p usr/lib32
#  mv usr/lib/Canon/CUPS_SFP/Libs/libEnoJBIG.so* usr/lib32/Canon/CUPS_SFP/Libs
#  mv usr/lib/Canon/CUPS_SFP/Libs/libEnoJPEG.so* usr/lib32/Canon/CUPS_SFP/Libs
#  mv usr/lib/libColorGear.so* usr/lib32
#  mv usr/lib/libColorGearC.so* usr/lib32
#  mv usr/lib/libc3pl.so* usr/lib32
#  mv usr/lib/libcaepcm.so* usr/lib32
#  mv usr/lib/libcaiousb.so* usr/lib32
#  mv usr/lib/libcaiowrap.so* usr/lib32
#  mv usr/lib/libcanon_slim.so* usr/lib32
#  mv usr/lib/libcanonncap.so* usr/lib32
#  mv usr/lib/libcnncapcm.so* usr/lib32
#  mv usr/lib/libncapfilter.so* usr/lib32
}
