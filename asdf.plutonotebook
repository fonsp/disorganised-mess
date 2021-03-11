### A Pluto.jl notebook ###
# v0.12.6

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

# ╔═╡ 93136964-93c0-11ea-3da9-4d6e11b49b1e
using Distributed

# ╔═╡ a5e270ea-87c6-11ea-32e4-a5c92c2543e3
struct Wow
	x
	y
end

# ╔═╡ 6de2fdec-9075-11ea-3a39-176a725c1c38
which(show, (IO, MIME"text/plain", Wow))

# ╔═╡ d6bb60b0-8fc4-11ea-1a96-6dffb769ac8d
Base.show(io::IO, ::MIME"text/plain", w::Wow) = print(io, "wowie")

# ╔═╡ bc9b0846-8fe7-11ea-36be-95f4d5678d9f
ww = md"";

# ╔═╡ 5a786a52-8fca-11ea-16a1-f336e0d09343
s = randn((3,3))

# ╔═╡ 610988be-87cb-11ea-1158-e926582f646e
w = Wow(1,2)

# ╔═╡ 2397a42c-8fe9-11ea-3613-f95c0f69d22c
md"a"

# ╔═╡ b0dba8fc-87c6-11ea-3f48-03e3076f0cdf
w

# ╔═╡ b5941dcc-87c6-11ea-070d-2beb077404b4
w isa Base.AbstractDict

# ╔═╡ 8b8affe4-93c1-11ea-13e9-35f812ea2a24
include_dependency("potato")

# ╔═╡ 9749bdd8-93c0-11ea-218e-bb3c8aca84a6
Distributed.remotecall_eval(Main, 1, :(VersionNumber(Pluto.Pkg.TOML.parsefile(joinpath(Pluto.PKG_ROOT_DIR, "Project.toml"))["version"])))

# ╔═╡ e46bc5fe-93c0-11ea-3a28-a57866436552
Distributed.remotecall_eval(Main, 1, :(Pluto.PLUTO_VERSION))

# ╔═╡ 0f1736b8-87c7-11ea-2b9b-a7f8aad9800a
[1] |> Base.nfields, w|> Base.sizeof

# ╔═╡ e5a5561c-870c-11ea-27be-a51a15915e64
x = [1, [2,3,4], 620:800...]

# ╔═╡ cb18b686-8fd8-11ea-066c-bd467edfc009
x

# ╔═╡ a53ebb96-8ff3-11ea-3a49-cdce8c158c41
Dict(:a => 1, :b => ["hoi", "merlino"])

# ╔═╡ 8984fd16-8fe4-11ea-1ff9-d5cd8f6fe0b0
m=md"asasdf $x+1$ asdfasdf".content

# ╔═╡ e8d20214-8fe4-11ea-07cf-0970e4d1b8f0
sprint(Markdown.tohtml, x)

# ╔═╡ 8cbdafb6-8fe7-11ea-2e1b-cf6781de9987
md"A $([1,2,3]) D"

# ╔═╡ e69caef4-8fe4-11ea-33e7-2b8e7fe4ad38
#=begin
	import Markdown: html, htmlinline, Paragraph, withtag, tohtml
	function html(io::IO, md::Paragraph)
		withtag(io, :p) do
			for x in md.content
				htmlinline(io, x)
			end
		end
	end
	htmlinline(io::IO, content::Vector) = tohtml(io, content)
end=#

# ╔═╡ 45b18414-8fe5-11ea-379d-3714e2a5e571
begin
	1
	2
end

# ╔═╡ 2928da6e-8fee-11ea-1af2-81d68a8ed90a
#=begin
	import Markdown: html, tohtml, withtag
	function tohtml(io::IO, m::MIME"text/html", x)
		withtag(io, :DIV) do
			show(io, m, x)
		end
	end
end=#

# ╔═╡ 267a8fbe-8fef-11ea-0cea-5febb0c16422
occursin.(["a"], ["aa", "bb"])

# ╔═╡ d87f1c8e-8fef-11ea-3196-53ba5908144b
sqrt(1...)

# ╔═╡ b51971a8-8fe1-11ea-1b66-95a173a7c935
md"asdf "

# ╔═╡ e8e983ae-870f-11ea-27b8-a7fbc1361d6b
x

