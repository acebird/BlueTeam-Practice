class Validator:
    def __init__(self, registry):
        self.registry = registry

    def validate(self, selected_ids, user_params):
        for vuln_id in selected_ids:
            meta = self.registry.get(vuln_id)["meta"]

            # Safely get parameters, default to empty list
            params = meta.get("parameters", [])

            for p in params:
                name = p["name"]

                if vuln_id not in user_params:
                    raise ValueError(
                        f"Missing parameter block for vuln '{vuln_id}'"
                    )

                if name not in user_params[vuln_id]:
                    raise ValueError(
                        f"Missing required parameter '{name}' for vuln '{vuln_id}'"
                    )
