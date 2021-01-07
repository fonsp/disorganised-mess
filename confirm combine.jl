### A Pluto.jl notebook ###
# v0.11.14

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

# ╔═╡ 3bad3496-fa7e-11ea-333f-57ed97316b28
function confirm_combine(node, label="Submit")
	
	id = String(rand('a':'z', 10))
	"""
<div id="$(id)">
	<span>
	$(repr(MIME"text/html"(), node))
	</span>
<input type="submit" value="$(Markdown.htmlesc(label))">
</div>
<script>
	const div = this.querySelector("#$(id)")
	const inputs = div.querySelectorAll("span input")
	
	const values = Array(inputs.length)
	
	inputs.forEach(async (el,i) => {
		el.oninput = (e) => {
			e.stopPropagation()
		}
		const gen = observablehq.Generators.input(el)
		while(true) {
			values[i] = await gen.next().value
			div.value = values
		}
	})
	
	const submit = div.querySelector("input[type=submit]")
	submit.onclick = () => {
		div.dispatchEvent(new CustomEvent("input", {}))
	}
</script>
""" |> HTML
end

# ╔═╡ e50355d6-fa7f-11ea-2e0d-673c49836136
@bind xoxo confirm_combine(md"""
A slider: $(Slider(1:10))
	
and a checkbox: $(CheckBox())

""")

# ╔═╡ fa03a8ca-fa7f-11ea-2021-bfb9dc7ff411
sleep(1); xoxo

# ╔═╡ Cell order:
# ╠═fa03a8ca-fa7f-11ea-2021-bfb9dc7ff411
# ╠═e50355d6-fa7f-11ea-2e0d-673c49836136
# ╟─3bad3496-fa7e-11ea-333f-57ed97316b28
