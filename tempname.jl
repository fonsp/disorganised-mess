### A Pluto.jl notebook ###
# v0.10.0

using Markdown

# ╔═╡ 532b8cf2-c366-11ea-14ac-679ebe6364a9
tempdir()

# ╔═╡ 1325da08-c367-11ea-0b0e-8901bae174b4
import Dates

# ╔═╡ 33e3af40-c367-11ea-374c-814b07451bc7
now = Dates.Date(2020)

# ╔═╡ 69a2a488-c367-11ea-2951-a7500c9c20e1
"Experiment 1 (" * Dates.format(now, Dates.DateFormat("dd u yyyy")) * ").jl"

# ╔═╡ 61d57e54-c369-11ea-20f7-4b28b417321f


# ╔═╡ 80152786-c369-11ea-2c48-8b91f65e9621
trash = mktempdir(; cleanup=false)

# ╔═╡ 376f7180-c36c-11ea-2626-ff3010bb42cf
f(x=rand())=x

# ╔═╡ 3bff0e0e-c36c-11ea-1488-e32a1274d76a
f()

# ╔═╡ 73400f48-c368-11ea-0e69-19d8ee00b464
adjectives = [
	"groundbreaking"
	"important"
	"novel"
	"fun"
	"interesting"
	"fascinating"
	"surprising"
	"unexpected"
]

# ╔═╡ 88bcfc22-c367-11ea-0f33-cfbd9d3a6769
nouns = [
	"discovery"
	"experiment"
	"story"
	"journal"
	"notebook"
	"revelation"
	"computation"
	"creation"
	"analysis"
	"invention"
	"blueprint"
	"report"
]

# ╔═╡ aa1f8368-c368-11ea-26f4-93f3454cd1fe
begin
	function cute_name(;suffix=".jl")
		titlecase(rand(adjectives)) * " " * rand(nouns) * suffix
	end
	function cute_name(dir::AbstractString; suffix=".jl")
		base = cute_name(;suffix="")
		chosen = base * ".jl"
		n = 1
		while isfile(joinpath(dir, chosen))
			n += 1
			chosen = base * " " * string(n) * ".jl"
		end
		joinpath(dir, chosen)
	end
end

# ╔═╡ 22af735a-c36a-11ea-08a6-bbd0fda881bc
for i in 1:100
	touch(cute_name(trash))
end

# ╔═╡ 385d030e-c36a-11ea-34f8-13d4a70925b7
cute_name(trash)

# ╔═╡ e2a92162-c368-11ea-3495-b1244f96f378
cute_name()

# ╔═╡ 30a0d49e-c369-11ea-0592-f764318228a1
length(adjectives) * length(nouns)

# ╔═╡ 646c2634-c366-11ea-07cf-59e0cc7f6f46
Iterators.countfrom(1)

# ╔═╡ 9a48fe1c-c366-11ea-3a75-bd8740ccdb29
filter(c -> c>4, Iterators.countfrom(1))

# ╔═╡ b1596de4-c366-11ea-06c8-2bd7c012a8c8
first(Iterators.filter(, Iterators.countfrom(1)))

# ╔═╡ Cell order:
# ╠═532b8cf2-c366-11ea-14ac-679ebe6364a9
# ╠═1325da08-c367-11ea-0b0e-8901bae174b4
# ╠═33e3af40-c367-11ea-374c-814b07451bc7
# ╠═69a2a488-c367-11ea-2951-a7500c9c20e1
# ╠═61d57e54-c369-11ea-20f7-4b28b417321f
# ╠═aa1f8368-c368-11ea-26f4-93f3454cd1fe
# ╠═80152786-c369-11ea-2c48-8b91f65e9621
# ╠═22af735a-c36a-11ea-08a6-bbd0fda881bc
# ╠═385d030e-c36a-11ea-34f8-13d4a70925b7
# ╠═e2a92162-c368-11ea-3495-b1244f96f378
# ╠═376f7180-c36c-11ea-2626-ff3010bb42cf
# ╠═3bff0e0e-c36c-11ea-1488-e32a1274d76a
# ╠═30a0d49e-c369-11ea-0592-f764318228a1
# ╠═73400f48-c368-11ea-0e69-19d8ee00b464
# ╠═88bcfc22-c367-11ea-0f33-cfbd9d3a6769
# ╠═646c2634-c366-11ea-07cf-59e0cc7f6f46
# ╠═9a48fe1c-c366-11ea-3a75-bd8740ccdb29
# ╠═b1596de4-c366-11ea-06c8-2bd7c012a8c8
