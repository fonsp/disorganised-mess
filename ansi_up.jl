### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 0c14a1c2-e220-44ae-a8a7-48c76bcc9d92
using HypertextLiteral

# ╔═╡ 9a8d566a-248f-11ee-3b0a-81c217471a03
s = """
\n\n\x1B[1;33;40m 33;40  \x1B[1;33;41m 33;41  \x1B[1;33;42m 33;42  \x1B[1;33;43m 33;43  \x1B[1;33;44m 33;44  \x1B[1;33;45m 33;45  \x1B[1;33;46m 33;46  \x1B[1m\x1B[0\n\n\x1B[1;33;42m >> Tests OK\n\n
"""

# ╔═╡ 85b7f1ea-cede-44f2-b54d-59dd68c4f95d
@htl """
<script>
let ansi_up_lib = await import("https://esm.sh/ansi_up@5.2.1")
let ansi_up = new ansi_up_lib.default()

const cdiv = document.createElement("div")
cdiv.innerHTML = ansi_up.ansi_to_html($s)
return cdiv
</script>
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
HypertextLiteral = "~0.9.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.3"
manifest_format = "2.0"
project_hash = "fc304fba520d81fb78ea25b98f5762b4591b1182"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"
"""

# ╔═╡ Cell order:
# ╠═9a8d566a-248f-11ee-3b0a-81c217471a03
# ╠═0c14a1c2-e220-44ae-a8a7-48c76bcc9d92
# ╠═85b7f1ea-cede-44f2-b54d-59dd68c4f95d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
