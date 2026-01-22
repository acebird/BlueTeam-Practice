from core.registry import VulnRegistry
from core.validator import Validator
from core.renderer import Renderer
from core.combiner import combine

class VulnEngine:
    def __init__(self):
        self.registry = VulnRegistry()
        self.registry.load()
        self.validator = Validator(self.registry)
        self.renderer = Renderer()

    def generate(self, selected_ids, user_params):
        # Validate inputs using IDs only
        self.validator.validate(selected_ids, user_params)

        rendered_blocks = []

        # Now load full vuln objects
        selected = [self.registry.get(vid) for vid in selected_ids]

        for vuln in selected:
            vid = vuln["meta"]["id"]
            vpath = vuln["path"]

            # Get params for this vuln (or empty dict if none)
            params = user_params.get(vid, {})

            # Setup and exploit templates
            for kind, suffix in [("setup", "setup"), ("exploit", "exploit")]:
                # Bash
                bash_tmpl = vpath / f"{suffix}_bash.j2"
                if bash_tmpl.exists():
                    code = self.renderer.render(bash_tmpl, params)
                    rendered_blocks.append({
                        "vuln_id": vid,
                        "kind": kind,
                        "lang": "bash",
                        "code": code
                    })

                # Ansible (setup only)
                ansible_tmpl = vpath / f"{suffix}_ansible.j2"
                if ansible_tmpl.exists():
                    code = self.renderer.render(ansible_tmpl, params)
                    rendered_blocks.append({
                        "vuln_id": vid,
                        "kind": kind,
                        "lang": "ansible",
                        "code": code
                    })

        # Combine into final outputs
        return combine(rendered_blocks)
