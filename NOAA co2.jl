### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ 06be8ac3-fa55-449d-ad3f-8162bd36c6b7
begin
	import Pkg
	Pkg.activate()
end

# ╔═╡ b3656548-3be2-47ed-898e-3634003eee0b
using Revise, ObservablePlots

# ╔═╡ 76ec430d-3c01-4545-8be3-e82528257c33
using CSV, DataFrames

# ╔═╡ b5ab10a0-d0c1-477e-8985-8cfbbc38fc6b
using Dates

# ╔═╡ 9b80c3d6-ed15-499f-806b-6fa1091c417a
using HypertextLiteral

# ╔═╡ 464672aa-cc48-11ef-3173-9bb6140273d2
url1 = "https://gml.noaa.gov/webdata/ccgg/trends/co2/co2_mm_mlo.csv"

# ╔═╡ 55d66238-68c1-4c7a-8159-f411fa663260
url2 = "https://gml.noaa.gov/webdata/ccgg/trends/co2/co2_daily_mlo.csv"

# ╔═╡ 1e735495-ef76-433a-b3a4-dd787fa4f669
Text(read(download(url2), String))

# ╔═╡ 3525308c-a7d7-4373-8826-f5a46a21c42a
d = CSV.read(download(url1), DataFrame; comment="#")

# ╔═╡ 063d8376-2c3b-4d74-abe8-582fe6bd9d1d
d2 = CSV.read(download(url2), DataFrame; comment="#", header=0)

# ╔═╡ cdfa1d2a-baa0-4831-a6b1-69385efa8eb3
dates = [Date(x[1], x[2], x[3]) for x in eachrow(d2)]

# ╔═╡ 7ea7d253-7410-44d8-bbda-3fe6a20888ef
Base.PkgId(Base.UUID("ade2ca70-3891-5945-98fb-dc099432e06a"), "Dates")

# ╔═╡ 5b695b6b-e818-4276-9618-c79e8f208e82
Base.loaded_modules[Base.PkgId(Base.UUID("ade2ca70-3891-5945-98fb-dc099432e06a"), "Dates")]

# ╔═╡ 3e91edb7-3a29-4288-b8e0-826296e06d20
vals = [x[5] for x in eachrow(d2)]

# ╔═╡ 383c54e5-9315-4b52-b77b-43f73dc252dd
cell(zip(dates[1:400], vals[1:400]); 
	x=@jsl("d => d[0].getUTCDate()"),
	y=@jsl("d => d[0].getUTCMonth()"),
	fy=@jsl("d => d[0].getUTCFullYear()"),
	fill=@jsl("d => d[1]"),
	
)

# ╔═╡ 1a8a376d-6a66-4c77-b5f5-5929a1e330a5
cell(tidyzip(
	CO₂=vals[1:400], 
	month=month.(dates[1:400]),
	day=dayofmonth.(dates[1:400]),
	year=year.(dates[1:400])
); fill="CO₂", x="day", y="month", fy="year")

# ╔═╡ 52ddb495-724a-4572-aa55-0f490ac77c40
cell(nothing; 
	fill=vals[1:2000], 
	x=dayofmonth.(dates[1:2000]), 
	y=month.(dates[1:2000]), 
	fy=year.(dates[1:2000]),
).plot(x=(label="asdf",))

# ╔═╡ 0c89c8ad-7ee9-4dcf-8bc3-f3a1bf3f73a4
# line(dates, vals)

# ╔═╡ 4c9a553c-2319-4d22-9afb-5c35232e4c29
vals

# ╔═╡ e7e02789-bc11-449c-863a-86a604bfff00
plot(
	line(
		zip(dates[1:70],vals[1:70]);
		marker=true,
		curve= "catmull-rom",
	);

	x=(label="asdf",),

	y =(
		label="CO2 ppm",
		transform=@jsl("x => x * 2"),
	),

)

# ╔═╡ d349e5b1-6be3-4399-af82-3322529b20a5


# ╔═╡ e76769de-3fa6-46c5-b91f-a86e9045c7e6
(x=(label="index",), )|> typeof

# ╔═╡ 37c1b129-f631-472a-bba8-9e4766d5739f
md"""
IDEA! when you pass in props that observablehq does not know but they exist in Plots/makie then we can show hints

like markersize, xlabel, xlims
"""

# ╔═╡ 9a4b7cd3-c436-48ca-9d61-214f76b217fe
plot(
	line(zip(dates[1:100], vals[1:100]); curve="catmull-rom",),
	dot(zip(dates[1:100], vals[1:100]); tip=true);
	
	y=(
		grid=true,
		transform=@jsl("x => x*2"),
	),
)

