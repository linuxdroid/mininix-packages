MININIX_PKG_HOMEPAGE=https://matt.ucc.asn.au/dropbear/dropbear.html
MININIX_PKG_DESCRIPTION="Small SSH server and client"
MININIX_PKG_VERSION=2018.76
MININIX_PKG_REVISION=5
MININIX_PKG_SRCURL=https://matt.ucc.asn.au/dropbear/releases/dropbear-${MININIX_PKG_VERSION}.tar.bz2
MININIX_PKG_SHA256=f2fb9167eca8cf93456a5fc1d4faf709902a3ab70dd44e352f3acbc3ffdaea65
MININIX_PKG_DEPENDS="libutil,mininix-auth"
MININIX_PKG_CONFLICTS="openssh"
MININIX_PKG_BUILD_IN_SRC="yes"

MININIX_PKG_EXTRA_CONFIGURE_ARGS="--disable-syslog --disable-utmp --disable-utmpx --disable-wtmp"
# Avoid linking to libcrypt for server password authentication:
MININIX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_lib_crypt_crypt=no"
# build a multi-call binary & enable progress info in 'scp'
MININIX_PKG_EXTRA_MAKE_ARGS="MULTI=1 SCPPROGRESS=1"

mininix_step_pre_configure() {
    export LIBS="-lmininix-auth"
}

mininix_step_post_make_install() {
    ln -sf "dropbearmulti" "${MININIX_PREFIX}/bin/ssh"
}

mininix_step_create_debscripts () {
    {
        echo "#!$MININIX_PREFIX/bin/sh"
        echo "mkdir -p $MININIX_PREFIX/etc/dropbear"
        echo "for a in rsa dss ecdsa; do"
        echo "    KEYFILE=$MININIX_PREFIX/etc/dropbear/dropbear_\${a}_host_key"
        echo "    test ! -f \$KEYFILE && dropbearkey -t \$a -f \$KEYFILE"
        echo "done"
        echo "exit 0"
    } > postinst
    chmod 0755 postinst
}
