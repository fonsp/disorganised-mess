### A Pluto.jl notebook ###
# v0.9.10

using Markdown
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.peek, el) ? Base.peek(el) : missing
        el
    end
end

# ╔═╡ 0687145a-b7dd-11ea-27ed-510415e76394
slider = html"<input type='range'>"

# ╔═╡ f115ae88-b7dc-11ea-2e5c-194961a9dbb4
md"# Experiment 1"

# ╔═╡ 1b05a86a-b7dd-11ea-32c2-bbf35bf961fd
md"Uncomment:"

# ╔═╡ f724a6e4-b7dc-11ea-17fb-8bffb87dcd3d
# md"""Last value of $(@bind x slider) was $(x)"""

# ╔═╡ 18f5e148-b7dd-11ea-3f27-516c3048a0cc
md"Oh oh... it's stuck in an infinite loop! Why this happens is not important right now, but notice that the value is always _missing_, even in the second iteration."

# ╔═╡ 1682e96a-b7dd-11ea-1ede-bb9fcd6cd314


# ╔═╡ 54357d32-b7dc-11ea-0940-c9ad3ac3c928
md"We create our own slider so that observable/stdlib doesn't send the initial value."

# ╔═╡ 26096e56-b7d6-11ea-00fe-abf2433dbd4d
slider_without_initial = html"""
<span>

<input type='range'>

<script>
const span = this.currentScript.parentElement
const input = span.querySelector("input")

input.oninput = (e) => {
	span.value = input.value
	span.dispatchEvent(new CustomEvent("input"))
	e.stopPropagation()
}
</script>
</span>
""";

# ╔═╡ 7815473c-b7dc-11ea-2a70-75d9babe7a2c
md"This cell depends on `z`, so it will run when `z` is set.

`z` is set to the new value before the cell is executed (by the `@bind` system), but not when the cell is first run (the bond doesn't exist yet, so `z` is just an undefined variable)."

# ╔═╡ 79d86d5e-b7d9-11ea-13fa-890824c0b1a7
begin
	local wow = missing
	try wow = z catch end
	output = md"""Last value of $(@bind z slider_without_initial) was $(wow)"""
end

# ╔═╡ 44de14e8-b7dc-11ea-391d-0505dfa536dd


# ╔═╡ Cell order:
# ╠═0687145a-b7dd-11ea-27ed-510415e76394
# ╟─f115ae88-b7dc-11ea-2e5c-194961a9dbb4
# ╟─1b05a86a-b7dd-11ea-32c2-bbf35bf961fd
# ╠═f724a6e4-b7dc-11ea-17fb-8bffb87dcd3d
# ╟─18f5e148-b7dd-11ea-3f27-516c3048a0cc
# ╠═1682e96a-b7dd-11ea-1ede-bb9fcd6cd314
# ╟─54357d32-b7dc-11ea-0940-c9ad3ac3c928
# ╠═26096e56-b7d6-11ea-00fe-abf2433dbd4d
# ╟─7815473c-b7dc-11ea-2a70-75d9babe7a2c
# ╠═79d86d5e-b7d9-11ea-13fa-890824c0b1a7
# ╠═44de14e8-b7dc-11ea-391d-0505dfa536dd
