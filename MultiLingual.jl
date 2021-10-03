### A Pluto.jl notebook ###
# v0.16.1

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
				const lang = (s) => s.getAttribute("lang")
				// const defined_langs = spans.map(lang)

				for (const l of navigator.languages) {
					for (const s of spans) {
		console.log(s,l)
						if(
							lang(s).toLowerCase() === l.toLowerCase() || 
							lang(s).toLowerCase() === l.toLowerCase().split("-")[0]
						) {
					
							s.style.display = null
							return
						}
					}
				}
				for (const l of navigator.languages) {
					for (const s of spans) {
		console.log(s,l)
						if(
							lang(s).toLowerCase().split("-")[0] === l.toLowerCase().split("-")[0]
						) {
					
							s.style.display = null
							return
						}
					}
				}

				// if no match was found, display the first span
				if(spans.length > 0){
					spans[0].style.display = null
				}
		
				
				console.log(spans)
				
				</script>
				
				<style>
				
				
				</style>
				
				$((
					@htl("""
					<span lang=$(lang) style=$(false ? "" : "display: none")>$(el)</span>
					""")
					for (i,(lang, el)) in enumerate(ml.contents)
				))
				</span>
				
				"""))
	end
end

# ╔═╡ f15f351f-bae4-458c-abec-6bb6f475d48a
@htl("""
<div style='font-family: system-ui'><span style='font-size: .9em'>文</span>A</div>
""")

# ╔═╡ 33fb35e6-f935-4007-a53d-b66df49866ac
ml = MultiLingual(["en" => "This is some English text!", "fr" => "Salut tous le monde !"])

# ╔═╡ 7c7eb3ff-baf6-4a96-9337-47fda60d4ca2
ml2 = MultiLingual(["asdfasdf" => "show me", "kjewfkjh" => "not me"])

# ╔═╡ e3992501-6f29-43ff-a0a6-7c9080c0bf9e
MultiLingual(["asdf" => "fake language", "en-GB" => "this is englishz", "kjewfkjh" => "not me"])

# ╔═╡ 23530429-93ab-41c4-aafe-8071614ba19f
md"""
# Hello $(MultiLingual(["en" => "English", "fr" => "French"])) speaker
"""

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
# ╠═f15f351f-bae4-458c-abec-6bb6f475d48a
# ╠═33fb35e6-f935-4007-a53d-b66df49866ac
# ╠═7c7eb3ff-baf6-4a96-9337-47fda60d4ca2
# ╠═e3992501-6f29-43ff-a0a6-7c9080c0bf9e
# ╠═23530429-93ab-41c4-aafe-8071614ba19f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
