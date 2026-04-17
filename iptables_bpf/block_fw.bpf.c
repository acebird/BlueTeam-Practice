//block_fw.bpf.c

#include "vmlinux.h"
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_tracing.h>

char LICENSE[]SEC("license") = "GPL";

#define NETLINK_NETFILTER 12
#define NFNL_MSG_BATCH_BEGIN 16

SEC("lsm/netlink_send")
int BPF_PROG(restrict_nft, struct sock *sk, struct sk_buff *skb)
{
	if (sk->sk_protocol != NETLINK_NETFILTER) {
		return 0;
	}

	struct nlmsghdr *nlh = (struct nlmsghdr *)skb->data;

	uint16_t type;
	int err = bpf_probe_read_kernel(&type, sizeof(type), &nlh->nlmsg_type);

	if (err) {
		return 0;
	}

	if (type == NFNL_MSG_BATCH_BEGIN) {
		bpf_printk("LSM: Blocked batched firewall modification!\n");
		return -1;
	}


	uint8_t subsys_id = type >> 8;
	uint8_t msg_type = type & 0xFF;

	if (subsys_id == 10) {
		if (msg_type ==0 || msg_type == 2 || msg_type == 3 || msg_type == 5 || msg_type == 6 || msg_type == 8) {
			bpf_printk("LSM: Blocked unbatched modification)\n");
			return -1;
		}
	}

	return 0;
}
