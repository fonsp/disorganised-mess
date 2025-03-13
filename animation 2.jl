### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ cee117f1-4d29-418d-9cf2-eabb9a94d24d
using MarkdownLiteral: @mdx

# ╔═╡ e99d66aa-e92e-480f-ad75-aadd112f9e9d
using HypertextLiteral

# ╔═╡ 644d6397-b439-43ec-8606-950b1e66bc70
function simulate_bouncing_ball(dt::Float64, t_max::Float64)
    g = 9.81  # Gravity (m/s²)
    e = 0.8   # Coefficient of restitution (bounce efficiency)
    
    x, y = 0.0, 10.0  # Initial position (starting height of 10m)
    vx, vy = 1.0, 0.0 # Initial velocity
    
    trajectory = Tuple{Float64,Float64}[]  # Store (x, y) positions
    t = 0.0
    
    while t < t_max
        push!(trajectory, (x, y))
        
        # Update position
        x += vx * dt
        y += vy * dt
        
        # Update velocity
        vy -= g * dt
        
        # Bounce on ground
        if y < 0
            y = 0
            vy = -vy * e
        end
        
        t += dt
    end
    
    return trajectory
end

# Example usage:

# ╔═╡ ba4b7899-7dbd-4d4d-8c55-4c71adde986c
trajectory = simulate_bouncing_ball(0.01, 25.0)

# ╔═╡ fb6713b1-4617-4a59-a04c-54e69737b4b0


# ╔═╡ 1f0b3cf5-a2b2-400e-b5fe-21ae83aa51fa


# ╔═╡ 74dd96dc-97bc-44a5-a939-23a7924aab2d


# ╔═╡ 9771b46c-059c-4360-9a99-b2df68eb13e5


# ╔═╡ 9f516785-33c5-4eeb-aa8b-48065c3162cd


# ╔═╡ e78d7213-7555-4267-9bb0-876a3d6f6302


# ╔═╡ fc852b52-f131-11ea-1caf-17c0da3dca45
begin
	
	struct Animation
		slides
		fps::Number
	end
	Animation(slides; fps=10) = Animation(slides, fps)
	
	
	function Base.show(io::IO, m::MIME"text/html", animation::Animation)

		

		id = String(rand('a':'z', 10))

		h = @htl """
		<div class="plutoui_slideshow">
			<input value=1 type=range min=1 max=$(length(animation.slides))>
		<pui-slides>
			$((
				@htl """
				<div>$(s)</div>
				"""
				for s in animation.slides
			))
		</pui-slides>
		<script>
		
		const root = currentScript.parentElement
		const input = root.querySelector("input")
		const slideshow = root.querySelector("pui-slides")
		const slides = Array.from(slideshow.children)
		
		slideshow.style.height = Math.max(...slides.map(s => s.scrollHeight)) + "px"


const showslide = (i) => {
	slides.forEach(s => s.style.display = "none")
	slides[i % slides.length].style.display = ""
}
			
		input.addEventListener("input", (e) => {
			showslide(input.value)
			
		})


		showslide(input.value)








			/*
		const handler = setInterval(() => {
		}, $(1000.0 / animation.fps))
		invalidation.then(() =>  {
			clearInterval(handler)
		})
			*/

		
		</script>
		</div>
		"""

		show(io, m, h)

	end
end

# ╔═╡ a5a1053c-f158-11ea-1597-c7d15683f012
Animation([
	"$i is smaller than $j"
	for i in 1:10
	for j in 10:20
])

# ╔═╡ 05105971-c3a4-4334-9e02-29f991217dfc
slider_map(f::Function, xs) = map(f, xs) |> Animation

# ╔═╡ 6c0b392e-5b33-46d9-bfe3-ca3564a1e058
slider_map(trajectory) do (x,y)
	@mdx """
	The classic Modelica "bouncing ball".  Press **THA** "Play" button to animate.
	
	Change the coefficient of resitution to see how it changes the bouncing of the ball.
	
	<svg height="400" width="100%" viewbox="0 0 400 400">
	  <circle cx=$( 100+x*25 ) cy=$( 100+7*25 -25*y ) r="40" stroke="black" stroke-width="3" fill="red" />
	  <rect x="0" y=$(140+7*25) width="400" height="10" stroke="black"/>
	</svg>
	
	<chart signals="h"></chart>
	"""
