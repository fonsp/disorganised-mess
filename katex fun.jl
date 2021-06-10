### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 2b72a4ec-c88e-11eb-30b1-8d574ab0e3f1
using HypertextLiteral

# ╔═╡ b82b0cdd-58b6-4cd9-8814-4b7046894bce
using PlutoUI

# ╔═╡ a4c2094f-5e6f-4e4f-8bcb-703513e54c8a
smalldog = html"""
<img src='https://user-images.githubusercontent.com/6933510/116753174-fa40ab80-aa06-11eb-94d7-88f4171970b2.jpeg' height=30px>"""

# ╔═╡ e59ed5bc-9e19-418a-9b01-ccaea6820096
begin
	Base.@kwdef struct SlottedLaTeX
		parts::Vector{String}
		slots::Vector{Any}
		# displaymode::Bool=true
	end
	function Base.show(io::IO, m::MIME"text/html", sl::SlottedLaTeX)
		h = @htl("""
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.13.11/dist/katex.min.css" integrity="sha384-Um5gpz1odJg5Z4HAmzPtgZKdTBHZdw8S29IecapCSB31ligYPhHQZMIlWLYQGVoc" crossorigin="anonymous">
			<style>
			.katex .base, 
			.katex .strut {
				/*display: inline-flex !important;*/
				pointer-events: none;
			}
			.SlottedLaTeX {
				font-size: .75em;
			}
			.SlottedLaTeX .slot {
				pointer-events: initial;
			}
			</style>
		<script src="https://cdn.jsdelivr.net/npm/katex@0.13.11/dist/katex.min.js" integrity="sha384-YNHdsYkH6gMx9y3mRkmcJ2mFUjTd0qNQQvY9VYZgQd7DcN7env35GzlmFaZ23JGp" crossorigin="anonymous"></script>
		<span class="SlottedLaTeX-slots" style="display: none;">
		$(
			map(sl.slots) do s
				@htl("<span class='slot'>$(s)</span>")
			end
		)
		</span>
		<script>

		// https://unicode-table.com/en/#2800
		const braille_start = 10240
		// https://unicode-table.com/en/#03B1
		const greek_start = 945

		const placeholder = (i) => String.fromCodePoint(braille_start + i)
		const placeholder_index = (s) => s.codePointAt(0) - braille_start

		const k = (segments, ...slots) => {

			const mock = [...slots.flatMap((_, i) => [segments[i], placeholder(i)]), segments[segments.length-1]].join("")

			const el = html`<span class='SlottedLaTeX'></span>`
			katex.render(mock, el, {
				displayMode: currentScript.closest("p") == null,
			})


			Array.from(el.querySelectorAll("span")).forEach(span => {
				const t = span.innerText
				if(t.length === 1) {
					const i = placeholder_index(t)
					if(0 <= i && i < slots.length) {
						span.replaceWith(slots[i])
					}

				}
			})

			return el
		}

		const parts = $(sl.parts)

		console.log(parts)
		const slots = Array.from(currentScript.previousElementSibling.children)

		console.log(slots)
		return k(parts, ...slots)

		</script>


		""")

		Base.show(io, m, h)
	end
end

# ╔═╡ 6d43f0c4-2475-44e5-9365-d717f98e3bba
begin
	macro tex(x)
		tex(x)
	end
	# `_str` macros with interpolation are not reactive in pluto 🙈 until https://github.com/fonsp/Pluto.jl/pull/1032 is fixed. :((
	#macro tex_str(_x::String)
	#	x = Meta.parse("\"" * _x * "\"")
 	#	tex(x)
	#end
	function tex(ex::Expr)
		@assert ex.head === :string
		parts = String[ex.args[1] isa String ? ex.args[1] : "\\hspace{0pt}"]
		slots = Any[]
		for x in ex.args[2:end]
			if x isa String			
				all(==(' '), x) ? push!(parts, "\\hspace{0pt}") : push!(parts, x)
			else
				length(parts) != length(slots) + 1 && push!(parts, "\\hspace{0pt}")
				push!(slots, x)
			end
		end
	end
	function tex(x::String)
		SlottedLaTeX(
			parts=[x],
			slots=[],
		)
	end
end

# ╔═╡ a9c0b54c-ba74-41b1-8baf-a02cf3edf764
cool = @tex("""
	f(x) = 
	\\oint_{
		x \\in \\mathbb{R}
	}
	\\frac{
		1 + $(smalldog)
	}{
		$(@bind x Scrubbable(5)) + x
	}
	""")

# ╔═╡ 6d0d02ce-d309-4e34-bb4d-2e8dd9712f87
x

# ╔═╡ 34f87c79-bde2-4f80-a598-f02cac3c00d4
let
	sl = @tex("Slotted\\LaTeX")
	md"""

	You can use $(sl) inside markdown! 
	
	$(cool)

	"""
end

# ╔═╡ c13e40a9-adb2-4679-9839-5b22d2470914
@macroexpand @tex("""\\frac{1 + $(π^2)}{$(Scrubbable(5)) + x}""")

# ╔═╡ Cell order:
# ╠═a9c0b54c-ba74-41b1-8baf-a02cf3edf764
# ╠═6d0d02ce-d309-4e34-bb4d-2e8dd9712f87
# ╠═34f87c79-bde2-4f80-a598-f02cac3c00d4
# ╠═2b72a4ec-c88e-11eb-30b1-8d574ab0e3f1
# ╠═b82b0cdd-58b6-4cd9-8814-4b7046894bce
# ╠═6d43f0c4-2475-44e5-9365-d717f98e3bba
# ╠═c13e40a9-adb2-4679-9839-5b22d2470914
# ╠═a4c2094f-5e6f-4e4f-8bcb-703513e54c8a
# ╠═e59ed5bc-9e19-418a-9b01-ccaea6820096
