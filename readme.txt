The following is a BPF LSM program to intercept change attempts to IPtables.

When running root should be able to view IPtables with "iptables -L", however any modification or flush attempts including setting INPUT and OUTPUT chains to default ACCEPT are blocked.

Generate vmlinux.h with: "bpftool btf dump file /sys/kernel/btf/vmlinux format c > vmlinux.h"

To compile the c code run "clang -O2 -g -target bpf -D__TARGET_ARCH_x86 -I. -c block_fw.bpf.c -o block_fw.bpf.o

To compile the loader run "gcc loader.c -o loader -lbpf

General Notes:
- Ensure the kernal type allows LSM with "grep BPF_LSM /boot/config-$(uname -r)
	Should have output: CONFIG_BPF_LSM=y
- Ensure /sys/kernel/btf/vmlinux exists
- Ensure kernel supports lsm
	Run "cat /sys/kernel/security/lsm" IF bpf is not listed add it:
	edit /etc/default/grub, add "lsm=capability,landlock,yama,apparmor,bpf" after GRUB_CMBLINE_LINUX_DEFAULT
	run "sudo update-grub" and the REBOOT
