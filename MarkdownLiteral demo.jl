### A Pluto.jl notebook ###
# v0.17.3

using Markdown
using InteractiveUtils

# ╔═╡ ef2e0838-5f7c-11ec-354b-0118ac132ccc
	import Pkg
	

# ╔═╡ 552dee29-60a1-444b-968d-bb271952b552
Pkg.activate()

# ╔═╡ f272244e-7e6e-45fd-bd1b-c00cce041875
using MarkdownLiteral: @markdown

# ╔═╡ 4bf6b5c4-fc87-4f9c-ad29-bac2a31d4788
Text("""
Hey! This is some text. Can you read me?

Plain text looks a bit boring...
""")

# ╔═╡ f3cdccc8-fa1d-4926-8a8a-a03b6d62f0b2
@markdown("""
# MarkdownLiteral.jl

The macro `@markdown` lets you write [Markdown](https://www.markdownguide.org/getting-started/) inside Pluto notebooks. *Here is an example:*
""")

# ╔═╡ a34c7acf-52fe-4400-911a-df93db773f18
@markdown("""
<p>
	The macro <code>@markdown</code> lets you write <a href="https://developer.mozilla.org/docs/Web/HTML">HTML</a> inside Pluto notebooks.
	<em>Here is an example:</em>
</p>
""")

# ╔═╡ 831c1e17-5b81-4105-9a47-14ccd33b3c70
@markdown("""
Did you see that? It is the same macro!
""")

# ╔═╡ 85fe1000-4c96-4365-b2e6-07167d8c5748
films = [
	(title="Frances Ha", director="Noah Baumbach", year=2012)
	(title="Portrait de la jeune fille en feu", director="Céline Sciamma", year=2019)
	(title="De noorderlingen", director="Alex van Warmerdam", year=1992)
]

# ╔═╡ d634b2d4-347d-4527-98e9-7f9b71ef9b6d
@markdown("""
My films:
$([
	"- **$(f.title)** ($(f.year)) by _$(f.director)_\n"
	for f in films
])
""")

# ╔═╡ 72aee6cc-f8b7-4f83-aa9b-0138deed0798
@markdown("""
<ul>
$([
	@markdown("<li>
		<b>$(f.title)</b> ($(f.year)) by <em>$(f.director)</em>
	</li>")
	for f in films
])
</ul>
""")

# ╔═╡ a62c07ec-5d5e-4dd7-8fc4-6a637340c019
logs = [
	(text="Info", urgent=false),
	(text="Alert", urgent=true),
	(text="Update", urgent=false),
]

# ╔═╡ d4bc76b7-a41a-4aa3-aedd-03b966ec03dd
@markdown("$((
	@markdown("<div style=$((
		color="darkblue",
		background=log.urgent ? "pink" : "lightblue",
		font_weight=900,
		padding=".5em",
	))>$(log.text)</div>")
	for log in logs
))")

# ╔═╡ 343ce3ad-1d6d-4857-bf14-04cbd260d7b5


# ╔═╡ Cell order:
# ╠═ef2e0838-5f7c-11ec-354b-0118ac132ccc
# ╠═552dee29-60a1-444b-968d-bb271952b552
# ╠═f272244e-7e6e-45fd-bd1b-c00cce041875
# ╠═4bf6b5c4-fc87-4f9c-ad29-bac2a31d4788
# ╠═f3cdccc8-fa1d-4926-8a8a-a03b6d62f0b2
# ╠═a34c7acf-52fe-4400-911a-df93db773f18
# ╟─831c1e17-5b81-4105-9a47-14ccd33b3c70
# ╠═85fe1000-4c96-4365-b2e6-07167d8c5748
# ╠═d634b2d4-347d-4527-98e9-7f9b71ef9b6d
# ╠═72aee6cc-f8b7-4f83-aa9b-0138deed0798
# ╠═a62c07ec-5d5e-4dd7-8fc4-6a637340c019
# ╟─d4bc76b7-a41a-4aa3-aedd-03b966ec03dd
# ╠═343ce3ad-1d6d-4857-bf14-04cbd260d7b5
