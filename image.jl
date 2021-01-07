### A Pluto.jl notebook ###
# v0.9.4

using Markdown
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.peek, el) ? Base.peek(el) : missing
        el
    end
end

# ╔═╡ bbe7a79c-8a1a-11ea-2aa6-cd98feb2cb47
begin
	using Images
	using PlutoUI
end

# ╔═╡ fc922328-a9e9-11ea-2b73-6ddbd7d18d66
@bind nasdasd Slider(0:2000)

# ╔═╡ d56d0962-8afd-11ea-1086-0b9d5d408acf
@bind n Slider(0:2000)

# ╔═╡ dc99065e-8af7-11ea-1551-ef1442729000
"<div style='height: $(n)px'></div>" |> HTML

# ╔═╡ b55335c6-aa55-11ea-2f1e-196717f62bab
[1,2,1:5,6]

# ╔═╡ 480dd854-a6b3-11ea-27f7-d98df3e52d13
ap = -1

# ╔═╡ 4d00f652-a6b3-11ea-25d8-e1b8844e1c09
ap |> sqrt

# ╔═╡ 8c7470ae-a6b6-11ea-3f45-db9a11bb2952
@bind oo Slider(1:10000)

# ╔═╡ 94f8234c-a6b6-11ea-238c-8fa7793c32f7
sleep(.5); oo

# ╔═╡ e9239c94-a5ad-11ea-0e40-5549e97a383d
1
2

# ╔═╡ 76b748b4-a5b1-11ea-3885-3df54023af8f
sqrt(-1)

# ╔═╡ b6895840-a5a9-11ea-3fe7-dffcf6091080
@bind go Button("Go!")

# ╔═╡ 88155814-a5aa-11ea-0e53-8db16ef58e82
data = let
	go
	rand(100)
end

# ╔═╡ 9cf0c070-a5aa-11ea-0ca0-851a0d3812c4
sum(data)

# ╔═╡ 3b23635c-a5a5-11ea-12ac-bbe1a2ca0fea
Base.throwto

# ╔═╡ 110d1318-a5a7-11ea-25a0-693442a3575e
Docs.keywords

# ╔═╡ 3ded4ff6-a5a2-11ea-1773-d98f738a28fe
md"# asdf"

# ╔═╡ 40d1120c-a5a2-11ea-1cd5-03fe1e370703
html"""<script>
d3 = import "d3"

return d3
</script>"""

# ╔═╡ e0a3f982-8a1a-11ea-2d07-a3d53c9ba23f
function grabframe(relativeframepos)
	t = relativeframepos * 2 * π
	ω = 2π
	c = 4.
	frame = [sin(ω*t - √(x^2 + y^2)/300*c) for y in -200:399, x in -300:499]
	return Gray.(frame .^ 2)
end

# ╔═╡ 87581906-8b16-11ea-36d4-d521fc83d92e
begin
	m=MIME("a/b")
	string(m)
end

# ╔═╡ 6b85dc6e-8a1b-11ea-09d5-172c70405b02
@bind x Slider(0:0.01:1)

# ╔═╡ 2f448160-8a1b-11ea-1181-f1fda429aa71
grabframe(x)

# ╔═╡ Cell order:
# ╠═fc922328-a9e9-11ea-2b73-6ddbd7d18d66
# ╠═dc99065e-8af7-11ea-1551-ef1442729000
# ╠═d56d0962-8afd-11ea-1086-0b9d5d408acf
# ╠═b55335c6-aa55-11ea-2f1e-196717f62bab
# ╠═4d00f652-a6b3-11ea-25d8-e1b8844e1c09
# ╠═480dd854-a6b3-11ea-27f7-d98df3e52d13
# ╠═8c7470ae-a6b6-11ea-3f45-db9a11bb2952
# ╠═94f8234c-a6b6-11ea-238c-8fa7793c32f7
# ╠═bbe7a79c-8a1a-11ea-2aa6-cd98feb2cb47
# ╠═e9239c94-a5ad-11ea-0e40-5549e97a383d
# ╠═76b748b4-a5b1-11ea-3885-3df54023af8f
# ╠═b6895840-a5a9-11ea-3fe7-dffcf6091080
# ╠═88155814-a5aa-11ea-0e53-8db16ef58e82
# ╠═9cf0c070-a5aa-11ea-0ca0-851a0d3812c4
# ╠═3b23635c-a5a5-11ea-12ac-bbe1a2ca0fea
# ╠═110d1318-a5a7-11ea-25a0-693442a3575e
# ╠═3ded4ff6-a5a2-11ea-1773-d98f738a28fe
# ╠═40d1120c-a5a2-11ea-1cd5-03fe1e370703
# ╠═e0a3f982-8a1a-11ea-2d07-a3d53c9ba23f
# ╠═2f448160-8a1b-11ea-1181-f1fda429aa71
# ╠═87581906-8b16-11ea-36d4-d521fc83d92e
# ╠═6b85dc6e-8a1b-11ea-09d5-172c70405b02
