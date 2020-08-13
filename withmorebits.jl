### A Pluto.jl notebook ###
# v0.9.10

using Markdown

# ╔═╡ 0bbae0f4-add2-11ea-1865-03a6f7cdfc45
using BenchmarkTools

# ╔═╡ 1dc09292-adb8-11ea-17c4-c52b3f0ef25e
x = function a(;b, c)
	b+c
end

# ╔═╡ b9218964-af07-11ea-20b0-77a6e3976135
md"""
Arrow keys

### Running cells

Run on Enter makes me a bit nervous in the REPL, so maybe Run on Shift+Enter, and normally cells just stay "dirty", and they all run when you do Ctrl+S (like today).

### Line numbers

Not sure - not really necessary since we added interactive stack traces anyways

### Borders around cells - spacing between cells
"""

# ╔═╡ be724294-af07-11ea-3176-8de74217b252


# ╔═╡ 2bf0b8c4-adb8-11ea-0b9e-45f7617ad90a
m1 = methods(x).ms[1]

# ╔═╡ 4c58812a-adb8-11ea-3854-29d4caade5cd
ft = typeof(x).name

# ╔═╡ a8930506-adba-11ea-3ff2-b1234202ff95
nameof(x)

# ╔═╡ e8f0bf3e-adc5-11ea-1178-9b028ad34be8
d = "asdf" |> codeunits |> collect

# ╔═╡ 8252b632-adc6-11ea-369d-d15548b72323
pa = collect(Dict("a"=>1))[1]

# ╔═╡ 42af2df2-adc7-11ea-0ce1-33e8a0151c4a
begin
	b1 = IOBuffer()
	write(b1, "asdf")
	seekstart(b1)
	b2 = IOBuffer()
	write(b2, b1)
	readavailable(b2)
end

# ╔═╡ afe26228-add0-11ea-37bb-df5c10c7a0f4
(UInt8(300) + UInt8(200)) |> Int64

# ╔═╡ 4e2351f8-add2-11ea-1fcb-b53bdb99f9de
Int32(3000000000) + Int32(1000000000)

# ╔═╡ 10510370-add2-11ea-10d7-519c0e258637
ra = Dict(
	:a => rand(UInt8, 100),
	:b => 0x01
)

# ╔═╡ 43ce2598-add2-11ea-3684-25070660b6dd
begin
	function withmorebits(d::Dict)
		Dict((
				p.first => withmorebits(p.second)
			for p in d))
	end
	function withmorebits(x::T) where T<:Integer
		Int64(x)
	end
	function withmorebits(x::Vector)
		withmorebits.(x)
	end
end

# ╔═╡ 1fb20e0e-add2-11ea-21d6-9983b98f7a2f
withmorebits(ra)

# ╔═╡ f8a0643a-add3-11ea-1440-efd1c1705277
fill(1,3)

# ╔═╡ 20957f1e-add6-11ea-3e47-5175cf53bdc4
512*512*4

# ╔═╡ Cell order:
# ╠═1dc09292-adb8-11ea-17c4-c52b3f0ef25e
# ╟─b9218964-af07-11ea-20b0-77a6e3976135
# ╠═be724294-af07-11ea-3176-8de74217b252
# ╠═2bf0b8c4-adb8-11ea-0b9e-45f7617ad90a
# ╠═4c58812a-adb8-11ea-3854-29d4caade5cd
# ╠═a8930506-adba-11ea-3ff2-b1234202ff95
# ╠═e8f0bf3e-adc5-11ea-1178-9b028ad34be8
# ╠═8252b632-adc6-11ea-369d-d15548b72323
# ╟─42af2df2-adc7-11ea-0ce1-33e8a0151c4a
# ╠═afe26228-add0-11ea-37bb-df5c10c7a0f4
# ╠═0bbae0f4-add2-11ea-1865-03a6f7cdfc45
# ╠═4e2351f8-add2-11ea-1fcb-b53bdb99f9de
# ╠═10510370-add2-11ea-10d7-519c0e258637
# ╠═43ce2598-add2-11ea-3684-25070660b6dd
# ╠═1fb20e0e-add2-11ea-21d6-9983b98f7a2f
# ╠═f8a0643a-add3-11ea-1440-efd1c1705277
# ╠═20957f1e-add6-11ea-3e47-5175cf53bdc4
