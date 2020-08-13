### A Pluto.jl notebook ###
# v0.10.0

using Markdown

# ╔═╡ 6d657a8e-c1dd-11ea-2eb7-f956b3819670
import LibGit2

# ╔═╡ 82a33734-c1cf-11ea-242f-55472983b28e
import Pkg

# ╔═╡ c41baab4-c1dd-11ea-0f86-e1c4cb2b9e0f
repo = "https://github.com/fonsp/Pluto.jl"

# ╔═╡ a1513222-c1dd-11ea-1d6b-833308aa7453
begin
	dir = mktempdir(cleanup=false)
	LibGit2.clone(repo, dir)
end

# ╔═╡ 6d7b5b2a-c1cf-11ea-2a51-bb03b34976a7


# ╔═╡ 8454900a-c1cf-11ea-0897-7d3d3b113d82
all_files = let
	x = []
	for sub in ["src", "frontend", "test"]
		for (root, dirs, files) in walkdir(joinpath(dir, sub))
			if !occursin("img", root)
				push!(x, joinpath.([root], files)...)
			end
		end
	end
	x
end

# ╔═╡ 92a09410-c1cf-11ea-13ee-85cbcd4de2d8
all_contents = read.(all_files, [String]);

# ╔═╡ 9d842c9e-c1d0-11ea-2dae-f5726c92cac0
join(all_contents)

# ╔═╡ b042b7ea-c1d0-11ea-2759-55f24b17aac4
all_together = filter(!isspace, filter(isvalid, join(all_contents)))

# ╔═╡ 50d1c84e-c1dc-11ea-2cf4-8da2f0126dd5
count(isequal('\n'), filter(isvalid, join(all_contents)))

# ╔═╡ 4328c540-c1d1-11ea-0a99-efb01d8604af
import Markdown: htmlesc

# ╔═╡ c7a586ce-c1d0-11ea-0b59-13c418e1eb35
HTML("""
<code><pre style='word-break: break-all;
white-space: break-spaces; width: 576px; font-size: 10px; font-family: monospace;'>$(htmlesc(filter(isascii, all_together)))</pre></code>
""")

# ╔═╡ b5b5bd14-c1d8-11ea-2f33-839c40199b6f


# ╔═╡ ead40792-c1d5-11ea-0053-9fc2ea5f8720
x = [1,2,3]

# ╔═╡ efc1e762-c1d5-11ea-2bdc-d9e56fbeb264


# ╔═╡ 3da1df68-c1d5-11ea-210f-4f277921f9bf
line_length = 40

# ╔═╡ 62d07b14-c1d5-11ea-36ae-8f944f2d40e2
let
	chars = collect(all_together)
	edges = 1:40:(length(chars) + 1)
	
	String.(map(chars[], i ∈ 1:length(edges)-1))
end

# ╔═╡ 3f9c4fec-c1d5-11ea-3e40-7b6b696eb978
let
	
	lines = reshape
	combined = join()
	HTML("""
<code><pre style='word-break: break-all;
white-space: break-spaces; width: 576px; font-size: 10px; font-family: monospace;'>$(htmlesc(all_together))</pre></code>
""")
end

# ╔═╡ Cell order:
# ╠═6d657a8e-c1dd-11ea-2eb7-f956b3819670
# ╠═82a33734-c1cf-11ea-242f-55472983b28e
# ╠═a1513222-c1dd-11ea-1d6b-833308aa7453
# ╠═c41baab4-c1dd-11ea-0f86-e1c4cb2b9e0f
# ╠═6d7b5b2a-c1cf-11ea-2a51-bb03b34976a7
# ╠═8454900a-c1cf-11ea-0897-7d3d3b113d82
# ╠═92a09410-c1cf-11ea-13ee-85cbcd4de2d8
# ╠═9d842c9e-c1d0-11ea-2dae-f5726c92cac0
# ╠═b042b7ea-c1d0-11ea-2759-55f24b17aac4
# ╠═50d1c84e-c1dc-11ea-2cf4-8da2f0126dd5
# ╠═4328c540-c1d1-11ea-0a99-efb01d8604af
# ╠═c7a586ce-c1d0-11ea-0b59-13c418e1eb35
# ╠═b5b5bd14-c1d8-11ea-2f33-839c40199b6f
# ╠═ead40792-c1d5-11ea-0053-9fc2ea5f8720
# ╠═efc1e762-c1d5-11ea-2bdc-d9e56fbeb264
# ╠═3da1df68-c1d5-11ea-210f-4f277921f9bf
# ╠═62d07b14-c1d5-11ea-36ae-8f944f2d40e2
# ╠═3f9c4fec-c1d5-11ea-3e40-7b6b696eb978
