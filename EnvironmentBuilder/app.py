from core.engine import VulnEngine

def main():
    engine = VulnEngine()

    # Simulated user selections from GUI
    selected_vulns = ["bad_passwords", "weak_sudo"]

    user_params = {
        "bad_passwords": {
            "usernames": ["alice", "bob"],
            "password": "Summer2024",
            "target_ip": "10.0.0.5"
        },
        "weak_sudo": {
            "usernames": ["alice"]
        }
    }

    outputs = engine.generate(selected_vulns, user_params)

    if "bash_setup" in outputs:
        print("=== BASH SETUP ===")
        print(outputs["bash_setup"])

    if "ansible_setup" in outputs:
        print("\n=== ANSIBLE SETUP ===")
        print(outputs["ansible_setup"])

    if "bash_exploit" in outputs:
        print("\n=== BASH EXPLOIT ===")
        print(outputs["bash_exploit"])

if __name__ == "__main__":
    main()