end

# ╔═╡ 98e2a45b-6b19-4800-9dfc-3e231df666d1


# ╔═╡ 7978fe4c-f158-11ea-19a0-491ee867c54f
@animate for i in 1:10
	for j in 10:20
		"$i is smaller than $j"
	end
end

# ╔═╡ 0ef8106a-f132-11ea-178a-19b0d521cf59
cool = [md"# Hello", md"# World", 
	html"how",
	html"<br>are",
	html"<br><br>you",
	html"<br><br><br>doing?",
	Gray.(fill(0.0, (100,100))),
	[Gray.(fill(0.1 * i, (100i,100i))) for i in 1:5]...
	]

# ╔═╡ 2832d92e-f133-11ea-1f04-d51d3cf072b1
Animation(cool; fps=5)

# ╔═╡ 1c337c36-f134-11ea-3063-71f3c442e041
load(download("https://fonsp.com/img/doggoSmall.jpg?raw=true"))

# ╔═╡ d2c77070-f133-11ea-1141-ede5ff754fe2
let
	x = RGB.(Gray.(fill(0.2, (200,200))))
	x[10,10] = RGB(1.0, 1.0, 1.0)
	x
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
MarkdownLiteral = "736d6165-7244-6769-4267-6b50796e6954"

[compat]
HypertextLiteral = "~0.9.5"
MarkdownLiteral = "~0.1.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.3"
manifest_format = "2.0"
project_hash = "0d21c4db76d94ef6fbe0aef164535775afb3d26a"

[[deps.CommonMark]]
deps = ["Crayons", "PrecompileTools"]
git-tree-sha1 = "3faae67b8899797592335832fccf4b3c80bb04fa"
uuid = "a80b9123-70ca-4bc0-993e-6e3bcb318db6"
version = "0.8.15"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.MarkdownLiteral]]
deps = ["CommonMark", "HypertextLiteral"]
git-tree-sha1 = "0d3fa2dd374934b62ee16a4721fe68c418b92899"
uuid = "736d6165-7244-6769-4267-6b50796e6954"
version = "0.1.1"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tricks]]
git-tree-sha1 = "6cae795a5a9313bbb4f60683f7263318fc7d1505"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.10"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"
"""

# ╔═╡ Cell order:
# ╟─644d6397-b439-43ec-8606-950b1e66bc70
# ╠═ba4b7899-7dbd-4d4d-8c55-4c71adde986c
# ╠═cee117f1-4d29-418d-9cf2-eabb9a94d24d
# ╠═6c0b392e-5b33-46d9-bfe3-ca3564a1e058
# ╟─fb6713b1-4617-4a59-a04c-54e69737b4b0
# ╟─1f0b3cf5-a2b2-400e-b5fe-21ae83aa51fa
# ╟─74dd96dc-97bc-44a5-a939-23a7924aab2d
# ╟─9771b46c-059c-4360-9a99-b2df68eb13e5
# ╟─9f516785-33c5-4eeb-aa8b-48065c3162cd
# ╟─e78d7213-7555-4267-9bb0-876a3d6f6302
# ╠═e99d66aa-e92e-480f-ad75-aadd112f9e9d
# ╠═fc852b52-f131-11ea-1caf-17c0da3dca45
# ╠═a5a1053c-f158-11ea-1597-c7d15683f012
# ╟─05105971-c3a4-4334-9e02-29f991217dfc
# ╠═98e2a45b-6b19-4800-9dfc-3e231df666d1
# ╠═7978fe4c-f158-11ea-19a0-491ee867c54f
# ╠═2832d92e-f133-11ea-1f04-d51d3cf072b1
# ╠═0ef8106a-f132-11ea-178a-19b0d521cf59
# ╠═1c337c36-f134-11ea-3063-71f3c442e041
# ╠═d2c77070-f133-11ea-1141-ede5ff754fe2
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
