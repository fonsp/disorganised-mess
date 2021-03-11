### A Pluto.jl notebook ###
# v0.15.0

using Markdown
using InteractiveUtils

# ╔═╡ 4866592b-179c-4890-89a4-b26d7a36c1ce
using URIs

# ╔═╡ b3eb465c-d855-4fbd-9952-c2fee0e6f192
subject = "Hello friends!"

# ╔═╡ 2eab5cb6-250a-4d09-bc80-9ffef253d989
something = 90182309123098123

# ╔═╡ 607c4fa0-8243-11eb-181e-c7f45befd4e6
HTML("""

<script>

const nbfile_url = window.location.href.replace("edit", "notebookfile")

const a = html`<a target="_blank">Send to my teacher</a>`

const handle = setInterval(async () => {
const content = await (await fetch(nbfile_url)).text()

a.href = `mailto:teacher@gmail.com?subject=\${encodeURIComponent($(repr(subject)))}&body=\${encodeURIComponent(content)}`

}, 500)

invalidation.then(() => {
clearInterval(handle)
})

return a

</script>

""")


# ╔═╡ 914e6151-7ab6-4dde-8f30-4e75ea98cc9e
escapeuri(" ")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
URIs = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"

[compat]
URIs = "^1.2.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[URIs]]
git-tree-sha1 = "7855809b88d7b16e9b029afd17880930626f54a2"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.2.0"
"""

# ╔═╡ Cell order:
# ╠═b3eb465c-d855-4fbd-9952-c2fee0e6f192
# ╠═2eab5cb6-250a-4d09-bc80-9ffef253d989
# ╠═607c4fa0-8243-11eb-181e-c7f45befd4e6
# ╠═4866592b-179c-4890-89a4-b26d7a36c1ce
# ╠═914e6151-7ab6-4dde-8f30-4e75ea98cc9e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
