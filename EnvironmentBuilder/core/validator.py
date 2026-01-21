class Validator:
    def validate(self, selected_vulns, user_params):
        for vuln in selected_vulns:
            meta = vuln["meta"]
            vid = meta["id"]

            if vid not in user_params:
                raise ValueError(f"Missing parameters for {vid}")

            params = user_params[vid]

            for p in meta["parameters"]:
                name = p["name"]
                if p.get("required") and name not in params:
                    raise ValueError(f"{vid}: Missing required parameter '{name}'")
