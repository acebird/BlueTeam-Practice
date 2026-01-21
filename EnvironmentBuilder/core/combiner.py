def combine(rendered_blocks):
    combined = {
        "bash_setup": [],
        "bash_exploit": [],
        "ansible_setup": []
    }

    for block in rendered_blocks:
        vuln_id = block["vuln_id"]
        kind = block["kind"]          # setup or exploit
        lang = block["lang"]
        code = block["code"]

        key = f"{lang}_{kind}"
        header = f"# ===== {vuln_id} ({lang} {kind}) ====="
        combined[key].append(f"{header}\n{code}")

    return {
        k: "\n\n".join(v)
        for k, v in combined.items()
        if v
    }
