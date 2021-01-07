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

# ╔═╡ 215bc950-1517-11eb-3576-f9b6e8d16cac
begin
	using Revise
	using PlutoUI
	using DataFrames
end

# ╔═╡ 421f16b6-1516-11eb-2821-dda502c6487f
x = rand(1:99, 100,100)

# ╔═╡ 0635b8e8-156e-11eb-2099-bf33cdcfc9f4
df = DataFrame(x)

# ╔═╡ f62ddf64-156d-11eb-096d-f5a6d4ee67c3
PlutoUI.WithIOContext(df, displaysize=(99999,99999))

# ╔═╡ 87b6ff6e-151f-11eb-24c1-3fef779a161a
md"""
asdf

# asdf

```julia
asdf
```

```
asdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfa|>sdfvv
```


"""

# ╔═╡ 539be880-151e-11eb-09d6-690dc98b804a
[md"# asdf", 123, x]

# ╔═╡ dbf62b4a-151f-11eb-39c2-41d7352bb5c5
"|>"

# ╔═╡ d45229e8-151f-11eb-0709-8318b935c661
["|>"]

# ╔═╡ 2fd4dc54-1521-11eb-29d4-5de9ed8a5892
@bind n Slider(1:99)

# ╔═╡ 08177e3a-151c-11eb-350e-d3820a685ebd
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx = x[:,1:n]

# ╔═╡ e3420412-151c-11eb-07bc-0f7493dd901e
Float16(pi)

# ╔═╡ e5865a34-151c-11eb-2323-4b175e14fd05
Float32(pi)

# ╔═╡ ea2f4d16-151c-11eb-3be4-55ca85769d8d
Float64(pi)

# ╔═╡ ecfdf146-151c-11eb-05be-c797ffb54534
Any[Float16(pi), Float32(pi), Float64(pi)]

# ╔═╡ 0cc00dc0-151d-11eb-142a-4b8acc6a33cb
x[1,:]

# ╔═╡ bbb0187a-151f-11eb-23fe-ad0b95abf1af
-1 |> sqrt

# ╔═╡ 5315d7f2-151b-11eb-30c8-979272106c03
PlutoUI.WithIOContext(x, :compact => true)

# ╔═╡ d2692aa6-1519-11eb-3943-2fa87dde3c98
f(x...) = x

# ╔═╡ 153c2b08-151a-11eb-223a-fb87b88991c2
f(:a => 2, :b => 3)

# ╔═╡ 2483a7a0-151a-11eb-365f-2373d7d3c496
f(;a = 2, b = 3)

# ╔═╡ 2b1db6bc-151a-11eb-1c3f-6f698bf00642
f(a = 2, b = 3)

# ╔═╡ 329bcbc2-151a-11eb-0ce6-f933c15efba7
g(x...; y...) = [x...,y...]

# ╔═╡ 3aa7fa2a-151a-11eb-178c-897238316b87
g(:a => 2)

# ╔═╡ 3f87d13c-151a-11eb-2b86-49404ecd0ad2
g(a = 2, b = 3)

# ╔═╡ 79e9c176-151a-11eb-1224-4504877accea
h(a, b...; c...) = [b..., c...]

# ╔═╡ 854f4042-151a-11eb-13b1-71f665818e88
h(1, 2=>3)

# ╔═╡ fdd66f6c-1516-11eb-06a9-6371e3e64ce3
begin
	struct WithIOContext
		x
		context_properties
	end
	WithIOContext(x, props::Pair...; moreprops...) = WithIOContext(x, [props..., moreprops...])
end

# ╔═╡ cc8395ce-1517-11eb-1ab1-a5bcc9aac90c
function Base.show(io::IO, m::MIME"text/plain", w::WithIOContext)
	Base.show(IOContext(io, w.context_properties...), m, w.x)
end

# ╔═╡ 37dbe416-1518-11eb-348f-bfb890ad3276
WithIOContext(x, :a => false, compact = true, cols=3, displaysize=(10,20))

# ╔═╡ 57eb86c6-1518-11eb-040b-ed690d827003
WithIOContext(x, :compact => false)

# ╔═╡ Cell order:
# ╠═f62ddf64-156d-11eb-096d-f5a6d4ee67c3
# ╠═0635b8e8-156e-11eb-2099-bf33cdcfc9f4
# ╠═421f16b6-1516-11eb-2821-dda502c6487f
# ╠═87b6ff6e-151f-11eb-24c1-3fef779a161a
# ╠═539be880-151e-11eb-09d6-690dc98b804a
# ╠═dbf62b4a-151f-11eb-39c2-41d7352bb5c5
# ╠═d45229e8-151f-11eb-0709-8318b935c661
# ╠═08177e3a-151c-11eb-350e-d3820a685ebd
# ╠═2fd4dc54-1521-11eb-29d4-5de9ed8a5892
# ╠═215bc950-1517-11eb-3576-f9b6e8d16cac
# ╠═e3420412-151c-11eb-07bc-0f7493dd901e
# ╠═e5865a34-151c-11eb-2323-4b175e14fd05
# ╠═ea2f4d16-151c-11eb-3be4-55ca85769d8d
# ╠═ecfdf146-151c-11eb-05be-c797ffb54534
# ╠═0cc00dc0-151d-11eb-142a-4b8acc6a33cb
# ╠═bbb0187a-151f-11eb-23fe-ad0b95abf1af
# ╠═5315d7f2-151b-11eb-30c8-979272106c03
# ╠═d2692aa6-1519-11eb-3943-2fa87dde3c98
# ╠═153c2b08-151a-11eb-223a-fb87b88991c2
# ╠═2483a7a0-151a-11eb-365f-2373d7d3c496
# ╠═2b1db6bc-151a-11eb-1c3f-6f698bf00642
# ╠═329bcbc2-151a-11eb-0ce6-f933c15efba7
# ╠═3aa7fa2a-151a-11eb-178c-897238316b87
# ╠═3f87d13c-151a-11eb-2b86-49404ecd0ad2
# ╠═79e9c176-151a-11eb-1224-4504877accea
# ╠═854f4042-151a-11eb-13b1-71f665818e88
# ╠═fdd66f6c-1516-11eb-06a9-6371e3e64ce3
# ╠═cc8395ce-1517-11eb-1ab1-a5bcc9aac90c
# ╠═37dbe416-1518-11eb-348f-bfb890ad3276
# ╠═57eb86c6-1518-11eb-040b-ed690d827003
