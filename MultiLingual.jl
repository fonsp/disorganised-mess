### A Pluto.jl notebook ###
# v0.16.0

using Markdown
using InteractiveUtils

# ╔═╡ c35f0e90-1586-11ec-2bb5-abc0ab1a4a27
using HypertextLiteral

# ╔═╡ 1378705d-a3c6-4971-9ac8-cd2a12cf2ef9
begin
	struct MultiLingual
		contents::Vector{Pair{String,Any}}
	end
	
	function Base.show(io::IO, m::MIME"text/html", ml::MultiLingual)
		Base.show(io, m, @htl("""
				<span>
				<script>
				const wrapper = currentScript.parentElement
				const spans = Array.from(wrapper.childNodes).filter(n => n.tagName === "SPAN")
				
				console.log(spans)
				
				</script>
				
				<style>
				
				
				</style>
				
				$((
					@htl("
					<span lang=$(lang)>$(el)</span>
					")
					for (lang, el) in ml.contents
				))
				</span>
				
				"""))
	end
end

# ╔═╡ 33fb35e6-f935-4007-a53d-b66df49866ac
ml = MultiLingual(["en" => "English!", "fr" => "frnenchh"])

# ╔═╡ 7c7eb3ff-baf6-4a96-9337-47fda60d4ca2
ml2 = MultiLingual(["en" => "English!", "fr" => ml])

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
HypertextLiteral = "~0.9.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[HypertextLiteral]]
git-tree-sha1 = "72053798e1be56026b81d4e2682dbe58922e5ec9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.0"
"""

# ╔═╡ Cell order:
# ╠═c35f0e90-1586-11ec-2bb5-abc0ab1a4a27
# ╠═1378705d-a3c6-4971-9ac8-cd2a12cf2ef9
# ╠═33fb35e6-f935-4007-a53d-b66df49866ac
# ╠═7c7eb3ff-baf6-4a96-9337-47fda60d4ca2
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
