### A Pluto.jl notebook ###
# v0.14.0

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

# ╔═╡ a5572edc-3946-4690-888d-cbbb83b33012
ClickCounterWithReset(text="Click", reset_text="Reset") = HTML("""
<div>
<button>$(text)</button>&nbsp;&nbsp;&nbsp;&nbsp;
<a id="reset" href="#">$(reset_text)</a>
</div>

<script id="blabla">

// Select elements relative to `currentScript`
const div = currentScript.previousElementSibling
const button = div.querySelector("button")
const reset = div.querySelector("#reset")

// we wrapped the button in a `div` to hide its default behaviour from Pluto

let count = 0

button.addEventListener("click", (e) => {
	count += 1
	
	div.value = count
	div.dispatchEvent(new CustomEvent("input"))
	e.stopPropagation()
})

	reset.addEventListener("click", (e) => {
	count = 0
	
	div.value = count
	div.dispatchEvent(new CustomEvent("input"))
	e.stopPropagation()
	e.preventDefault()
})

// Set the initial value
div.value = count

</script>
""")

# ╔═╡ cc6e3ee2-3914-4fc8-99e7-755615c95c5e
@bind zz ClickCounterWithReset("Take one step!", "Start over!")

# ╔═╡ 493d8938-8a87-4e03-a976-6ce35dcf87b3
zz

# ╔═╡ Cell order:
# ╠═cc6e3ee2-3914-4fc8-99e7-755615c95c5e
# ╠═493d8938-8a87-4e03-a976-6ce35dcf87b3
# ╠═a5572edc-3946-4690-888d-cbbb83b33012
