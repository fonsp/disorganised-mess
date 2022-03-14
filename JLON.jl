### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# ╔═╡ 5989d2a9-0cca-4436-a8f2-c72af93def60
using PlutoTest

# ╔═╡ 0110d240-a25a-11ec-3107-818219612458
jlon(x) = string(x)

# ╔═╡ 103140df-c65c-400f-a3a8-3a3de5172ca9


# ╔═╡ 2ad0790a-a959-4593-a65a-a87f3ba01c1c
clean_type(x) = false

# ╔═╡ 27ac2972-4778-4502-a73e-0a17b6a65402
const ValueType = Union{String,Int64,Int32,Char,Float64,Float32,Bool}

# ╔═╡ a43f6214-110c-4236-b74a-ca8ba22aae82
check_isclean(x::ValueType) = true

# ╔═╡ a75688d2-14f9-4884-8990-64fb474466df
const CleanTypes = (:Any, :String, :Int64, :Int32, :Int16, :Int8, :UInt64, :UInt32, :UInt16, :UInt8, :Float64, :Float32, :Float128, :BigInt)

# ╔═╡ 48f279ec-8958-413c-911c-412d25b7e6a6
clean_type(x::Symbol) = x ∈ CleanTypes

# ╔═╡ cc704f78-7402-44e9-992d-a3fa8d1001a9
function check_isclean(e::Expr)
	h = e.head

	if h === :vect
		foreach(check_isclean, e.args)
	elseif h === :ref && clean_type(e.args[1])
		foreach(check_isclean, @view e.args[2:end])
	elseif h === :call && e.args[1] === :Dict
		for a in e.args[2:end]
			@assert Meta.isexpr(a, :call, 3)
			@assert a.args[1] === :(=>)
			check_isclean(a.args[2])
			check_isclean(a.args[3])
		end
	elseif h === :tuple
		if all(a -> Meta.isexpr(a, :(=), 2), e.args)
			for a in e.args
				@assert a.args[1] isa Symbol
				check_isclean(a.args[2])
			end
		else
			foreach(check_isclean, e.args)
		end
	else
		throw(ArgumentError("Invalid expression: $(sprint(dump, e))"))
	end
end

# ╔═╡ 20aa091c-54e8-43aa-9b04-682b68aaa9f9
function parse(s::String)
	e = Meta.parse(s)
	check_isclean(e)
	eval(e)
end

# ╔═╡ b28ff2a7-b274-4988-9799-080ea240a1f2
testy(x) = parse(jlon(x)) == x

# ╔═╡ bd362f77-3138-4e67-9602-f9c6aa00633f
testy([1,2,[3,4]])

# ╔═╡ 1db08370-ca03-403c-a600-a0bf9b716962
testy([1,2,(5,6)])

# ╔═╡ 9a683312-e769-4875-ba7f-be9187eb3736
testy(Dict(1=>2, 4=>5))

# ╔═╡ 63487075-a660-47b8-a7f4-a8e944831f54
testy((1,2,"three"))

# ╔═╡ 9a382df0-5537-4afb-a2c5-af0acc97e09d
testy((a=1,b=2,c="three"))

# ╔═╡ 5b02889d-f717-45aa-b748-d78f465c9184
testy((a=1.2,b=2,c="three"))

# ╔═╡ c18c7728-b6fb-4859-9dfa-71bf3144e2cb


# ╔═╡ 6bf8d1a5-fa31-42d5-a189-17e20d87f6be


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoTest = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"

[compat]
PlutoTest = "~0.2.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.PlutoTest]]
deps = ["HypertextLiteral", "InteractiveUtils", "Markdown", "Test"]
git-tree-sha1 = "17aa9b81106e661cffa1c4c36c17ee1c50a86eda"
uuid = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
version = "0.2.2"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
"""

# ╔═╡ Cell order:
# ╠═0110d240-a25a-11ec-3107-818219612458
# ╠═20aa091c-54e8-43aa-9b04-682b68aaa9f9
# ╟─103140df-c65c-400f-a3a8-3a3de5172ca9
# ╠═a43f6214-110c-4236-b74a-ca8ba22aae82
# ╠═b28ff2a7-b274-4988-9799-080ea240a1f2
# ╠═bd362f77-3138-4e67-9602-f9c6aa00633f
# ╠═1db08370-ca03-403c-a600-a0bf9b716962
# ╠═9a683312-e769-4875-ba7f-be9187eb3736
# ╠═63487075-a660-47b8-a7f4-a8e944831f54
# ╠═9a382df0-5537-4afb-a2c5-af0acc97e09d
# ╠═5b02889d-f717-45aa-b748-d78f465c9184
# ╠═2ad0790a-a959-4593-a65a-a87f3ba01c1c
# ╠═27ac2972-4778-4502-a73e-0a17b6a65402
# ╠═a75688d2-14f9-4884-8990-64fb474466df
# ╠═48f279ec-8958-413c-911c-412d25b7e6a6
# ╠═cc704f78-7402-44e9-992d-a3fa8d1001a9
# ╠═5989d2a9-0cca-4436-a8f2-c72af93def60
# ╠═c18c7728-b6fb-4859-9dfa-71bf3144e2cb
# ╠═6bf8d1a5-fa31-42d5-a189-17e20d87f6be
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
