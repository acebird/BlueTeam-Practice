def combine(rendered_blocks):
    combined = {
        "bash_setup": [],
        "bash_exploit": []
    }

    for block in rendered_blocks:
        vuln_id = block["vuln_id"]
        kind = block["kind"]          # setup or exploit
        code = block["code"]

        key = f"bash_{kind}"
        header = f"# ===== {vuln_id} ({kind}) ====="
        combined[key].append(f"{header}\n{code}")

    return {
        k: "\n\n".join(v)
        for k, v in combined.items()
    }
