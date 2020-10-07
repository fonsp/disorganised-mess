### A Pluto.jl notebook ###
# v0.12.0

using Markdown
using InteractiveUtils

# ╔═╡ 51bb7074-08dc-11eb-121b-015c9c08d74e
function local_ingredients(path::String)
	# this is from the Julia source code (evalfile in base/loading.jl)
	# but with the modification that it returns the module instead of the last object
	name = Symbol(basename(path))
	m = Module(name)
	Core.eval(m,
        Expr(:toplevel,
             :(eval(x) = $(Expr(:core, :eval))($name, x)),
             :(include(x) = $(Expr(:top, :include))($name, x)),
             :(include(mapexpr::Function, x) = $(Expr(:top, :include))(mapexpr, $name, x)),
             :(include($path))))
	m
end

# ╔═╡ 7ef95874-08dc-11eb-1b8c-c1a6b8412ddf
function ingredients(url::String)
	try
		local_ingredients(download(url))
	catch e
		if !startswith(url, "http")
			throw(ArgumentError("Not a URL. Use `ingredients(path=\"$(url)\")` for local files instead."))
		else
			rethrow(e)
		end
	end
end

# ╔═╡ b40daa62-08dc-11eb-3a53-b5d94f732889
function ingredients(;
		url::Union{String,Nothing}=nothing, 
		path::Union{String,Nothing}=nothing)
	
	if url === nothing && path !== nothing
		local_ingredients(path)
	elseif url !== nothing && path === nothing
		local_ingredients(download(url))
	else
		throw(ArgumentError("""Use `ingredients(url="...")` or `ingredients(path="...")`."""))
	end
end

# ╔═╡ 0055a89c-08de-11eb-112a-5fd7983694ad
a2 = ingredients("unicode.jl")

# ╔═╡ 4841ed1c-08dd-11eb-3174-1be594eef903
a = ingredients(path="unicode.jl")

# ╔═╡ 7ae01e54-08dd-11eb-0b01-759f923ad6da
a.💩

# ╔═╡ 885b1df2-08dd-11eb-22de-37bc45197a13
b = ingredients("https://raw.githubusercontent.com/fonsp/disorganised-mess/master/unicode.jl")

# ╔═╡ 9f593720-08dd-11eb-1ba5-b37adc1d8095
b.💩

# ╔═╡ Cell order:
# ╠═51bb7074-08dc-11eb-121b-015c9c08d74e
# ╠═7ef95874-08dc-11eb-1b8c-c1a6b8412ddf
# ╠═b40daa62-08dc-11eb-3a53-b5d94f732889
# ╠═0055a89c-08de-11eb-112a-5fd7983694ad
# ╠═4841ed1c-08dd-11eb-3174-1be594eef903
# ╠═7ae01e54-08dd-11eb-0b01-759f923ad6da
# ╠═885b1df2-08dd-11eb-22de-37bc45197a13
# ╠═9f593720-08dd-11eb-1ba5-b37adc1d8095
