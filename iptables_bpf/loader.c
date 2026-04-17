//loader.c

#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <bpf/libbpf.h>

static volatile int running = 1;

//Handle Ctrl + C
void handle_signal(int sig) {
	running = 0;
}

int main() {
	struct bpf_object *obj;
	struct bpf_program *prog;
	struct bpf_link *link = NULL;
	int err;

	//Required for older libbpf version
	struct bpf_object_open_opts opts = {
		.sz = sizeof(struct bpf_object_open_opts),
	};

	//Open BPF object file
	obj = bpf_object__open_file("block_fw.bpf.o", &opts);
	if (!obj) {
		printf("Failed to open BPF object\n");
		return 1;
	}

	//Load into Kernel
	err = bpf_object__load(obj);
	if (err) {
		printf("Failed to load BPF program: %d\n", err);
		bpf_object__close(obj);
		return 1;
	}

	// Find the porgram
	prog = bpf_object__find_program_by_name(obj, "restrict_nft");
	if (!prog) {
		printf("Failed to find program in object file\n");
		bpf_object__close(obj);
		return 1;
	}

	//Attach program to LSM hook
	link = bpf_program__attach(prog);
	if (libbpf_get_error(link)) {
		printf("Failed to attach BPF program\n");
		bpf_object__close(obj);
		return 1;
	}

	printf("[+] Firewall protection ACTIVE (LSM loaded)\n");
	printf("[+] Try: sudo iptables -F (should fail)\n");
	printf("[+] Press Ctrl + C to exit\n");

	signal(SIGINT, handle_signal);

	//Keep program alive
	while (running) {
		sleep(1);
	}

	printf("[+] Exiting...\n");

	//Clean Up
	bpf_link__destroy(link);
	bpf_object__close(obj);
	return 0;
}
