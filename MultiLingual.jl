### A Pluto.jl notebook ###
# v0.17.7

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ c35f0e90-1586-11ec-2bb5-abc0ab1a4a27
using HypertextLiteral

# ╔═╡ 1378705d-a3c6-4971-9ac8-cd2a12cf2ef9
begin
	"""
	A way to provide multiple translations of the same object. When someone else views your notebook, _their_ system/browser preferences are used to show the translation in _their preferred language_. This allows you to write multilingual material!

	# Example
	```julia
	MultiLingual([
		"fr" => "Salut tous le monde !",
		"en" => "Hello world!", 
	])
	```

	When the result is viewed on a computer with English set as the prefered language, it will say _Hello world!_, and _Salut tous le monde !_ on a French computer.

	# Not just strings

	`MultiLingual` can be used to provide translations for any object. Most commonly, it can be used to switch between markdown proses:
	```julia
	MultiLingual([
		"fr" => md"\""
		# Salut tous le monde !
	
		Ma planète préferée est **Pluto**.
		"\"",
	
		"en" => md"\""
		# Hello world!
	
		My favourite planet is **Pluto**.
		"\"", 
	])
	```

	You can even use `MultiLingual` to show a different image or plot depending on the preferred language!
	
	# Fallback language

	When none of the provided translations is a preferred language of the reader, the **first** version will be shown. In the example above, this would be the `"fr"` version.

	# Language codes and dialects
	As the language tag, we use a 2-character [ISO 639-1 code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes), like `"fr"` or `"en"`. Using the full name of the language (e.g. `"Français"`) will not work, but you can use [this table to find the 2-character code for many languages](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes). 

	## Regional variants, dialects
	
	If you want to provide translations for regional versions of the same language, you can use a [BCP47 codes](http://tools.ietf.org/html/bcp47) as the language tag, containing a **2-character language tag** and an optional **2-character region tag**. Examples are: `"en"` (English), `"en-US"` (_American_ English), `"de"` (German) and `"de-AT"` (_Austrian_ German).

	If you are providing translations for **multiple regional variants of a language**, use the full BCP47 code, including the region:
	```julia
	MultiLingual([
		"en-GB" => "Those colours are delighful!", 
		"en-US" => "Sick colors yo!", 
		"nl" => "Leuke kleurtjes!",
	])
	```

	However, if you are only providing **one translation per language** (intended for speakers of any region within a language), then **we recommend not specifying the region**.
	```julia
	MultiLingual([
		"en" => "Those colours are nice!", 
		"nl" => "Leuke kleurtjes!",
	])
	```

	
	"""
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

# ╔═╡ 00bf8e98-b6e9-425d-a76a-7cf3608b6a71
MultiLingual([
	"en" => md"""
	# This is some English text!

	Hellozers!
	""", 
	
	"fr" => md"""
	# Voici un texte en Français!
	
	Cici n'est pas un texte
	"""
])

# ╔═╡ 33fb35e6-f935-4007-a53d-b66df49866ac
ml = MultiLingual(["en" => "This is some English text!", "fr" => "Salut tous le monde !"])

# ╔═╡ 9328bee0-5b2b-4f1d-8189-b5f8cddfa065
md"# Hello!!!"

# ╔═╡ 6fc7dffe-a0e6-4d01-b3ce-257ec902b98f
MultiLingual([
	"es" => md"# Salut !!!",
	"nl" => md"# Hallo!!!",
	"en" => md"hello",
	
])

# ╔═╡ 7c7eb3ff-baf6-4a96-9337-47fda60d4ca2
ml2 = MultiLingual(["asdfasdf" => "show me", "kjewfkjh" => "not me"])

# ╔═╡ e3992501-6f29-43ff-a0a6-7c9080c0bf9e
MultiLingual(["asdf" => "fake language", "en-GB" => "this is englishz", "kjewfkjh" => "not me"])

# ╔═╡ 23530429-93ab-41c4-aafe-8071614ba19f
md"""
# Hello $(MultiLingual(["en" => "English", "fr" => "French",])) speaker
"""

# ╔═╡ 347220f8-e29c-4944-a2b9-964c9479a389


# ╔═╡ 35bf4d11-2c31-4a2e-8f20-3a4dbc7267b9
md"""
TODO
"""

# ╔═╡ f15f351f-bae4-458c-abec-6bb6f475d48a
@htl("""
<div style='font-family: system-ui'><span style='font-size: .9em'>文</span>A</div>
""")

# ╔═╡ 993f1096-d9b1-468b-a739-5906d3ad932f
@htl("""
<img style='height: 1em; width: 1em;' src='https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.2/src/svg/language-outline.svg'>
""")

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
# ╠═00bf8e98-b6e9-425d-a76a-7cf3608b6a71
# ╠═c35f0e90-1586-11ec-2bb5-abc0ab1a4a27
# ╠═1378705d-a3c6-4971-9ac8-cd2a12cf2ef9
# ╠═33fb35e6-f935-4007-a53d-b66df49866ac
# ╠═9328bee0-5b2b-4f1d-8189-b5f8cddfa065
# ╠═6fc7dffe-a0e6-4d01-b3ce-257ec902b98f
# ╠═7c7eb3ff-baf6-4a96-9337-47fda60d4ca2
# ╠═e3992501-6f29-43ff-a0a6-7c9080c0bf9e
# ╠═23530429-93ab-41c4-aafe-8071614ba19f
# ╠═347220f8-e29c-4944-a2b9-964c9479a389
# ╠═35bf4d11-2c31-4a2e-8f20-3a4dbc7267b9
# ╠═f15f351f-bae4-458c-abec-6bb6f475d48a
# ╠═993f1096-d9b1-468b-a739-5906d3ad932f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
