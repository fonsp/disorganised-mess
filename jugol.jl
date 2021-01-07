### A Pluto.jl notebook ###
# v0.8.9

using Markdown

# ╔═╡ 9725e84e-976d-11ea-17e6-a1d7871d642d
using Julog

# ╔═╡ 46a330a4-9772-11ea-163a-bb5b630170da
using BenchmarkTools

# ╔═╡ 74524a6c-976d-11ea-08dc-5ffc1f73a903
import Pkg; Pkg.add("Julog")

# ╔═╡ c6f8454e-976f-11ea-25ec-2926681e68b3
import Pluto

# ╔═╡ 0513fa12-9770-11ea-3df6-b953aae02077
import Pluto: Notebook, Cell

# ╔═╡ c95f8aec-976f-11ea-34ec-e580d0ddbfaa
nb = Notebook(joinpath(tempdir(), "é🧡💛.jl"), [
        Cell("z = y"),
        Cell("v = u"),
        Cell("y = x"),
        Cell("x = w"),
        Cell("using Dates"),
        Cell("t = 1"),
        Cell("w = v"),
        Cell("u = t"),
    ])

# ╔═╡ 1ee26ea6-9770-11ea-1194-d34274d38dd7
Pluto.update_caches!(nb, nb.cells)

# ╔═╡ 2f0f4e18-9770-11ea-27aa-7f198c8f6c9e
nb.cells[1].symstate

# ╔═╡ a9261e9e-976d-11ea-038f-1738c07bd1db
@julog teacher(a, b)

# ╔═╡ 5726e51e-976e-11ea-1a37-29b54bcf19d6
function isprime(n)
	[1,n] == filter(1:n) do i
		n%i==0
	end
end

# ╔═╡ 7f9b610a-976e-11ea-2142-ed8a76fd7eee
isprime.(1:10)

# ╔═╡ 9346c1d4-976e-11ea-1c65-e58b502e67ad


# ╔═╡ 08adce84-976e-11ea-19ff-274cedac9a17
clauses = @julog [
	div(X) <<= (X % 3 == 0)
]

# ╔═╡ ea36b3ac-976e-11ea-1e26-03c4f0925e72
goals = @julog [
	div(X)
]

# ╔═╡ fd189634-976e-11ea-0215-818a089fd782
derivations(clauses,123)

# ╔═╡ 1f778e34-976e-11ea-26ff-1537665b6135
x = 1:5 |> collect

# ╔═╡ Cell order:
# ╠═74524a6c-976d-11ea-08dc-5ffc1f73a903
# ╠═9725e84e-976d-11ea-17e6-a1d7871d642d
# ╠═c6f8454e-976f-11ea-25ec-2926681e68b3
# ╠═0513fa12-9770-11ea-3df6-b953aae02077
# ╠═c95f8aec-976f-11ea-34ec-e580d0ddbfaa
# ╠═1ee26ea6-9770-11ea-1194-d34274d38dd7
# ╠═2f0f4e18-9770-11ea-27aa-7f198c8f6c9e
# ╠═a9261e9e-976d-11ea-038f-1738c07bd1db
# ╠═5726e51e-976e-11ea-1a37-29b54bcf19d6
# ╠═7f9b610a-976e-11ea-2142-ed8a76fd7eee
# ╠═9346c1d4-976e-11ea-1c65-e58b502e67ad
# ╠═08adce84-976e-11ea-19ff-274cedac9a17
# ╠═ea36b3ac-976e-11ea-1e26-03c4f0925e72
# ╠═fd189634-976e-11ea-0215-818a089fd782
# ╠═1f778e34-976e-11ea-26ff-1537665b6135
# ╠═46a330a4-9772-11ea-163a-bb5b630170da
