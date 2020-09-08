### A Pluto.jl notebook ###
# v0.11.12

using Markdown
using InteractiveUtils

# ╔═╡ 8da62b8c-f104-11ea-3b00-3989f459e752
begin
	import Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ 9ef0d61c-f104-11ea-106a-4fa45d348d2b
begin
	Pkg.add(["Plots"])
	using Plots
	plotly()
end

# ╔═╡ a5b92eae-f104-11ea-236e-ed2517b1a4fc
T = LinRange(0.0, 4.5, 300)

# ╔═╡ db29ea74-f104-11ea-25e6-851f334b925a
f(t) = 1.0 + sin(t)

# ╔═╡ 39c9232e-f105-11ea-0fab-055ea4f518d9
plot(T, f.(T))

# ╔═╡ Cell order:
# ╠═8da62b8c-f104-11ea-3b00-3989f459e752
# ╠═9ef0d61c-f104-11ea-106a-4fa45d348d2b
# ╠═a5b92eae-f104-11ea-236e-ed2517b1a4fc
# ╠═db29ea74-f104-11ea-25e6-851f334b925a
# ╠═39c9232e-f105-11ea-0fab-055ea4f518d9
