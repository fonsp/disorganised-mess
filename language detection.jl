### A Pluto.jl notebook ###
# v0.11.14

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

# ╔═╡ f265e1b8-f80f-11ea-0948-d3839ef76fec
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add(["PlutoUI"])
	using PlutoUI
end

# ╔═╡ a47e19a8-f80e-11ea-11a4-156874552d40
using LinearAlgebra

# ╔═╡ 47ce8ae2-f80d-11ea-37b4-09cc683b7aed
# These text samples are from 

# https://en.wikipedia.org/wiki/Oak
# https://es.wikipedia.org/wiki/Quercus

samples = (
	English = """
An oak is a tree or shrub in the genus Quercus (/ˈkwɜːrkəs/;[1] Latin "oak tree") of the beech family, Fagaceae. There are approximately 600 extant species of oaks. The common name "oak" also appears in the names of species in related genera, notably Lithocarpus (stone oaks), as well as in those of unrelated species such as Grevillea robusta (silky oaks) and the Casuarinaceae (she-oaks). The genus Quercus is native to the Northern Hemisphere, and includes deciduous and evergreen species extending from cool temperate to tropical latitudes in the Americas, Asia, Europe, and North Africa. North America contains the largest number of oak species, with approximately 90 occurring in the United States, while Mexico has 160 species of which 109 are endemic. The second greatest center of oak diversity is China, which contains approximately 100 species.[2]
""",
	Spanish =  """
Son árboles de gran porte por lo general, aunque también se incluyen arbustos. Los hay de follaje permanente, caducifolios y marcescentes. Las flores masculinas se presentan en amentos, inflorescencias complejas colgantes, habitualmente cada flor con entre cuatro y diez estambres, lo más a menudo seis, de largos filamentos. Las flores femeninas aparecen aisladas u organizadas en espigas o cabezuelas, presentan tres estigmas, así como óvulos anátropos, y están rodeadas por una estructura de escamas empizarradas que al madurar será la cúpula. El fruto se denomina bellota, es solitario y de origen axil (de brote), con cotiledones planos. La corteza suele ser lisa en los ejemplares jóvenes pero se va agrietando con la madurez de la edad. Se considera un género de origen antiguo, conociéndose fósiles desde el Cretácico inferior. Sus especies han presentado gran valor para las comunidades humanas, por su madera, corteza, obtención de curtientes ricos en taninos, frutos comestibles, etc. Participan como elementos dominantes del paisaje arbóreo en muchos territorios de su área de distribución (fundamentalmente en el hemisferio norte). Son frecuentes los fenómenos de hibridación entre sus especies, que suelen presentar, además, facilidad para la regeneración vegetativa por brotes de raíz o de cepa. 
""",
)

# ╔═╡ 885c7800-f80e-11ea-1527-9f29ddd5386a
md"# Cleaning"

# ╔═╡ 8e44b382-f80d-11ea-327e-99848e0dfa57
latin = [('a' : 'z')..., ' ']

# ╔═╡ d0d59182-f80b-11ea-32d3-f7082c9435b2
function islatin(character)
	'a' <= character <= 'z' || character == ' '
end

# ╔═╡ 4540e0d0-f80c-11ea-02ae-83ff44d36c32
function clean(text)
	filter(islatin, lowercase(text))
end

# ╔═╡ 9486a88c-f80c-11ea-182f-13e736e85a36
map(clean, samples)

# ╔═╡ 9206be10-f80e-11ea-3623-23666142bd11
md"# Transition tables"

# ╔═╡ 671dfd22-f80d-11ea-39f0-890de621f49a
function transition_counts(sample)
	A = zeros(Int, (length(latin),length(latin)))
	
	for i in 1:(length(sample)-1)
		c1 = sample[i]
		c2 = sample[i+1]
		
		i1 = findfirst(isequal(c1), latin)
		i2 = findfirst(isequal(c2), latin)
		
		A[i1, i2] += 1
	end
	
	A
end

# ╔═╡ b884f9f4-f80d-11ea-2877-5393935837ed
map(transition_counts ∘ clean, samples)

# ╔═╡ aaa1a0ca-f80e-11ea-33c7-211c8a2e6179
map(normalize ∘ transition_counts ∘ clean, samples)

# ╔═╡ a519ef58-f80f-11ea-2cd2-e770894aa82f
transition_frequencies = normalize ∘ transition_counts ∘ clean;

# ╔═╡ 497eb560-f810-11ea-3c8a-9f12212fef49
md"## abbabbabccabc

Let's try it out! To keep things simple, let's only look at the letters **a, b, c**."

# ╔═╡ 08293478-f810-11ea-01c6-cba5aed0377c
@bind transition_demo TextField(default="abba")

# ╔═╡ d2638e8e-f80e-11ea-32a5-63acf5eb5606
transition_frequencies(transition_demo)[1:3, 1:3]
# the 3x3 top left corner corresponds to a, b & c

# ╔═╡ ad51b844-f810-11ea-08ce-2df3ff878d4e
md"""
> Change the text to `abbaaaaaaaaaaaaa` - what do you see?
"""

# ╔═╡ bd244202-f80e-11ea-274e-e7c7238bf7d3
md"## Interpreting this table"

