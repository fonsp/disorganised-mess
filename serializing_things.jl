### A Pluto.jl notebook ###
# v0.12.6

using Markdown
using InteractiveUtils

# ╔═╡ 4a62f5cc-1d04-11eb-191d-2919ce6919b4
using Plots

# ╔═╡ 721a95e0-1d07-11eb-210c-0f11b8b5f0e1
import Serialization

# ╔═╡ 45ff0a04-1d07-11eb-04b4-cd3d8010b5f0
struct Wow
	a
	b
end

# ╔═╡ b3ab9b28-1d0a-11eb-1ea0-5f34485c78ff
ss = Serialization.Serializer(stdout)

# ╔═╡ ee291e7e-1d0a-11eb-0857-c11f4544adca
Serialization.should_send_whole_type(ss, Wow)

# ╔═╡ 45e28632-1d09-11eb-00d2-ff6ce7a3a456
w = Wow(6, Wow(7,8))

# ╔═╡ 5bd72770-1d08-11eb-32db-a373b5e44c59
g(x) = x^2

# ╔═╡ aabd963a-1d08-11eb-3d0e-a97d4b6a876e
import Pkg

# ╔═╡ 59fd8ada-1d07-11eb-3382-fbd90daeffe5
p = plot(sin)

# ╔═╡ 9cc2f2ce-1d07-11eb-2d43-0b286a31ac9b
f = tempname()

# ╔═╡ bc2973ae-1d07-11eb-16cb-af12886981c1
s(x) = sprint(Serialization.serialize, x)

# ╔═╡ 17eff62a-1d0a-11eb-2b89-9f417c3d5ea8
s([1,2,3])

# ╔═╡ 507389e2-1d09-11eb-0bc3-05007c2a9c5e
s(w)

# ╔═╡ 564eb1ec-1d08-11eb-17c7-d972f8383748
s(g)

# ╔═╡ c3e01e66-1d07-11eb-094f-01019f5b9e5f
s(p)

# ╔═╡ e2a31a94-1d07-11eb-3362-6bd7155756c8
sd(x) = let
	f = tempname()
	Serialization.serialize(f, x)
	Serialization.deserialize(f)
end

# ╔═╡ f587b516-1d07-11eb-25ce-bde7c2c73975
sd(p)

# ╔═╡ 5e1772c0-1d07-11eb-0d75-dfa361a66ea9
# Serialization.serialize(f, w)

# ╔═╡ ac2c041c-1d07-11eb-0caf-f1f90e7f5281
Serialization.deserialize(f)

# ╔═╡ Cell order:
# ╠═4a62f5cc-1d04-11eb-191d-2919ce6919b4
# ╠═721a95e0-1d07-11eb-210c-0f11b8b5f0e1
# ╠═45ff0a04-1d07-11eb-04b4-cd3d8010b5f0
# ╠═b3ab9b28-1d0a-11eb-1ea0-5f34485c78ff
# ╠═ee291e7e-1d0a-11eb-0857-c11f4544adca
# ╠═17eff62a-1d0a-11eb-2b89-9f417c3d5ea8
# ╠═45e28632-1d09-11eb-00d2-ff6ce7a3a456
# ╠═507389e2-1d09-11eb-0bc3-05007c2a9c5e
# ╠═5bd72770-1d08-11eb-32db-a373b5e44c59
# ╠═564eb1ec-1d08-11eb-17c7-d972f8383748
# ╠═c3e01e66-1d07-11eb-094f-01019f5b9e5f
# ╠═aabd963a-1d08-11eb-3d0e-a97d4b6a876e
# ╠═f587b516-1d07-11eb-25ce-bde7c2c73975
# ╠═59fd8ada-1d07-11eb-3382-fbd90daeffe5
# ╠═9cc2f2ce-1d07-11eb-2d43-0b286a31ac9b
# ╠═bc2973ae-1d07-11eb-16cb-af12886981c1
# ╠═e2a31a94-1d07-11eb-3362-6bd7155756c8
# ╠═5e1772c0-1d07-11eb-0d75-dfa361a66ea9
# ╠═ac2c041c-1d07-11eb-0caf-f1f90e7f5281
