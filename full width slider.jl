### A Pluto.jl notebook ###
# v0.17.2

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

# ╔═╡ 204ea302-5387-11ec-1404-010e89c10f01
using PlutoUI

# ╔═╡ 63b61477-4ba1-4d02-9871-cf548841ce92
using HypertextLiteral

# ╔═╡ c0f73436-aff8-41f3-870c-bca44765b47c
md"""
## Copy these two cells!
"""

# ╔═╡ f62e3198-a57d-47e1-9fb0-933e4b80690d
full_width(x) = @htl("""
<div class='fullwidthslider'>$(x)</div>
<style>
.fullwidthslider .plutoui-rangeslider,
.fullwidthslider input[type=range] {
	display: block;
	width: calc(100% - 2rem);
}
</style>
""")

# ╔═╡ a727807b-9d8a-4dce-813f-e199f511dca8
md"""
## Example
"""

# ╔═╡ ae2011a1-70d2-4fdd-91a7-683dc704cc57
full_width(
	@bind subrange RangeSlider(1:5:100)
)

# ╔═╡ 560a51a8-d915-4ef4-8880-66d3c627e4f4
subrange

# ╔═╡ 3c283b02-b76f-46f7-b003-72e20b8bfd5f
full_width(
	@bind hello Slider(1:100)
)

# ╔═╡ 9064e0d5-ad22-45e4-8881-e1714e92f5f4
hello

# ╔═╡ Cell order:
# ╠═204ea302-5387-11ec-1404-010e89c10f01
# ╟─c0f73436-aff8-41f3-870c-bca44765b47c
# ╠═63b61477-4ba1-4d02-9871-cf548841ce92
# ╠═f62e3198-a57d-47e1-9fb0-933e4b80690d
# ╟─a727807b-9d8a-4dce-813f-e199f511dca8
# ╠═ae2011a1-70d2-4fdd-91a7-683dc704cc57
# ╠═560a51a8-d915-4ef4-8880-66d3c627e4f4
# ╠═3c283b02-b76f-46f7-b003-72e20b8bfd5f
# ╠═9064e0d5-ad22-45e4-8881-e1714e92f5f4
