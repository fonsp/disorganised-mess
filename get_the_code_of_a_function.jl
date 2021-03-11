### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ eb104349-c40c-455a-b1ac-210ba6ca7f3d
using PlutoUI

# ╔═╡ c9e5ebb4-76c6-11eb-382f-2ff8ff0506f1
function hello(x)
	y = x
	123
	y
end

# ╔═╡ 0ee688a9-c956-4ae9-aa8e-365fcbc6c7a1
contains_head(expr::Any, head::Symbol) = false

# ╔═╡ a8150a25-95d4-4252-b8c5-958955be3e41
contains_head(expr::Expr, head::Symbol) = if expr.head === head
	true
else
	any(contains_head.(expr.args, [head]))
end

# ╔═╡ 5457ee47-f4bb-43b6-90f0-db310957dc2a
justthecellid(s) = split(String(s), "#==#")[2]

# ╔═╡ 560bb8e9-5b08-45b9-8c8b-62cacdcf35d2
justthefilename(s) = split(String(s), "#==#")[1]

# ╔═╡ b1c74b41-a1c2-415f-b064-e51e002deef5
function get_expr_for(m::Method)
	notebookcode = read(justthefilename(m.file), String)
	method_cellid = justthecellid(m.file)
	all_cells_kindof = split(notebookcode, "# ╔═╡ ")
	m_cell_code = all_cells_kindof[findfirst(startswith(method_cellid), all_cells_kindof)]
	method_code_raw = strip(split(m_cell_code, method_cellid)[2])
	method_code_expr = Meta.parse(method_code_raw)
end

# ╔═╡ dd269e8c-9696-4843-bc2b-7b73d2ceec38
method_code_expr = get_expr_for(@which hello(123))

# ╔═╡ 03dac5f8-645b-4bd8-b371-161cd9899f8a
if contains_head(method_code_expr, :while)
	md"This isn't C++!!! 🤬"
else
	md"Welcome to Julia!"
end

# ╔═╡ Cell order:
# ╠═c9e5ebb4-76c6-11eb-382f-2ff8ff0506f1
# ╟─03dac5f8-645b-4bd8-b371-161cd9899f8a
# ╠═dd269e8c-9696-4843-bc2b-7b73d2ceec38
# ╠═b1c74b41-a1c2-415f-b064-e51e002deef5
# ╠═eb104349-c40c-455a-b1ac-210ba6ca7f3d
# ╠═0ee688a9-c956-4ae9-aa8e-365fcbc6c7a1
# ╠═a8150a25-95d4-4252-b8c5-958955be3e41
# ╠═5457ee47-f4bb-43b6-90f0-db310957dc2a
# ╠═560bb8e9-5b08-45b9-8c8b-62cacdcf35d2