# ╔═╡ 468ca161-92f6-4f51-b1fb-7d3a14ca47b4
lineY(vals; tip=true)

# ╔═╡ c8224122-8307-46e4-85c9-82ed6591ba5b
lineY(vals; x=smart_embed_data(dates))

# ╔═╡ 9125e779-2903-40bc-b2f0-57864f4defd2


# ╔═╡ 32c9e066-d734-4226-bcf9-c8f2e9aa01e0
dot(zip(dates, vals))

# ╔═╡ eaea893c-2d29-45fb-b63f-b866b9ca9b9f
z = randn(101)

# ╔═╡ 654fe84c-783f-421e-9680-85ab2435f5b6
data = z[1:100] .+ z[2:101] .+ 2

# ╔═╡ 04152403-abde-4b8f-83ad-1b35bc374d32
dot(enumerate(data))

# ╔═╡ 5872fbe3-702b-4ebf-8cc9-ec9322c4aa7b
peaks = map(enumerate(data)) do (i,x)
	left = data[max(begin,i-1)]
	right = data[min(end,i+1)]
	left < x > right
end

# ╔═╡ 6a13b7fe-f12c-4518-a1df-9bbd55174765
plot(
	# dot(enumerate(data); ),
	lineY(data; tip=false, marker=true),
	text(enumerate(data); 
		lineAnchor="bottom", 
		dy=-6,
		filter=peaks,
	),
	x=(label="index"),
	# y=(type="log",),
	height=200,
)

# ╔═╡ 1576f9f3-74d0-4c70-8e33-8a54ec79e4f8
dotY(data; x=eachindex(data))

# ╔═╡ Cell order:
# ╠═06be8ac3-fa55-449d-ad3f-8162bd36c6b7
# ╠═464672aa-cc48-11ef-3173-9bb6140273d2
# ╠═55d66238-68c1-4c7a-8159-f411fa663260
# ╠═1e735495-ef76-433a-b3a4-dd787fa4f669
# ╠═76ec430d-3c01-4545-8be3-e82528257c33
# ╠═3525308c-a7d7-4373-8826-f5a46a21c42a
# ╠═063d8376-2c3b-4d74-abe8-582fe6bd9d1d
# ╠═cdfa1d2a-baa0-4831-a6b1-69385efa8eb3
# ╠═383c54e5-9315-4b52-b77b-43f73dc252dd
# ╠═7ea7d253-7410-44d8-bbda-3fe6a20888ef
# ╠═5b695b6b-e818-4276-9618-c79e8f208e82
# ╠═1a8a376d-6a66-4c77-b5f5-5929a1e330a5
# ╠═52ddb495-724a-4572-aa55-0f490ac77c40
# ╠═3e91edb7-3a29-4288-b8e0-826296e06d20
# ╠═0c89c8ad-7ee9-4dcf-8bc3-f3a1bf3f73a4
# ╠═b5ab10a0-d0c1-477e-8985-8cfbbc38fc6b
# ╠═9b80c3d6-ed15-499f-806b-6fa1091c417a
# ╠═b3656548-3be2-47ed-898e-3634003eee0b
# ╠═4c9a553c-2319-4d22-9afb-5c35232e4c29
# ╠═04152403-abde-4b8f-83ad-1b35bc374d32
# ╠═e7e02789-bc11-449c-863a-86a604bfff00
# ╠═d349e5b1-6be3-4399-af82-3322529b20a5
# ╠═6a13b7fe-f12c-4518-a1df-9bbd55174765
# ╠═e76769de-3fa6-46c5-b91f-a86e9045c7e6
# ╠═5872fbe3-702b-4ebf-8cc9-ec9322c4aa7b
# ╠═37c1b129-f631-472a-bba8-9e4766d5739f
# ╠═9a4b7cd3-c436-48ca-9d61-214f76b217fe
# ╠═468ca161-92f6-4f51-b1fb-7d3a14ca47b4
# ╠═c8224122-8307-46e4-85c9-82ed6591ba5b
# ╠═9125e779-2903-40bc-b2f0-57864f4defd2
# ╠═32c9e066-d734-4226-bcf9-c8f2e9aa01e0
# ╠═eaea893c-2d29-45fb-b63f-b866b9ca9b9f
# ╠═654fe84c-783f-421e-9680-85ab2435f5b6
# ╠═1576f9f3-74d0-4c70-8e33-8a54ec79e4f8
