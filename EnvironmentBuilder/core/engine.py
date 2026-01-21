from core.registry import VulnRegistry
from core.validator import Validator
from core.renderer import Renderer
from core.combiner import combine

class VulnEngine:
    def __init__(self):
        self.registry = VulnRegistry()
        self.registry.load()
        self.validator = Validator()
        self.renderer = Renderer()

    def generate(self, selected_ids, user_params):
        # Load selected vulnerabilities
        selected = [self.registry.get(vid) for vid in selected_ids]

        # Validate inputs
        self.validator.validate(selected, user_params)

        rendered_blocks = []

        for vuln in selected:
            vid = vuln["meta"]["id"]
            vpath = vuln["path"]
            params = user_params[vid]

            # Render setup template
            setup_template = vpath / "setup_bash.j2"
            if setup_template.exists():
                code = self.renderer.render(setup_template, params)
                rendered_blocks.append({
                    "vuln_id": vid,
                    "kind": "setup",
                    "code": code
                })

            # Render exploit template
            exploit_template = vpath / "exploit_bash.j2"
            if exploit_template.exists():
                code = self.renderer.render(exploit_template, params)
                rendered_blocks.append({
                    "vuln_id": vid,
                    "kind": "exploit",
                    "code": code
                })

        # Combine into final outputs
        return combine(rendered_blocks)