# ╔═╡ ecbc6ea6-f80e-11ea-20e9-71e2a730f996
md"Some questions:

> Which le**tt**ers appear double? Which one is most common?

> Which letter is most likely to follow a **W**?

> Which letter is most likely to precede a **W**?

> What is the probability that a v**o**w**e**l comes after a **c**o**ns**o**n**a**nt**?

> What is the sum of each row? What is the sum of each column? How can we interpret these values?"

# ╔═╡ 9f0d61e0-f80e-11ea-3b70-11dbacaf5a45
md"# Detecting the language"

# ╔═╡ e4fdfdf2-f810-11ea-3f71-9fdbf6d16fcf
md"""
We are faced with a challenge - we have some text, and we want to know whether it is written in **$(join(fieldnames(typeof(samples)), " or "))**! This might be a simple task for us, but a computer needs a little help.
"""

# ╔═╡ 447a66cc-f810-11ea-232b-b305f81c18c7
@bind mystery_sample TextField((70,8), default="""
Small boats are typically found on inland waterways such as rivers and lakes, or in protected coastal areas. However, some boats, such as the whaleboat, were intended for use in an offshore environment. In modern naval terms, a boat is a vessel small enough to be carried aboard a ship. Anomalous definitions exist, as lake freighters 1,000 feet (300 m) long on the Great Lakes are called "boats". 
""")

# ╔═╡ e36130e0-f810-11ea-0356-0b1f3c4a0952
mystery_sample

# ╔═╡ 0c2ae3bc-f812-11ea-2293-7f163abe3068
md"""
To solve this problem, we are going to use the **transition table** of our mystery sample.
"""

# ╔═╡ b3500898-f812-11ea-0b42-4f5b423aedb4
transition_frequencies(mystery_sample)

# ╔═╡ b95122b8-f812-11ea-3c76-3bf3da662878
distances = map(samples) do sample
	norm(transition_frequencies(mystery_sample) - transition_frequencies(sample))
end

# ╔═╡ ad56108a-f813-11ea-1e2d-95b7bb283684
let
	md"## It looks like this text is **$(argmin(distances))**!"
end

# ╔═╡ 6d312e7a-f815-11ea-124f-536b635be4c4
html"<br><br><br><br>"

# ╔═╡ 04016302-f815-11ea-225a-37d552cd5d96
md"# Other languages

Throughout this notebook, we used `samples`, without making assumptions about the actual names of the languages. This is not just for mathematical kicks - writing general code means that it can be directly applied to new problems!

So go back to the first cell, and **add a third language**, or change **English** and **Spanish** to somthing else!"

# ╔═╡ 99c43952-f80e-11ea-2311-1785e5235f4e
md"# Appendix"

# ╔═╡ Cell order:
# ╠═f265e1b8-f80f-11ea-0948-d3839ef76fec
# ╟─47ce8ae2-f80d-11ea-37b4-09cc683b7aed
# ╟─885c7800-f80e-11ea-1527-9f29ddd5386a
# ╠═4540e0d0-f80c-11ea-02ae-83ff44d36c32
# ╠═8e44b382-f80d-11ea-327e-99848e0dfa57
# ╠═d0d59182-f80b-11ea-32d3-f7082c9435b2
# ╠═9486a88c-f80c-11ea-182f-13e736e85a36
# ╟─9206be10-f80e-11ea-3623-23666142bd11
# ╠═671dfd22-f80d-11ea-39f0-890de621f49a
# ╠═b884f9f4-f80d-11ea-2877-5393935837ed
# ╠═a47e19a8-f80e-11ea-11a4-156874552d40
# ╠═aaa1a0ca-f80e-11ea-33c7-211c8a2e6179
# ╠═a519ef58-f80f-11ea-2cd2-e770894aa82f
# ╟─497eb560-f810-11ea-3c8a-9f12212fef49
# ╠═08293478-f810-11ea-01c6-cba5aed0377c
# ╠═d2638e8e-f80e-11ea-32a5-63acf5eb5606
# ╟─ad51b844-f810-11ea-08ce-2df3ff878d4e
# ╟─bd244202-f80e-11ea-274e-e7c7238bf7d3
# ╟─ecbc6ea6-f80e-11ea-20e9-71e2a730f996
# ╟─9f0d61e0-f80e-11ea-3b70-11dbacaf5a45
# ╟─e4fdfdf2-f810-11ea-3f71-9fdbf6d16fcf
# ╟─447a66cc-f810-11ea-232b-b305f81c18c7
# ╠═e36130e0-f810-11ea-0356-0b1f3c4a0952
# ╟─0c2ae3bc-f812-11ea-2293-7f163abe3068
# ╠═b3500898-f812-11ea-0b42-4f5b423aedb4
# ╠═b95122b8-f812-11ea-3c76-3bf3da662878
# ╟─ad56108a-f813-11ea-1e2d-95b7bb283684
# ╟─6d312e7a-f815-11ea-124f-536b635be4c4
# ╟─04016302-f815-11ea-225a-37d552cd5d96
# ╟─99c43952-f80e-11ea-2311-1785e5235f4e
