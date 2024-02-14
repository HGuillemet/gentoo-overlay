EAPI=8

DESCRIPTION="NVIDIA Collective Communications Library"
HOMEPAGE="https://developer.nvidia.com/nccl"
SRC_URI="
	cuda11-0? ( nccl_${PV}-1+cuda11.0_x86_64.txz )
	cuda12-2? ( nccl_${PV}-1+cuda12.2_x86_64.txz )
	cuda12-3? ( nccl_${PV}-1+cuda12.3_x86_64.txz )"
S="${WORKDIR}"

SLOT="0/8"
KEYWORDS="amd64 amd64-linux"
IUSE="cuda11-0 cuda12-2 +cuda12-3"
REQUIRED_USE="^^ ( cuda11-0 cuda12-2 cuda12-3 )"
RESTRICT="fetch"

RDEPEND="
	cuda11-0? ( =dev-util/nvidia-cuda-toolkit-11* )
	cuda12-2? ( =dev-util/nvidia-cuda-toolkit-12.2* )
	cuda12-3? ( =dev-util/nvidia-cuda-toolkit-12.3* )"

QA_PREBUILT="*"

src_install() {
	if use "cuda11-0"; then 
	  DIR="nccl_${PV}-1+cuda11.0_x86_64"
	fi
	if use "cuda12-2"; then 
	  DIR="nccl_${PV}-1+cuda12.2_x86_64"
	fi
	if use "cuda12-3"; then 
	  DIR="nccl_${PV}-1+cuda12.3_x86_64"
	fi

	insinto /opt/cuda/targets/x86_64-linux
	doins -r ${DIR}/include

	insinto /opt/cuda/targets/x86_64-linux/lib
	doins -r ${DIR}/lib/.
}
