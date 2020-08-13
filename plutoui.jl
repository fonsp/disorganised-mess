### A Pluto.jl notebook ###
# v0.10.12

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

# ╔═╡ fb6e0798-9ace-11ea-2ca2-7d1e22a866ca
md"_Note: you are **not** supposed to bind to the same variable multiple times - this might not be supported in the future._"

# ╔═╡ 914bc588-9acb-11ea-3969-8d7a0f526214
using PlutoUI

# ╔═╡ a8ccf98e-9acb-11ea-1f0c-01aa8f088824
md"
$(@bind s Slider(1:10))
$(@bind s Slider(1:10,4))
$(@bind s Slider(1:10,default=11))
$(@bind s Slider(1:0.01:10,4))
"

# ╔═╡ cdf0b37e-9acb-11ea-3c6b-a7a4fcbe1a55
s

# ╔═╡ dc05667e-9acb-11ea-37fc-21fbc6d1fcfb
md"
$(@bind n NumberField(1:10))
$(@bind n NumberField(1:10,4))
$(@bind n NumberField(1:10,default=11))
$(@bind n NumberField(1:0.01:10,4))
"

# ╔═╡ e9bed98a-9acb-11ea-32d7-a7512d909c73
n

# ╔═╡ ea7f7fe6-9acb-11ea-1f6a-c95581042643
begin
	bad_str = "Very \"cool\" <b>yo</b> & wow\""
	md"""
	$(@bind b Button())
	$(@bind b Button(bad_str))
	"""
end

# ╔═╡ e50404fe-9acd-11ea-18c7-216799db4f4f
b

# ╔═╡ e6c2471a-9acd-11ea-35ba-75f34399d3a2
md"
$(@bind c CheckBox())
$(@bind c CheckBox(true))
$(@bind c CheckBox(default=true))
"

# ╔═╡ b42bc23a-9ace-11ea-09ce-29fcc6a19b69
c

# ╔═╡ 88bc663e-9ace-11ea-11ca-4d1c83650ea3
md"
$(@bind t TextField())
$(@bind t TextField(default=bad_str))
$(@bind t TextField((3,3)))
"

# ╔═╡ 861346de-9ace-11ea-29f9-35a6d02cd7fc
t

# ╔═╡ 8079ffbe-9acf-11ea-0f20-3d9ba4a1bea7
begin
	eq = md"$\frac{\pi^2}{6}$"
	img = md"![dogs](https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fgraphics.wsj.com%2Fmost-popular-dogs%2Fphoto%2FGolden-Retriever.png&f=1&nofb=1)"
	md"""
	$(@bind se Select(["a","b"]))
	$(@bind se Select(["c" => 123, "d" => eq, "e" => img]))
	"""
end
# (this shouldn't actually show the image/equation unfortunately)

# ╔═╡ 8ebf96c4-9acf-11ea-004b-53ed3a1d185b
se

# ╔═╡ 87b82944-9ad0-11ea-15a5-3ba93a6830ae
md"
$(@bind cl Clock())
$(@bind cl Clock(20.0))
$(@bind cl Clock(5.0, true))
"

# ╔═╡ bd35ade6-9ae2-11ea-11f3-f9a61f06de80
cl

# ╔═╡ f44b3020-9ae5-11ea-0589-cf019c781e4a
js""

# ╔═╡ Cell order:
# ╠═914bc588-9acb-11ea-3969-8d7a0f526214
# ╟─fb6e0798-9ace-11ea-2ca2-7d1e22a866ca
# ╠═a8ccf98e-9acb-11ea-1f0c-01aa8f088824
# ╠═cdf0b37e-9acb-11ea-3c6b-a7a4fcbe1a55
# ╠═dc05667e-9acb-11ea-37fc-21fbc6d1fcfb
# ╠═e9bed98a-9acb-11ea-32d7-a7512d909c73
# ╠═ea7f7fe6-9acb-11ea-1f6a-c95581042643
# ╠═e50404fe-9acd-11ea-18c7-216799db4f4f
# ╠═e6c2471a-9acd-11ea-35ba-75f34399d3a2
# ╠═b42bc23a-9ace-11ea-09ce-29fcc6a19b69
# ╠═88bc663e-9ace-11ea-11ca-4d1c83650ea3
# ╠═861346de-9ace-11ea-29f9-35a6d02cd7fc
# ╠═8079ffbe-9acf-11ea-0f20-3d9ba4a1bea7
# ╠═8ebf96c4-9acf-11ea-004b-53ed3a1d185b
# ╠═87b82944-9ad0-11ea-15a5-3ba93a6830ae
# ╠═bd35ade6-9ae2-11ea-11f3-f9a61f06de80
# ╠═f44b3020-9ae5-11ea-0589-cf019c781e4a