# ╔═╡ 044a825a-8fdb-11ea-29bb-1d0f0e028488
Dict([i =>i for i in 1:100])

# ╔═╡ ad31516a-8fdf-11ea-0803-9f5b1a9fd9d8
Vector{UInt8}() isa String

# ╔═╡ 2457311c-870f-11ea-397e-3120cd3e0b74
r = Set([123,54,1,2,23,23,21,42,34234,4]) |> Base.axes1

# ╔═╡ 47715e08-8fba-11ea-1982-99fce343b41b
i = md"![asdf](https://fonsp.com/img/doggoSmall.jpg?raw=true)"

# ╔═╡ 503d8582-8fc3-11ea-3934-fb7a4f2a3473
doggos = [i,i,i, @bind p html"<input type='range' />"]

# ╔═╡ 6dd4dbb4-8fe8-11ea-0d3e-4d874391e9e1
p

# ╔═╡ b0d52d76-8721-11ea-0d79-d3cc67a891d5
good_boys = Dict(:title => md"# Hello world", :img => i) #:names => ["Hannes", "Floep"]

# ╔═╡ ad19ec44-8fe1-11ea-11a9-73b10aa46388
md"asdf $(good_boys) asd"

# ╔═╡ 69c2076a-8feb-11ea-143a-cfec10821e8e
repr(MIME"text/html"(), md"asdf $(good_boys) asd")

# ╔═╡ eed501f8-9076-11ea-3002-a5ec32d6dccb
md"asdf $(x) asdf"

# ╔═╡ cb62a20c-9074-11ea-3fb2-0d197fe87508
md"I like [_dogs_](dogs.org) **and** cats!".content

# ╔═╡ f8c7970c-9074-11ea-36b4-0927aaed5682
html"<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>"

# ╔═╡ c06927b6-8fd6-11ea-3da4-fd6080e71b37
ENV

# ╔═╡ 52a70206-8fd7-11ea-3c72-7d6154eae359
zip([1,2],[3,4]) |> collect

# ╔═╡ e0508e70-870c-11ea-15a0-2504ae18dad8
#=begin
	import Base: show
	
	function show_richest_textmime(io::IO, x::Any)
		if showable(MIME("text/html"), x)
			show(io, MIME("text/html"), x)
		else
			show(io, MIME("text/plain"), x)
		end
	end
	
	function show_array_row(io::IO, pair::Tuple)
		i, el = pair
		print(io, "<r><i>", i, "</i><e>")
		show_richest_textmime(io, el)
		print(io, "</e></r>")
	end
	
	function show_dict_row(io::IO, pair::Pair)
		k, el = pair
		print(io, "<r><k>")
		show_richest_textmime(io, k)
		print(io, "</k><e>")
		show_richest_textmime(io, el)
		print(io, "</e></r>")
	end
	
	function show(io::IO, ::MIME"text/html", x::Array{<:Any, 1})
		print(io, """<jltree class="collapsed" onclick="onjltreeclick(this, event)">""")
		print(io, eltype(x))
		print(io, "<jlarray>")
		if length(x) <= tree_display_limit
			show_array_row.([io], enumerate(x))
		else
			show_array_row.([io], enumerate(x[1:tree_display_limit]))
			
			print(io, "<r><more></more></r>")
			
			from_end = tree_display_limit > 20 ? 10 : 1
			indices = 1+length(x)-from_end:length(x)
			show_array_row.([io], zip(indices, x[indices]))
		end
		
		print(io, "</jlarray>")
		print(io, "</jltree>")
	end
	
	function show(io::IO, ::MIME"text/html", x::Dict{<:Any, <:Any})
		print(io, """<jltree class="collapsed" onclick="onjltreeclick(this, event)">""")
		print(io, "Dict")
		print(io, "<jldict>")
		row_index = 1
		for pair in x
			show_dict_row(io, pair)
			if row_index == tree_display_limit
				print(io, "<r><more></more></r>")
				break
			end
			row_index += 1
		end
		
		print(io, "</jldict>")
		print(io, "</jltree>")
	end
end=#

# ╔═╡ b5c7cfca-8fda-11ea-33e1-e9abe88e6b6b
good_boys[1:end]

