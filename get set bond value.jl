### A Pluto.jl notebook ###
# v0.18.1

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

# ╔═╡ 7816cca7-1139-4a88-8ad0-21f1906e4cb1
using HypertextLiteral

# ╔═╡ 881d87a0-9fbd-11ec-33bb-953669201482
ClickCounter(text="Click") = @htl("""
<span>
<button>$(text)</button>

<script>

	// Select elements relative to `currentScript`
	const span = currentScript.parentElement
	const button = span.querySelector("button")

	// we wrapped the button in a `span` to hide its default behaviour from Pluto

	let count = 0

	const label = $(text)
	const update_button_label = () => {
		button.innerText = label + " " + count
	}

	button.addEventListener("click", (e) => {
		count += 1
		update_button_label()

		// we dispatch the input event on the span, not the button, because 
		// Pluto's `@bind` mechanism listens for events on the **first element** in the
		// HTML output. In our case, that's the span.

		span.dispatchEvent(new CustomEvent("input"))
		e.preventDefault()
	})

	Object.defineProperty(span, "value", {
		get: () => count,
		set: (x) => {
			count = x
			update_button_label()
		},
	})

	// Set the initial value
	span.value = count

</script>
</span>
""")

# ╔═╡ 7bd0cebd-1252-48e3-90d3-a5d14b6886e6
bb = @bind x ClickCounter()

# ╔═╡ 0e8d0631-9c98-4e16-b8fd-340dcbeda79c
bb

# ╔═╡ 95e0e940-8135-45d5-8ecc-7481665abbfc
x

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
HypertextLiteral = "~0.9.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"
"""

# ╔═╡ Cell order:
# ╠═7bd0cebd-1252-48e3-90d3-a5d14b6886e6
# ╠═0e8d0631-9c98-4e16-b8fd-340dcbeda79c
# ╠═95e0e940-8135-45d5-8ecc-7481665abbfc
# ╠═7816cca7-1139-4a88-8ad0-21f1906e4cb1
# ╠═881d87a0-9fbd-11ec-33bb-953669201482
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
