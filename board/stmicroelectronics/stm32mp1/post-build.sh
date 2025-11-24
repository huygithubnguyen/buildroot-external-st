add_wifi_fw_symlinks()
{
	if ! grep -q "^BR2_PACKAGE_LINUX_FIRMWARE=y" ${BR2_CONFIG}; then
		return
	fi

	# Check for Murata CYW firmware package
	if ! grep -q "^BR2_PACKAGE_MURATA_CYW_FW=y" ${BR2_CONFIG}; then
		echo "Warning: BR2_PACKAGE_MURATA_CYW_FW not enabled, WiFi firmware symlinks may be incomplete"
	fi

	pushd ${TARGET_DIR}/lib/firmware/brcm
	for board in stm32mp157d-dk1 stm32mp157f-dk2 stm32mp135f-dk; do
		ln -sf brcmfmac43430-sdio.bin brcmfmac43430-sdio.st,${board}-mx.bin
	done
	popd
}

add_wifi_fw_symlinks $@
