from jinja2 import Environment, FileSystemLoader

class Renderer:
    def __init__(self, templates_root="vulns"):
        # All templates live under the vulns/ directory
        self.env = Environment(loader=FileSystemLoader(templates_root))

    def render(self, template_path, params):
        """
        template_path: Path object pointing to a file under vulns/
        """
        # Convert to path relative to vulns/
        rel_path = template_path.relative_to("vulns").as_posix()

        template = self.env.get_template(rel_path)
        return template.render(**params)
