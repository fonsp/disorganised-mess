### A Pluto.jl notebook ###
# v0.6.3
# ╔═╡ 993ca6cc-7d07-11ea-33da-43e5dbbcfa60
md"Hold ctrl+enter:"

# ╔═╡ fc643608-7d06-11ea-3ab7-8d15d24641ce
Distributed.remotecall_eval(Main, 1, :(Main.Pluto.WorkspaceManager.moduleworkspace_count))

# ╔═╡ 765ed38c-7d07-11ea-3628-6bc271c03011
const i = parse(Int64, string(Main.PlutoRunner.current_module)[15:end])

# ╔═╡ e84f8d08-7d07-11ea-0e54-099825151525
md"On `0.6.1`: **$(150/5)** new modules per second. Locked on framerate?"

# ╔═╡ 0a0ac598-7d08-11ea-0ecd-7d3ae8cea840
Distributed.remotecall_eval(Main, 1, :(sum([sin(j) for j in 1:10])))

# ╔═╡ 825cd5b6-7d08-11ea-2815-474c90141318
sum([sin(j) for j in 1:10])

# ╔═╡ e8661e36-7daf-11ea-2b5a-f9cb2eb7b204
module x end

# ╔═╡ f012457a-7d06-11ea-13cb-0364a1c8c121
using Distributed

# ╔═╡ 43dcd63a-7db2-11ea-2144-f1db498c27a8
using Pluto

# ╔═╡ 4bedce02-7db2-11ea-0ec0-35a7efd9c331
Pluto.run(1235)

# ╔═╡ Cell order:
# ╠═f012457a-7d06-11ea-13cb-0364a1c8c121
# ╟─993ca6cc-7d07-11ea-33da-43e5dbbcfa60
# ╠═fc643608-7d06-11ea-3ab7-8d15d24641ce
# ╠═765ed38c-7d07-11ea-3628-6bc271c03011
# ╠═e84f8d08-7d07-11ea-0e54-099825151525
# ╠═0a0ac598-7d08-11ea-0ecd-7d3ae8cea840
# ╠═825cd5b6-7d08-11ea-2815-474c90141318
# ╠═e8661e36-7daf-11ea-2b5a-f9cb2eb7b204
# ╠═43dcd63a-7db2-11ea-2144-f1db498c27a8
# ╠═4bedce02-7db2-11ea-0ec0-35a7efd9c331
