### A Pluto.jl notebook ###
# v0.11.5

using Markdown
using InteractiveUtils

# ╔═╡ ee7f561c-d81e-11ea-1ab7-79f8402b4d17
using BenchmarkTools

# ╔═╡ 448a3efa-d81a-11ea-0edf-61f986c76b33
j = download("https://fonsp.com/img/doggoSmall.jpg?raw=true")

# ╔═╡ 5bd0f9fa-d81a-11ea-3f31-b9b2539bfdb5
s = download("https://raw.githubusercontent.com/fonsp/Pluto.jl/master/frontend/img/logo.svg")

# ╔═╡ 5d1fa8e4-dd86-11ea-2cf8-655e16e409b1
read(j)

# ╔═╡ 6fe33d40-d81a-11ea-2a4f-55a58310c792
begin
	struct A end
	struct B end
	
	function Base.show(io::IO, ::MIME"image/svg+xml", x::A)
		write(io, read(s))
	end
	function Base.show(io::IO, ::MIME"image/jpg", x::B)
		write(io, read(j))
	end
end

# ╔═╡ c4ac67d6-d81d-11ea-3451-dbbe783346d1
HTML(read(s, String))

# ╔═╡ ab5063f8-d81a-11ea-226a-d1aa2d3ca1b3
A()

# ╔═╡ ad4e7960-d81a-11ea-1348-2535562126e2
B()

# ╔═╡ 8043f438-d81d-11ea-11cf-71aea5163f10
[A(), B()]

# ╔═╡ Cell order:
# ╠═448a3efa-d81a-11ea-0edf-61f986c76b33
# ╠═5bd0f9fa-d81a-11ea-3f31-b9b2539bfdb5
# ╠═5d1fa8e4-dd86-11ea-2cf8-655e16e409b1
# ╠═6fe33d40-d81a-11ea-2a4f-55a58310c792
# ╠═ee7f561c-d81e-11ea-1ab7-79f8402b4d17
# ╠═c4ac67d6-d81d-11ea-3451-dbbe783346d1
# ╠═ab5063f8-d81a-11ea-226a-d1aa2d3ca1b3
# ╠═ad4e7960-d81a-11ea-1348-2535562126e2
# ╠═8043f438-d81d-11ea-11cf-71aea5163f10
