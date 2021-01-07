### A Pluto.jl notebook ###
# v0.12.7

using Markdown
using InteractiveUtils

# ╔═╡ bddb8716-2354-11eb-0743-9b236c63edc6
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add("CSV")
	using CSV
end

# ╔═╡ f7277994-2354-11eb-25ad-258ab22ab784
csv = IOBuffer("""name,height,age
       Alice,1.60,21
       Bob,1.83,40
       Claire,1.75,31
       David,1.50,25
       Edith,1.68,30
       """)

# ╔═╡ 4852f42e-2355-11eb-23fb-17318881a7cc
data = CSV.read(csv)

# ╔═╡ e64ac644-2354-11eb-2e30-3bfe5ea599e5
t1[1]

# ╔═╡ e8d6b6e8-2354-11eb-1a4a-a5ba2fd37a71


# ╔═╡ Cell order:
# ╠═bddb8716-2354-11eb-0743-9b236c63edc6
# ╠═f7277994-2354-11eb-25ad-258ab22ab784
# ╠═4852f42e-2355-11eb-23fb-17318881a7cc
# ╠═e64ac644-2354-11eb-2e30-3bfe5ea599e5
# ╠═e8d6b6e8-2354-11eb-1a4a-a5ba2fd37a71
