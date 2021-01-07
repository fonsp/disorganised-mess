### A Pluto.jl notebook ###
# v0.12.4

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

# ╔═╡ ce484f8c-1551-11eb-17b3-9b7ad6077e88
begin
	import Pkg
	Pkg.add("Colors")
	using Colors
end

# ╔═╡ 44967d3a-152c-11eb-027d-999b5c6e5f54
import REPL.REPLCompletions: completions, complete_path, completion_text, Completion, ModuleCompletion

# ╔═╡ 20e86bf6-152e-11eb-11e8-610104f47a1e
import REPL.REPLCompletions

# ╔═╡ f1715042-1530-11eb-1e15-433738e5c8a5
begin
	description(x::Function) = "Function"
	description(x::Number) = "Number"
	description(x::AbstractString) = "String"
	description(x::Module) = "Module"
	description(x::AbstractArray) = "Array"
	description(x::Any) = "Any"
end

# ╔═╡ 0881116e-1531-11eb-31cf-d1e64b47c83b
names(@__MODULE__, all=false, imported=true)

# ╔═╡ 5f04c3d8-1544-11eb-333a-e529e8ae0edf
f((a,b)::Tuple{String,Int}) = a

# ╔═╡ 2c4d1ccc-1537-11eb-1c26-9b525de16668
startswith("nameof(m)", "workspace")

# ╔═╡ 8f1f2ca2-1530-11eb-2a20-efa9407f0b06


# ╔═╡ 63634d86-1536-11eb-3e84-ad0a6bae118f
import LinearAlgebra

# ╔═╡ a5945186-1537-11eb-11a9-29e2177cbfb5
import PlutoUI

# ╔═╡ b664511e-1537-11eb-1006-332efc9674f5
PlutoUI.Button.mutable

# ╔═╡ 1ab78a00-1538-11eb-3890-21502dc486c5
sort(zip([1,2], [3,4]))

# ╔═╡ 611b1fb2-152d-11eb-2619-7f3e520489c7
aaa = 123

# ╔═╡ 61e696b8-1552-11eb-190b-3bbeca76acbb
Pkg.pkg"a"

# ╔═╡ 169c2968-152d-11eb-35ae-fd06b4a3aca6
@bind query html"<input>"

# ╔═╡ 2f62720e-152d-11eb-096e-07e2b19da175
names

# ╔═╡ 6de2b684-152c-11eb-1769-1d2a950984d5
cs = completions(query, lastindex(query), @__MODULE__)[1]

# ╔═╡ 67ca1ade-1544-11eb-2218-f771deb88249
f(("a",3))

# ╔═╡ 1094d78a-152e-11eb-241a-0b22fcd7009b
modulecs = filter(c -> c isa REPLCompletions.ModuleCompletion, cs) 

# ╔═╡ 4ff8cd8c-152e-11eb-2941-db62cc7746da
completed_modules = Set(c.parent for c in cs if c isa REPLCompletions.ModuleCompletion)

# ╔═╡ 6ec47090-152e-11eb-24fd-434e63c415fa
completed_modules_exports = Dict(m => string.(names(m, all=false, imported=false)) for m in completed_modules)

# ╔═╡ ba9f0b24-152e-11eb-281a-1bdd3f9dd50c
filter(modulecs) do c
	c.mod ∈ completed_modules_exports[c.parent]
end

# ╔═╡ 9eae8c24-152d-11eb-33ac-9de743392abe
fav = last(cs)

# ╔═╡ a58b51ee-152d-11eb-2ba2-29e95e3e7a42
function completions_exported(cs::Vector{<:Completion})
    completed_modules = Set(c.parent for c in cs if c isa ModuleCompletion)
    completed_modules_exports = Dict(m => string.(names(m, all=false, imported=false)) for m in completed_modules)

    map(cs) do c
        c isa ModuleCompletion && c.mod ∈ completed_modules_exports[c.parent]
    end
end