# ╔═╡ d6121fd6-873a-11ea-23ca-ff0562499314
md"a"

# ╔═╡ c09b041e-870e-11ea-3f56-97bb48977c4e
rand(Float64, (3,3))

# ╔═╡ b2d786ec-7f73-11ea-1a0c-f38d7b6bbc1e
md"# The Basel problem

_Leonard Euler_ proved in 1741 that the series

$$\frac{1}{1} + \frac{1}{4} + \frac{1}{9} + \cdots$$

converges to

$$\frac{\pi^2}{6}$$"

# ╔═╡ 8dfedde4-93c7-11ea-3526-11be3abfd339
md"# The Basel problem

_Leonard Euler_ proved in 1741 that the series

$$\frac{1}{1} + \frac{1}{4} + \frac{1}{9} + \cdots$$

converges to

$$\frac{\pi^2}{6}$$"

# ╔═╡ ee2eba46-906f-11ea-038c-99283e57b8bd
ctx = IOContext(stdout)

# ╔═╡ f2105a8c-906f-11ea-20f7-579104b25136
get(PlutoRunner.iocontext, :module, @__MODULE__)

# ╔═╡ ed22deae-906b-11ea-3c17-3b3a99dffc0f
mutable struct Derp
	left
	right
end

# ╔═╡ 2d57b6f6-93c6-11ea-1ab6-6582e884037c
ENV

# ╔═╡ 754a50e0-906f-11ea-1c75-b9d0f2a7354f
(a=12,b=:a)

# ╔═╡ 4580323c-93ce-11ea-0cea-5339e499bfe5
PlutoRunner.sprint_withreturned(PlutoRunner.show_richest, "a")

# ╔═╡ 961d6f6c-93d7-11ea-39e0-8f4db8e068d7
PlutoRunner.sprint_withreturned(PlutoRunner.show_richest, "a")

# ╔═╡ aafb9178-93cf-11ea-1170-8b98c6afa32d
sprint(PlutoRunner.show_richest, "a")

# ╔═╡ 98a88b9a-93d7-11ea-0162-5f4df59775cb
sprint(PlutoRunner.show_richest, "a")

# ╔═╡ e37a69d4-93cf-11ea-033e-535261e4f160
PlutoRunner.sprint_withreturned(show, MIME"text/plain"(), "a")

# ╔═╡ a0152974-93d7-11ea-16cc-2bb976c74697
PlutoRunner.sprint_withreturned(show, MIME"text/plain"(), "a")

# ╔═╡ cfe781b8-93cf-11ea-2973-cfd841a16238
sprint(show, MIME"text/plain"(), "a")

# ╔═╡ 4c3e879e-93d4-11ea-2ad2-a93c2792c972
istextmime(MIME"text/plain"())

# ╔═╡ 7c8ef542-93ce-11ea-3dd7-f355bdc35e0a
"a"

# ╔═╡ ea9fc9f2-93d4-11ea-324b-b17587d5cdf6
mime = MIME"text/plain"()

# ╔═╡ ff8d461e-93d4-11ea-1ce2-0d493132ddfd
t = String

# ╔═╡ f5bcf8c8-93d4-11ea-3e62-2792206eda99
mime isa MIME"text/plain" && 
        t isa DataType &&
        which(show, (IO, MIME"text/plain", t)) === PlutoRunner.struct_showmethod_mime &&
        which(show, (IO, t)) === PlutoRunner.struct_showmethod

# ╔═╡ b4f70496-93d4-11ea-1794-5f0bc58de11c
which(show, (IO, MIME"text/plain", String))

# ╔═╡ 48414afe-93d5-11ea-1854-03945b3b6222
f = PlutoRunner.show_richest

# ╔═╡ 53738054-93d5-11ea-2f52-0b95249c7188
args = ["a"]

# ╔═╡ f0d20754-93cf-11ea-3272-a582b7a1a04f
first(filter(m->Base.invokelatest(showable, m, x), PlutoRunner.allmimes))

# ╔═╡ fa4a4b16-93cf-11ea-000b-27c52abdcf7f
first(filter(m->showable(m, x), PlutoRunner.allmimes))

