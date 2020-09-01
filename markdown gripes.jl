### A Pluto.jl notebook ###
# v0.11.10

using Markdown
using InteractiveUtils

# ╔═╡ a6dcd8ec-ec92-11ea-16ff-ed6cdef0e01b
md"# Admonitions"

# ╔═╡ 257c49f4-ec92-11ea-0945-b5c28f7746d6
md"### Tab"

# ╔═╡ 22187472-ec92-11ea-29eb-33e609eba048
md"""
!!! info
    hello
"""

# ╔═╡ 2bedf332-ec92-11ea-1806-33b160b0d70f
md"### 4 spaces"

# ╔═╡ 19f10ac0-ec92-11ea-348f-57a0ebcb9aa5
md"""
!!! info
	hello
"""

# ╔═╡ b2f99764-ec92-11ea-2767-895d1a0ffeb5
md"# Footnote definitions"

# ╔═╡ 64387e44-ec92-11ea-052e-45da3187cd30
md"### Tab"

# ╔═╡ 494c58c4-ec92-11ea-0e93-536e9a1d6537
md"Have a look at [^this]"

# ╔═╡ 3635e2fc-ec92-11ea-1d3d-b9778b25a6f1
md"""
[^this]:
	asdf
"""

# ╔═╡ 6892f8fa-ec92-11ea-31b3-791acc4094e4
md"### 4 spaces"

# ╔═╡ 3a4ba37a-ec92-11ea-18a8-f5730032dfa7
md"""
[^this]:
    asdf
"""

# ╔═╡ 24e545ec-ec95-11ea-2be5-8fdf1caee5ba


# ╔═╡ 23bc4512-ec95-11ea-0136-7f36c73fcd57
import Pkg

# ╔═╡ 23e47280-ec95-11ea-207d-5523d4d1becb
Pkg.PackageSpec(name="asdf", version=v"1.2.3")

# ╔═╡ a6f66554-ec91-11ea-3115-7d4e3c3393e4
planet = "Earth"

# ╔═╡ d23722ca-ec91-11ea-3c44-2d74bb0424ed
md"Hi, **$planet**" # 🙂

# ╔═╡ a2c7f3a6-ec95-11ea-1be0-c526576beed0
md"Hi, $planet **$planet**" # 🙁 becomes LaTeX

# ╔═╡ 15cfbd92-ec9a-11ea-1e97-91f7950f46d3
md"Hi, **$planet**$planet" # 🙁 becomes LaTeX

# ╔═╡ d9bae124-ec91-11ea-3ae1-d70593308047
md"Hi, _$planet_ **$planet**" # 🙂

# ╔═╡ 14c92a02-ec9a-11ea-3be5-5b3e6391b62f


# ╔═╡ a3f9c21c-ec91-11ea-205f-7fd12a794760
md"$a **$b**"

# ╔═╡ a6531910-ec90-11ea-02fd-c368cebc71fa
md"""

Hello

$$
no math?
$$

huh
"""

# ╔═╡ 20f13d40-ec9c-11ea-3e3a-4f7cdf11b68c
md"Hello ``asdf`` `a`"

# ╔═╡ b5c49d74-ec90-11ea-3802-8d86913d0d3d
md"""

Hello

$$math :)$$


"""

# ╔═╡ 816bbe72-ec9a-11ea-3b5b-bde7e2a2ec9e
md"""

Hello

```math
math!
```

huh
"""

# ╔═╡ Cell order:
# ╟─a6dcd8ec-ec92-11ea-16ff-ed6cdef0e01b
# ╟─257c49f4-ec92-11ea-0945-b5c28f7746d6
# ╠═22187472-ec92-11ea-29eb-33e609eba048
# ╟─2bedf332-ec92-11ea-1806-33b160b0d70f
# ╠═19f10ac0-ec92-11ea-348f-57a0ebcb9aa5
# ╟─b2f99764-ec92-11ea-2767-895d1a0ffeb5
# ╟─64387e44-ec92-11ea-052e-45da3187cd30
# ╟─494c58c4-ec92-11ea-0e93-536e9a1d6537
# ╠═3635e2fc-ec92-11ea-1d3d-b9778b25a6f1
# ╟─6892f8fa-ec92-11ea-31b3-791acc4094e4
# ╠═3a4ba37a-ec92-11ea-18a8-f5730032dfa7
# ╠═24e545ec-ec95-11ea-2be5-8fdf1caee5ba
# ╠═23e47280-ec95-11ea-207d-5523d4d1becb
# ╠═23bc4512-ec95-11ea-0136-7f36c73fcd57
# ╠═a6f66554-ec91-11ea-3115-7d4e3c3393e4
# ╠═d23722ca-ec91-11ea-3c44-2d74bb0424ed
# ╠═a2c7f3a6-ec95-11ea-1be0-c526576beed0
# ╠═15cfbd92-ec9a-11ea-1e97-91f7950f46d3
# ╠═d9bae124-ec91-11ea-3ae1-d70593308047
# ╠═14c92a02-ec9a-11ea-3be5-5b3e6391b62f
# ╠═a3f9c21c-ec91-11ea-205f-7fd12a794760
# ╠═a6531910-ec90-11ea-02fd-c368cebc71fa
# ╠═20f13d40-ec9c-11ea-3e3a-4f7cdf11b68c
# ╠═b5c49d74-ec90-11ea-3802-8d86913d0d3d
# ╠═816bbe72-ec9a-11ea-3b5b-bde7e2a2ec9e