# ╔═╡ 37ae77fa-1532-11eb-1e5b-9558986e1f98
completions_exported(cs)

# ╔═╡ f88f1c1e-152c-11eb-02ef-0be83053aa3e
c_texts = completion_text.(cs)

# ╔═╡ 5d64e682-153c-11eb-1209-c1f3a21d2ea6


# ╔═╡ 550dcdd2-153c-11eb-0038-770183981148
hashes = Float64.(hash.(c_texts)) ./ Float64(typemax(UInt))

# ╔═╡ eb8dd850-1551-11eb-2a8d-754a0c3f31f6
hcat([HSL(x*360, 0.5, 0.5) for x in hashes])'

# ╔═╡ c345dcaa-152c-11eb-23ec-21e0736c4cd8
first("α") |> islowercase

# ╔═╡ b7dea9c8-152c-11eb-1584-b9f79b39913b
function completion_priority(s::String)
	c = first(s)
	if islowercase(c)
		1
	elseif isuppercase(c)
		2
	else
		3
	end
end

# ╔═╡ 8bbcb9f2-152c-11eb-293a-8373413f87ac
sort(c_texts, alg=MergeSort, by=completion_priority)

# ╔═╡ 6914f7f2-152c-11eb-03f4-a7e1c204a0ec
LinearAlgebra.

# ╔═╡ c3a52510-1528-11eb-20ee-8f6432f8b29c
md"""
# odl
"""

# ╔═╡ ab29c252-1521-11eb-311e-9f231ee1ee8a
ffox

165 requests
2.67 MB / 2.67 MB transferred
Finish: 27.57 s
DOMContentLoaded: 2.25 s
load: 7.46 s


# ╔═╡ 6e015e12-1528-11eb-06bb-3d1426c79b6b
chrome

168 requests
224 kB transferred
4.3 MB resources
Finish: 1.60 s
DOMContentLoaded: 1.21 s
Load: 1.41 s

# ╔═╡ 896b9dac-1528-11eb-2e6e-5f41eb8568d1
md"""
## without cache
"""

# ╔═╡ c7d6b02c-1528-11eb-00f2-673b9de5f95c
ffox

171 requests
4.12 MB / 4.13 MB transferred
Finish: 13.84 s
DOMContentLoaded: 1.45 s
load: 14.20 s

# ╔═╡ d79236d0-1528-11eb-20d8-21a0fefc1e7e
chrome

173 requests
2.6 MB transferred
4.3 MB resources
Finish: 21.49 s
DOMContentLoaded: 1.36 s
Load: 1.55 s

# ╔═╡ edff6730-1528-11eb-1982-1770d711d7dd
md"""
# new
"""

# ╔═╡ f14a32f8-1528-11eb-3639-ebfdf1fd8233
ffox

75 requests
2.68 MB / 2.68 MB transferred
Finish: 5.55 s
DOMContentLoaded: 1.60 s
load: 5.56 s

# ╔═╡ 6ee5d0de-1529-11eb-3c68-3fa2692bafa3
chrome

81 requests
224 kB transferred
4.3 MB resources
Finish: 1.38 s
DOMContentLoaded: 822 ms
Load: 963 ms

# ╔═╡ 5ff858c8-152a-11eb-30e2-573c9d255b69
md"""
## no cache
"""

# ╔═╡ 61cbd86e-152a-11eb-0fd8-699422160537
ffox

84 requests
4.14 MB / 4.14 MB transferred
Finish: 7.13 s
DOMContentLoaded: 1.58 s
load: 7.33 s

# ╔═╡ 6ac2c34c-152a-11eb-3e4a-257c105017b2
chrome

81 requests
2.6 MB transferred
4.3 MB resources
Finish: 2.64 s
DOMContentLoaded: 1.57 s
Load: 1.84 s

# ╔═╡ d4fc6564-1530-11eb-149d-f5e890291971
f() = [try getfield(c.parent, Symbol(c.mod)) catch; end for c in cs]