# ╔═╡ 798eb62c-93d1-11ea-1e1a-ddc2f8091963
findfirst(m->showable(m, x), PlutoRunner.allmimes)

# ╔═╡ 056b0be8-93d3-11ea-355b-0377246aafce
xshowable(m) = showable(m,x)

# ╔═╡ af434114-93d3-11ea-27b9-dff0493075f4
function fr()
	PlutoRunner.allmimes[findfirst(m->showable(m, x), PlutoRunner.allmimes)]
end

# ╔═╡ eb61f3a8-93d2-11ea-33d9-25c299894e80
findnext(m->showable(m, x), PlutoRunner.allmimes, 1)

# ╔═╡ b9d933cc-93d3-11ea-1b5b-d577af02c052
fr()

# ╔═╡ 2a72ea68-93d3-11ea-3b62-7f044a816ee2
[1 for i in 1:3]

# ╔═╡ 31f94494-93d3-11ea-085b-bdef957c19dd
collect(1:3)

# ╔═╡ 93d6134a-93d1-11ea-23b9-db2241f04dc0
let
	x = [1,2,3]
	findfirst(m->showable(m, x), PlutoRunner.allmimes)
end

# ╔═╡ a4f59ea2-93d1-11ea-312f-b7d97f7f1d84
let
	x = [1,2,3]
	local mime
	for m in PlutoRunner.allmimes
		if showable(m,x)
			mime = m
		end
	end
	mime
end

# ╔═╡ b377c1a2-93d2-11ea-2c15-254419a4005d
mmmm

# ╔═╡ c38b08b0-93d2-11ea-3240-3d621e799d2e
methods(findnext)

# ╔═╡ 446407aa-93d0-11ea-27f9-ad9a8a3d9c2f
[showable(m,x) for m in PlutoRunner.allmimes]

# ╔═╡ c2dcc8bc-93d0-11ea-01e2-a9541b708ecd
[false for m in PlutoRunner.allmimes];

# ╔═╡ dc6e14b6-93d0-11ea-37a4-bded1ed8adea
map(m -> m, PlutoRunner.allmimes);

# ╔═╡ 75184d20-93d0-11ea-2fe4-479bcb30b0f4
showable(MIME"text/plain"(),x)

# ╔═╡ 81360872-93d0-11ea-1223-3ba250cc1b0b
showable(MIME"image/gif"(),x)

# ╔═╡ 812019ea-93d0-11ea-12b8-5b005f2f7560
showable(MIME"image/bmp"(),x)

# ╔═╡ 8108e1f8-93d0-11ea-1341-bf637b668e53
showable(MIME"image/jpg"(),x)

# ╔═╡ 80f1e93a-93d0-11ea-3480-c9eadce86083
showable(MIME"image/png"(),x)

# ╔═╡ 80d83a08-93d0-11ea-1553-f77bef2161ff
showable(MIME"image/svg+xml"(),x)

# ╔═╡ 80c223e4-93d0-11ea-3fcf-e5e2eadddb7a
showable(MIME"text/html"(),x)

# ╔═╡ 80816386-93d0-11ea-1766-434819edb637
showable(MIME"application/vnd.pluto.tree+xml"(),x)

# ╔═╡ 8c66f200-9070-11ea-33b8-8fe4209ebbad
if false
	afsddfsadfsadfs
end

# ╔═╡ 9036c98e-906e-11ea-1424-bbe053ae281c
d = Derp(1,2)

# ╔═╡ f4f81140-9076-11ea-3fc9-b9098fa5f8ab
md"asdf $(d) asdf"

# ╔═╡ 3f788374-9074-11ea-2e28-4330a2401862
x |> Tuple

# ╔═╡ d945b32e-906e-11ea-18c0-d32060c3d502
tn = ((d |> typeof).name)

# ╔═╡ 209f8950-93d0-11ea-0966-097d134f8844
methods(show)

# ╔═╡ e89f2218-906b-11ea-26ae-4f246faad6ba
let
	a = Derp(nothing, nothing)
	b = Derp(a, nothing)
	a.left = b
	a,b
end

# ╔═╡ b2d79330-7f73-11ea-0d1c-a9aad1efaae1
n = 1:10

# ╔═╡ b2d79376-7f73-11ea-2dce-cb9c449eece6
seq = n .^ -2

