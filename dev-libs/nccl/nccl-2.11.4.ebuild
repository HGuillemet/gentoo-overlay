EAPI=8

DESCRIPTION="NVIDIA Collective Communications Library"
HOMEPAGE="https://developer.nvidia.com/nccl"
SRC_URI="
	cuda10-2? ( nccl_${PV}-1+cuda10.2_x86_64.txz )
	cuda11-4? ( nccl_${PV}-1+cuda11.4_x86_64.txz )"
S="${WORKDIR}"

SLOT="0/8"
KEYWORDS="amd64 amd64-linux"
IUSE="cuda10-2 +cuda11-4"
REQUIRED_USE="^^ ( cuda10-2 cuda11-4 )"
RESTRICT="fetch"

RDEPEND="
	cuda10-2? ( =dev-util/nvidia-cuda-toolkit-10.2* )
	cuda11-4? ( =dev-util/nvidia-cuda-toolkit-11.4* )"

QA_PREBUILT="*"

src_install() {
	insinto /opt/cuda/targets/x86_64-linux
	# TODO: change for 10-2
	doins -r nccl_2.11.4-1+cuda11.4_x86_64/include

	insinto /opt/cuda/targets/x86_64-linux/lib
	doins -r nccl_2.11.4-1+cuda11.4_x86_64/lib/.
}