# ╔═╡ 97a7312e-152d-11eb-1edf-7fcd96388e2e
f() = [try description(getfield(c.parent, Symbol(c.mod))) catch; "" end for c in cs]

# ╔═╡ Cell order:
# ╠═44967d3a-152c-11eb-027d-999b5c6e5f54
# ╠═20e86bf6-152e-11eb-11e8-610104f47a1e
# ╠═f1715042-1530-11eb-1e15-433738e5c8a5
# ╠═0881116e-1531-11eb-31cf-d1e64b47c83b
# ╠═5f04c3d8-1544-11eb-333a-e529e8ae0edf
# ╠═67ca1ade-1544-11eb-2218-f771deb88249
# ╠═2c4d1ccc-1537-11eb-1c26-9b525de16668
# ╠═97a7312e-152d-11eb-1edf-7fcd96388e2e
# ╠═8f1f2ca2-1530-11eb-2a20-efa9407f0b06
# ╠═63634d86-1536-11eb-3e84-ad0a6bae118f
# ╠═a5945186-1537-11eb-11a9-29e2177cbfb5
# ╠═b664511e-1537-11eb-1006-332efc9674f5
# ╠═1ab78a00-1538-11eb-3890-21502dc486c5
# ╠═d4fc6564-1530-11eb-149d-f5e890291971
# ╠═611b1fb2-152d-11eb-2619-7f3e520489c7
# ╠═61e696b8-1552-11eb-190b-3bbeca76acbb
# ╠═169c2968-152d-11eb-35ae-fd06b4a3aca6
# ╟─eb8dd850-1551-11eb-2a8d-754a0c3f31f6
# ╠═2f62720e-152d-11eb-096e-07e2b19da175
# ╠═6de2b684-152c-11eb-1769-1d2a950984d5
# ╠═1094d78a-152e-11eb-241a-0b22fcd7009b
# ╠═4ff8cd8c-152e-11eb-2941-db62cc7746da
# ╠═6ec47090-152e-11eb-24fd-434e63c415fa
# ╠═ba9f0b24-152e-11eb-281a-1bdd3f9dd50c
# ╠═9eae8c24-152d-11eb-33ac-9de743392abe
# ╠═37ae77fa-1532-11eb-1e5b-9558986e1f98
# ╠═a58b51ee-152d-11eb-2ba2-29e95e3e7a42
# ╠═f88f1c1e-152c-11eb-02ef-0be83053aa3e
# ╠═5d64e682-153c-11eb-1209-c1f3a21d2ea6
# ╠═ce484f8c-1551-11eb-17b3-9b7ad6077e88
# ╠═550dcdd2-153c-11eb-0038-770183981148
# ╠═c345dcaa-152c-11eb-23ec-21e0736c4cd8
# ╠═b7dea9c8-152c-11eb-1584-b9f79b39913b
# ╠═8bbcb9f2-152c-11eb-293a-8373413f87ac
# ╠═6914f7f2-152c-11eb-03f4-a7e1c204a0ec
# ╠═c3a52510-1528-11eb-20ee-8f6432f8b29c
# ╠═ab29c252-1521-11eb-311e-9f231ee1ee8a
# ╠═6e015e12-1528-11eb-06bb-3d1426c79b6b
# ╠═896b9dac-1528-11eb-2e6e-5f41eb8568d1
# ╠═c7d6b02c-1528-11eb-00f2-673b9de5f95c
# ╠═d79236d0-1528-11eb-20d8-21a0fefc1e7e
# ╠═edff6730-1528-11eb-1982-1770d711d7dd
# ╠═f14a32f8-1528-11eb-3639-ebfdf1fd8233
# ╠═6ee5d0de-1529-11eb-3c68-3fa2692bafa3
# ╠═5ff858c8-152a-11eb-30e2-573c9d255b69
# ╠═61cbd86e-152a-11eb-0fd8-699422160537
# ╠═6ac2c34c-152a-11eb-3e4a-257c105017b2