# ╔═╡ b2d792c2-7f73-11ea-0c65-a5042701e9f3
sqrt(sum(seq) * 6.0)

# ╔═╡ Cell order:
# ╟─cb18b686-8fd8-11ea-066c-bd467edfc009
# ╠═a5e270ea-87c6-11ea-32e4-a5c92c2543e3
# ╠═6de2fdec-9075-11ea-3a39-176a725c1c38
# ╠═d6bb60b0-8fc4-11ea-1a96-6dffb769ac8d
# ╠═bc9b0846-8fe7-11ea-36be-95f4d5678d9f
# ╟─5a786a52-8fca-11ea-16a1-f336e0d09343
# ╠═610988be-87cb-11ea-1158-e926582f646e
# ╠═2397a42c-8fe9-11ea-3613-f95c0f69d22c
# ╠═b0dba8fc-87c6-11ea-3f48-03e3076f0cdf
# ╠═b5941dcc-87c6-11ea-070d-2beb077404b4
# ╠═93136964-93c0-11ea-3da9-4d6e11b49b1e
# ╠═8b8affe4-93c1-11ea-13e9-35f812ea2a24
# ╠═9749bdd8-93c0-11ea-218e-bb3c8aca84a6
# ╠═e46bc5fe-93c0-11ea-3a28-a57866436552
# ╠═0f1736b8-87c7-11ea-2b9b-a7f8aad9800a
# ╟─e5a5561c-870c-11ea-27be-a51a15915e64
# ╟─503d8582-8fc3-11ea-3934-fb7a4f2a3473
# ╠═6dd4dbb4-8fe8-11ea-0d3e-4d874391e9e1
# ╠═a53ebb96-8ff3-11ea-3a49-cdce8c158c41
# ╠═b0d52d76-8721-11ea-0d79-d3cc67a891d5
# ╠═8984fd16-8fe4-11ea-1ff9-d5cd8f6fe0b0
# ╠═e8d20214-8fe4-11ea-07cf-0970e4d1b8f0
# ╠═8cbdafb6-8fe7-11ea-2e1b-cf6781de9987
# ╠═e69caef4-8fe4-11ea-33e7-2b8e7fe4ad38
# ╠═45b18414-8fe5-11ea-379d-3714e2a5e571
# ╠═ad19ec44-8fe1-11ea-11a9-73b10aa46388
# ╠═69c2076a-8feb-11ea-143a-cfec10821e8e
# ╠═2928da6e-8fee-11ea-1af2-81d68a8ed90a
# ╠═267a8fbe-8fef-11ea-0cea-5febb0c16422
# ╠═d87f1c8e-8fef-11ea-3196-53ba5908144b
# ╠═b51971a8-8fe1-11ea-1b66-95a173a7c935
# ╠═e8e983ae-870f-11ea-27b8-a7fbc1361d6b
# ╠═044a825a-8fdb-11ea-29bb-1d0f0e028488
# ╠═ad31516a-8fdf-11ea-0803-9f5b1a9fd9d8
# ╟─2457311c-870f-11ea-397e-3120cd3e0b74
# ╠═47715e08-8fba-11ea-1982-99fce343b41b
# ╠═eed501f8-9076-11ea-3002-a5ec32d6dccb
# ╠═f4f81140-9076-11ea-3fc9-b9098fa5f8ab
# ╠═cb62a20c-9074-11ea-3fb2-0d197fe87508
# ╟─f8c7970c-9074-11ea-36b4-0927aaed5682
# ╠═c06927b6-8fd6-11ea-3da4-fd6080e71b37
# ╠═52a70206-8fd7-11ea-3c72-7d6154eae359
# ╠═e0508e70-870c-11ea-15a0-2504ae18dad8
# ╠═b5c7cfca-8fda-11ea-33e1-e9abe88e6b6b
# ╟─d6121fd6-873a-11ea-23ca-ff0562499314
# ╠═c09b041e-870e-11ea-3f56-97bb48977c4e
# ╠═b2d786ec-7f73-11ea-1a0c-f38d7b6bbc1e
# ╠═8dfedde4-93c7-11ea-3526-11be3abfd339
# ╠═b2d792c2-7f73-11ea-0c65-a5042701e9f3
# ╠═ee2eba46-906f-11ea-038c-99283e57b8bd
# ╠═f2105a8c-906f-11ea-20f7-579104b25136
# ╠═ed22deae-906b-11ea-3c17-3b3a99dffc0f
# ╠═2d57b6f6-93c6-11ea-1ab6-6582e884037c
# ╠═754a50e0-906f-11ea-1c75-b9d0f2a7354f
# ╠═4580323c-93ce-11ea-0cea-5339e499bfe5
# ╠═961d6f6c-93d7-11ea-39e0-8f4db8e068d7
# ╠═aafb9178-93cf-11ea-1170-8b98c6afa32d
# ╠═98a88b9a-93d7-11ea-0162-5f4df59775cb
# ╠═e37a69d4-93cf-11ea-033e-535261e4f160
# ╠═a0152974-93d7-11ea-16cc-2bb976c74697
# ╠═cfe781b8-93cf-11ea-2973-cfd841a16238
# ╠═4c3e879e-93d4-11ea-2ad2-a93c2792c972
# ╠═7c8ef542-93ce-11ea-3dd7-f355bdc35e0a
# ╠═ea9fc9f2-93d4-11ea-324b-b17587d5cdf6
# ╠═ff8d461e-93d4-11ea-1ce2-0d493132ddfd
# ╠═f5bcf8c8-93d4-11ea-3e62-2792206eda99
# ╠═b4f70496-93d4-11ea-1794-5f0bc58de11c
# ╠═48414afe-93d5-11ea-1854-03945b3b6222
# ╠═53738054-93d5-11ea-2f52-0b95249c7188
# ╠═f0d20754-93cf-11ea-3272-a582b7a1a04f
# ╠═fa4a4b16-93cf-11ea-000b-27c52abdcf7f
# ╠═798eb62c-93d1-11ea-1e1a-ddc2f8091963
# ╠═056b0be8-93d3-11ea-355b-0377246aafce
# ╠═af434114-93d3-11ea-27b9-dff0493075f4
# ╠═eb61f3a8-93d2-11ea-33d9-25c299894e80
# ╠═b9d933cc-93d3-11ea-1b5b-d577af02c052
# ╠═2a72ea68-93d3-11ea-3b62-7f044a816ee2
# ╠═31f94494-93d3-11ea-085b-bdef957c19dd
# ╠═93d6134a-93d1-11ea-23b9-db2241f04dc0
# ╠═a4f59ea2-93d1-11ea-312f-b7d97f7f1d84
# ╠═b377c1a2-93d2-11ea-2c15-254419a4005d
# ╠═c38b08b0-93d2-11ea-3240-3d621e799d2e
# ╠═446407aa-93d0-11ea-27f9-ad9a8a3d9c2f
# ╠═c2dcc8bc-93d0-11ea-01e2-a9541b708ecd
# ╠═dc6e14b6-93d0-11ea-37a4-bded1ed8adea
# ╠═75184d20-93d0-11ea-2fe4-479bcb30b0f4
# ╠═81360872-93d0-11ea-1223-3ba250cc1b0b
# ╠═812019ea-93d0-11ea-12b8-5b005f2f7560
# ╠═8108e1f8-93d0-11ea-1341-bf637b668e53
# ╠═80f1e93a-93d0-11ea-3480-c9eadce86083
# ╠═80d83a08-93d0-11ea-1553-f77bef2161ff
# ╠═80c223e4-93d0-11ea-3fcf-e5e2eadddb7a
# ╠═80816386-93d0-11ea-1766-434819edb637
# ╠═8c66f200-9070-11ea-33b8-8fe4209ebbad
# ╠═9036c98e-906e-11ea-1424-bbe053ae281c
# ╠═3f788374-9074-11ea-2e28-4330a2401862
# ╠═d945b32e-906e-11ea-18c0-d32060c3d502
# ╠═209f8950-93d0-11ea-0966-097d134f8844
# ╠═e89f2218-906b-11ea-26ae-4f246faad6ba
# ╟─b2d79330-7f73-11ea-0d1c-a9aad1efaae1
# ╠═b2d79376-7f73-11ea-2dce-cb9c449eece6
