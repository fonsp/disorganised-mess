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

# ╔═╡ c3e52bf2-ca9a-11ea-13aa-03a4335f2906
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
			Pkg.PackageSpec(name="Plots", version="1.6-1"),
			Pkg.PackageSpec(name="PlutoUI", version="0.6.8-0.6"),
			])
	using Plots
	using PlutoUI
	using LinearAlgebra
end

# ╔═╡ 1df32310-19c4-11eb-0824-6766cd21aaf4
md"_homework 7, version 0_"

# ╔═╡ 1e01c912-19c4-11eb-269a-9796cccdf274
# WARNING FOR OLD PLUTO VERSIONS, DONT DELETE ME

html"""
<script>
const warning = html`
<h2 style="color: #800">Oopsie! You need to update Pluto to the latest version</h2>
<p>Close Pluto, go to the REPL, and type:
<pre><code>julia> import Pkg
julia> Pkg.update("Pluto")
</code></pre>
`

const super_old = window.version_info == null || window.version_info.pluto == null
if(super_old) {
	return warning
}
const version_str = window.version_info.pluto.substring(1)
const numbers = version_str.split(".").map(Number)
console.log(numbers)

if(numbers[0] > 0 || numbers[1] > 12 || numbers[2] > 1) {
	
} else {
	return warning
}

</script>

"""

# ╔═╡ 1e109620-19c4-11eb-013e-1bc95c14c2ba
md"""

# **Homework 7**: _Raytracing in 2D_
`18.S191`, fall 2020

This notebook contains _built-in, live answer checks_! In some exercises you will see a coloured box, which runs a test case on your code, and provides feedback based on the result. Simply edit the code, run it, and the check runs again.

_For MIT students:_ there will also be some additional (secret) test cases that will be run as part of the grading process, and we will look at your notebook and write comments.

Feel free to ask questions!
"""

# ╔═╡ 1e202680-19c4-11eb-29a7-99061b886b3c
# edit the code below to set your name and kerberos ID (i.e. email without @mit.edu)

student = (name = "Jazzy Doe", kerberos_id = "jazz")

# you might need to wait until all other cells in this notebook have completed running. 
# scroll around the page to see what's up

# ╔═╡ 1df82c20-19c4-11eb-0959-8543a0d5630d
md"""

Submission by: **_$(student.name)_** ($(student.kerberos_id)@mit.edu)
"""

# ╔═╡ 1e2cd0b0-19c4-11eb-3583-0b82092139aa
md"_Let's create a package environment:_"

# ╔═╡ 333d815a-193f-11eb-0f43-b515f8055468
abstract type Object end

# ╔═╡ 99c61b74-1941-11eb-2323-2bdb7c120a28
struct Wall <: Object
	"Position"
	position::Vector{Float64}

	"Normal vector"
	normal::Vector{Float64}
end

# ╔═╡ 0906b340-19d3-11eb-112c-e568f69deb5d
test_wall = Wall(
	[8,-1],
	normalize([-3,1]),
)

# ╔═╡ 6de1bafc-1a01-11eb-3d67-c9d9b6c3cea8
function plot_object!(p, wall::Wall)
	# old_xlims = xlims(p)
	# old_ylims = ylims(p)
	
	adjacent = [wall.normal[2], -wall.normal[1]]
	
	a = wall.position + adjacent * 20
	b = wall.position - adjacent * 20
	
	line = [a, b]
	
	plot!(p, first.(line), last.(line), label="Wall")
	# xlims!(p, old_xlims)
	# xlims!(p, old_xlims)
end

# ╔═╡ 5f551588-1ac4-11eb-1f86-197442f1ef1d
md"""
In our simulations, we will enclose our scene in a box of **four walls**, to make sure that no rays can escape the scene. We have written this box (i.e. vector of walls) below, but we are still missing the roof.
"""

# ╔═╡ d257a728-1a04-11eb-281d-bde30644f5f5
box_scene = [
	Wall(
		[10,0],
		[-1,0]
		),
	Wall(
		[-10,0],
		[1,0]
		),
	Wall(
		[0,-10],
		[0,1]
		),
	Wall(
		[0,10],
		[0,-1]
		),
	]

# ╔═╡ ac9bafaa-1ac4-11eb-16c4-0df8133f9c98
# box_scene = [
# 	Wall(
# 		[10,0],
# 		[-1,0]
# 		),
# 	Wall(
# 		[-10,0],
# 		[1,0]
# 		),
# 	Wall(
# 		[0,-10],
# 		[0,1]
# 		),
# 	# your code here
# 	]

# ╔═╡ 293776f8-1ac4-11eb-21db-9d023c09e89f
md"""
👉 Modify the definition of `box_scene` to be a vector of 4 walls, instead of 3. The fourth wall should be positioned at `[0,10]`, and point downwards.
"""

# ╔═╡ 24b0d4ba-192c-11eb-0f66-e77b544b0510
struct Photon
	"Position vector"
	p::Vector{Float64}

	"Direction vector"
	l::Vector{Float64}

    "Current Index of Refraction"
	ior::Real
end

# ╔═╡ aa43ef1c-1941-11eb-04de-552719a08da0
md"""
$(html"<br><br><br><br>")
#### Exercise 1.2 - _how far is the wall?_
We will write a function that finds the location where a photon hits the wall. Instead of moving the photon forward in small timesteps until we reach the wall, we will compute the intersection directly, making use of the fact that the wall is a geometrically simple object.

Our function will return one of two possible types: a `Miss` or a `Intersection`. We define these types below, and both definitions need some elaboration.
"""

# ╔═╡ 8acef4b0-1a09-11eb-068d-79a259244ed1
struct Miss end

# ╔═╡ 8018fbf0-1a05-11eb-3032-95aae07ca78f
struct Intersection{T<:Object}
	object::T
	distance::Float64
	point::Vector{Float64}
end

# ╔═╡ e9c5d68c-1ac2-11eb-04ec-3b72eb133239
md"""
##### `Miss` 
is a struct with _no fields_. It does not contain any information, except the fact that it is a `Miss`. You create a new `Miss` object like so:
"""

# ╔═╡ 5a9d00f6-1ac3-11eb-01fb-53c35796e766
a_miss = Miss()

# ╔═╡ 5aa7c4e8-1ac3-11eb-23f3-03bd58e75c4b
md"""
##### `Intersection`
is a **parametric type**. The first field (`object`) is of type `T`, and `T` is a subtype of `Object`. 

We also could have used `Object` directly as the type for the field `object`. But what's special about parametric types is that `T` becomes "part of the type". Let's have a look at an example:
"""

# ╔═╡ 9df1d0f2-1ac3-11eb-0eac-d90eccca669c
test_intersection_1 = Intersection(test_wall, 3.0, [1.0,2.0])

# ╔═╡ bc10541e-1ac3-11eb-0b5f-916922f1a8e8
typeof(test_intersection_1)

# ╔═╡ d39f149e-1ac3-11eb-39a2-41c2030d7d49
md"""
You see that `Wall` is **included in the type**. This will be very useful later, when we want to do something different _depending on the intersected object_ (wall, sphere, etc.) using multiple dispatch. We can write one method for `::Intersection{Sphere}`, and one for `::Intersection{Wall}`.
"""

# ╔═╡ e135d490-1ac2-11eb-053e-914051f16e31
md"""
 $(html"<br><br>")

##### Wall geometry
So, how do we find the location where it hits the wall? Well, because our walls are infinitely long, we are essentially trying to find the point at which 2 lines intersect.

To do this, we can combine a few dot products: one to find how far away we are, and another to scale that distance. Mathematically, it would look like:

$D = -\frac{(p_{\text{ray}} - p_{\text{wall}})\cdot \hat n}{\hat \ell \cdot \hat n},$

where $p$ is the position, $\hat \ell$ is the direction of the light, and $\hat n$ is the normal vector for the wall. subscripts $i$, $r$, and $w$ represent the intersection point, ray, and wall respectively. The result is $D$, the amount that the photon needs to travel until it hits the wall.

👉 Write a function `intersection_distance` that implements this formula, and returns $D$. You can use `dot(a,b)` to compute the vector dot product ``a \cdot b``.
"""

# ╔═╡ f76ab794-1ac9-11eb-26e3-b9d0baa05d49
function intersection_distance(photon::Photon, wall::Wall)
	-dot(photon.p - wall.position, wall.normal) / dot(photon.l, wall.normal)
end

# ╔═╡ 42d65f56-1aca-11eb-1079-e32f85554349
md"""
 $(html"<br><br><br><br>")
#### Exercise 1.3 - _hitting the wall_

👉 Write a function `intersection` that takes a `photon` and a `wall`, and returns either a `Miss` or an `Intersection`, based on the result of `intersection_distance(photon, wall)` ``= D``.

If $D$ is _positive_, then the photon will hit the wall, and we should return an `Intersection`. We already have the intersected object, and we have $D$, our intersection distance. To find the intersection _point_, we use the photon's position and velocity.

$p_{\text{intersection}} = p_{\text{ray}} + D\hat \ell$

If $D$ is _negative_ (or zero), then the wall is _behind_ the photon - we should return a `Miss`.

##### Floating points
We are using _floating points_ (`Float64`) to store positions, distances, etc., which means that we need to account for small errors. Like in the lecture, we will not check for `D > 0`, but `D > ϵ` with `ϵ = 1e-3`.
"""

# ╔═╡ aa19faa4-1941-11eb-2b61-9b78aaf42876
function intersection(photon::Photon, wall::Wall; ϵ=1e-3)
	D = intersection_distance(photon, wall)
	
	if D > ϵ
		point = photon.p + D * photon.l
		
		Intersection(wall, D, point)
	else
		Miss()
	end
end

# ╔═╡ 6544be90-19d3-11eb-153c-218025f738c6
snoopy = Photon([0, 1], normalize([1,.1]), 1.0)

# ╔═╡ 2158a356-1a05-11eb-3f5b-4dfa810fc602
ex_2_scene = [box_scene..., test_wall]

# ╔═╡ 711a5ea2-194c-11eb-2e66-079f417ef3bb
md"
Now let's send a few rays of light at a wall and make sure they hit at the right location.

For this, create a bunch of rays of light, some of which intersect and otherse of which don't and make sure the ones that should interact, do interact. Those that shouldn't interact should not interact.
"

# ╔═╡ d70380a4-1ad0-11eb-1184-f7e9b84a83ad
md"""
 $(html"<br><br><br><br>")
#### Exercise 1.4 - _which wall?_
"""

# ╔═╡ 6c37c5f4-1a09-11eb-08ae-9dce752f29cb
begin
	Base.isless(a::Miss, b::Miss) = false
	Base.isless(a::Miss, b::Intersection) = false
	Base.isless(a::Intersection, b::Miss) = true
	
	Base.isless(a::Intersection, b::Intersection) = a.distance < b.distance
end

# ╔═╡ e9c6a0b8-1ad0-11eb-1606-0319caf0948a
md"""
 $(html"<br><br><br><br>")
## **Exercise 2:** _Mirrors_
"""

# ╔═╡ 522e6b22-194d-11eb-167c-052e65f6b703
md"
Now we're going to make a bold claim: All walls in this simulation are mirrors. This is just for simplicity so we don't need to worry about rays stopping at the boundaries.

This means we need to update our propagate function so that if the ray interacts with something of type Wall, it reflects
"

# ╔═╡ dad5acfa-194c-11eb-27f9-01f40342a681
md"
#### Exercise 2.1 - _reflect_

For this one, we need to implement a reflection function. This one is way easier than refraction. All we need to do is find how much of the light is moving in the direction of the surface's normal and subtract that twice.

$\ell_1 = \ell_0 - 2(\ell_0\cdot \hat n)\hat n$

Now we just need to write that in code:
"

# ╔═╡ 43306bd4-194d-11eb-2e30-07eabb8b29ef
function reflect(velocity::Vector{Float64}, normal::Vector{Float64})
	velocity - 2 * dot(velocity, normal) * normal
end

# ╔═╡ b6614d80-194b-11eb-1edb-dba3c29672f8
md"""
#### Exercise 2.2 - _step_

Now we can find the intersection point of rays of light and a wall. The next step is to modify the propagate function to stop after a certain number of intersections instead of a certain number of timesteps and to allow for different objects. Essentially, we search through all the provided objects and ask if the ray intersects with them. If so, we return the intersection point. Otherwise, we return nothing and do not step the ray forward.
"""

# ╔═╡ e70b9e24-1a07-11eb-13db-b95c07880893
function interact(photon::Photon, hit::Intersection{Wall})
	
	Photon(hit.point, reflect(photon.l, hit.object.normal), photon.ior)
end

# ╔═╡ a45e1012-194d-11eb-3252-bb89daed3c8d
md"
With that, we should be able to create a mirror that points diagonally (normal of $(-1/\sqrt{2}, 1/\sqrt{2})$), and shoot rays at them to make sure they reflect upwards!
"

# ╔═╡ 7ba5dda0-1ad1-11eb-1c4e-2391c11f54b3
md"""
#### Exercise 2.3 - _accumulate_
"""

# ╔═╡ 3cd36ac0-1a09-11eb-1818-75b36e67594a
@bind mirror_test_ray_N Slider(1:30; default=4)

# ╔═╡ ba0a869a-1ad1-11eb-091f-916e9151f052
md"""
 $(html"<br><br><br><br>")

## **Exercise 3:** _Spheres_
Now that we know how to bounce light around mirrors, we want to simulate a _spherical lens_ to make things more interesting. Let's define a `Sphere`. 
"""

# ╔═╡ 3aa539ce-193f-11eb-2a0f-bbc6b83528b7
struct Sphere <: Object
	# Position
	center::Vector{Float64}
	
	# Radius
	radius::Real
	
	# Index of refraction
	ior::Real
end

# ╔═╡ caa98732-19cd-11eb-04ce-2f018275cf01
function plot_object!(p::Plots.Plot, sphere::Sphere)
	points = [
		sphere.center .+ sphere.radius .* [cos(ϕ), sin(ϕ)]
		for ϕ in LinRange(0,2π,50)
	]
	
	plot!(p, points .|> first, points .|> last, seriestype=:shape, label="Sphere", fillopacity=0.2)
	p
end

# ╔═╡ eff9329e-1a05-11eb-261f-734127d36750
function plot_scene(objects::Vector{<:Object}; kwargs...)
	p = plot(aspect_ratio=:equal; kwargs...)
	
	for o in objects
		plot_object!(p, o)
	end
	p
end

# ╔═╡ e45e1d36-1a12-11eb-2720-294c4be6e9fd
plot_scene([test_wall], size=(400,200))

# ╔═╡ 0393dd3a-1a06-11eb-18a9-494ae7a26bc0
plot_scene(box_scene, legend=false, size=(400,200))

# ╔═╡ 5501a700-19ec-11eb-0ded-53e41f7f821a
plot_scene(ex_2_scene, legend=false, size=(400,200))

# ╔═╡ e5c0e960-19cc-11eb-107d-39b397a783ab
test_sphere = Sphere(
	[6, 0.6],
	2,
	1.5,
)

# ╔═╡ 2a2b7284-1ade-11eb-3b71-d17fe2ca638a
plot_scene([test_sphere], size=(400,200), legend=false, xlim=(-10,10), ylim=(-6,6))

# ╔═╡ e2a8d1d6-1add-11eb-0da1-cda1492a950c
md"
#### Exercise 3.1
Just like with the `Wall`, our first step is to be able to find the intersection point of a ray of light and a sphere.

This one is a bit more challenging than the intersction with the wall, in particular because there are 3 potential outcomes of a line interacting with a sphere:
1. No intersection
2. 1 intersection
3. 2 intersections

As shown below:
"

# ╔═╡ 337918f4-194f-11eb-0b45-b13fef3b23bf
PlutoUI.Resource("https://upload.wikimedia.org/wikipedia/commons/6/67/Line-Sphere_Intersection_Cropped.png")

# ╔═╡ 885ac814-1953-11eb-30d9-85dcd198a1d8
function intersection(photon::Photon, sphere::Sphere; ϵ=1e-3)
	a = dot(photon.l, photon.l)
	b = 2 * dot(photon.l, photon.p - sphere.center)
	c = dot(photon.p - sphere.center, photon.p - sphere.center) - sphere.radius^2
	
	d = b^2 - 4*a*c
	
	if d <= 0
		Miss()
	else
		t1 = (-b-sqrt(d))/2a
		t2 = (-b+sqrt(d))/2a
		
		t = if t1 > ϵ
			t1
		elseif t2 > ϵ
			t2
		else
			return Miss()
		end
		
		point = photon.p + t * photon.l
		
		Intersection(sphere, t, point)
	end
end

# ╔═╡ a306e880-19eb-11eb-0ff1-d7ef49777f63
intersection(snoopy, test_wall)

# ╔═╡ 3663bf80-1a06-11eb-3596-8fbbed28cc38
let
	p = plot_scene(ex_2_scene, legend=false, xlim=(-11,11), ylim=(-11,11))
	
	hit = intersection(snoopy, test_wall)
	
	line = [snoopy.p, hit.point]
	plot!(p, first.(line), last.(line), lw=5)
	
	p
end

# ╔═╡ c3090e4a-1a09-11eb-0f32-d3bbfd9992e0
sort(intersection.([snoopy], ex_2_scene))

# ╔═╡ 754eeec4-1a07-11eb-1329-8d9ae0948613
function closest_hit(photon::Photon, objects::Vector{<:Object})
	hits = intersection.([photon], objects)
	
	minimum(hits)
end

# ╔═╡ 251f0262-1a0c-11eb-39a3-09be67091dc8
intersection(snoopy, test_sphere)

# ╔═╡ 83aa9cea-1a0c-11eb-281d-699665da2b4f
let
	p = plot_scene([test_sphere])
	
	hit = intersection(snoopy, test_sphere)
	
	line = [snoopy.p, hit.point]
	plot!(p, first.(line), last.(line), lw=5)
	
	p
end

# ╔═╡ 584ce620-1935-11eb-177a-f75d9ad8a399
md"""
 $(html"<br><br><br><br>")
## **Exercise 4:** _Lenses_

For this, we will start with refraction from the surface of water and then move on to a spherical lens. 

So, how does refraction work? Well, every time light enters a new medium that is more dense than air, it will bend towards the normal to the surface, like so:

$(RemoteResource("https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Snells_law2.svg/800px-Snells_law2.svg.png", :width=>200, :style=>"display: block; margin: auto;"))
"""

# ╔═╡ 78915326-1937-11eb-014f-fff29b3660a0
md"""
This can be described by Snell's law:

$\frac{n_1}{n_2} = \frac{v_2}{v_1} = \frac{\sin(\theta_2)}{\sin(\theta_1)}$

Here, $n$ is the index of refraction, $v$ is the speed (not velocity (sorry for the notation!)), and $\theta$ is the angle with respect to the surface normal. Any variables with an subscript of 1 are in the outer medium (air), and any variables with a subscript 2 are in the inner medium (water).

This means that we can find the angle of the new ray of light as

$\sin(\theta_2) = \frac{n_1}{n_2}\sin(\theta_1)$

The problem is that $\sin$ is slow, so we typically want to rewrite this in terms of vector operations. This means that we want to rewrite everything to be in terms of dot products, but because $A\cdot B = |A||B|cos(\theta)$, we really want to rewrite everything in terms of cosines first. So, using the fact that $\sin(\theta)^2 + \cos(\theta)^2 = 1$, we can rewrite the above equation to be:

$\sin(\theta_2) = \frac{n_1}{n_2}\sqrt{1-\cos(\theta_1)^2}$

We also know that 

$\cos(\theta_2) = \sqrt{1-\sin(\theta_2)^2} = \sqrt{1-\left(\frac{n_1}{n_2}\right)^2\left(1-\cos(\theta_1)^2\right)}.$

Finally, we know that the new light direction should be the same as the old one, but shifted towards (or away) from the normal according to the new refractive index.
In particular:

$n_2 \ell _2 = {n_1} \ell _1 + (n_1\cos(\theta_1)-n_2\cos(\theta_2))\hat n,$

where $\hat n$ is the normal from the water's surface. Rewriting this, we find:

$\ell _2 = \left(\frac{n_1}{n_2}\right) \ell _1 + \left(\left(\frac{n_1}{n_2}\right)\cos(\theta_1)-\cos(\theta_2)\right)\hat n.$

Now, we already know $\cos(\theta_2)$ in terms of $\cos(\theta_1)$, so we can just plug that in... But first, let's do some simplifications, such that 

$r = \frac{n_1}{n_2}$

and

$c = -\hat n \cdot \ell_1.$

Now, we can rewrite everything such that

$\ell_2 = r\ell_1 + \left(rc-\sqrt{1-r^2(1-c^2)}\right)\hat n.$

The last step is to write this in code with a function that takes the ray, the normal, and the index of refraction ration `r`:
"""

# ╔═╡ 14dc73d2-1a0d-11eb-1a3c-0f793e74da9b
function refract(velocity::Vector{Float64}, normal::Vector{Float64},
	old_ior, new_ior)
	
	r = old_ior / new_ior
	
	n = if -dot(velocity, normal) < 0
		-normal
	else
		normal
	end
	
	c = -dot(velocity, n)
	
	f = 1 - r^2 * (1 - c^2)
	
	normalize(r * velocity + (r*c - sqrt(f)) * n)
end

# ╔═╡ 71b70da6-193e-11eb-0bc4-f309d24fd4ef
md"

Now to move on to lenses. Like in lecture, we will focus exclusively on spherical lenses. Ultimately, there isn't a big difference between a lens and a spherical drop of water. It just has a slightly different refractive index and it's normal is defined slightly differently.

For this, we will create an abstract type of Object that can take in both spheres and mirrors. The sphere will take 3 variables, a position vector `p`, a radius `r`, and an index of refraction `ior`:
"

# ╔═╡ 54b81de0-193f-11eb-004d-f90ec43588f8
md"
Now we need a few auxiliary functions to find the normal at any position and whether we are inside of the sphere or not.

Firstly, the normal. Remember that the normal will always be pointing perpendicularly from the surface of the sphere. This means that no matter what point you are at, the normal will just be a normalized vector of your current location minus the sphere's position:
"

# ╔═╡ 6fdf613c-193f-11eb-0029-957541d2ed4d
function sphere_normal_at(p::Vector{Float64}, s::Sphere)
	normalize(p - s.center)
end

# ╔═╡ 392c25b8-1add-11eb-225d-49cfca27bef4
md"""
👉 Write a new method for `interact` that takes a `photon` and a `hit` of type `Intersection{Sphere}`, that implements refraction. It returns a new `Photon` positioned at the hit point, with the refracted velocity and the new index of refraction.
"""

# ╔═╡ e1cb1622-1a0c-11eb-224c-559af7b90f49
function interact(photon::Photon, hit::Intersection{Sphere})
	old_ior = photon.ior
	new_ior = if photon.ior == 1.0
		hit.object.ior
	else
		1.0
	end
	
	normal = sphere_normal_at(hit.point, hit.object)
	
	Photon(hit.point, refract(photon.l, normal, old_ior, new_ior), new_ior)
end

# ╔═╡ 76ef6e46-1a06-11eb-03e3-9f40a86dc9aa
function step_ray(photon::Photon, objects::Vector{<:Object})
	hit = closest_hit(photon, objects)
	
	interact(photon, hit)
end

# ╔═╡ 9f73bfb6-1a06-11eb-1c02-43331228da14
step_ray(snoopy, ex_2_scene)

# ╔═╡ 900d6622-1a08-11eb-1475-bfadc2aac749
accumulate(1:5; init=snoopy) do old_photon, i
		step_ray(old_photon, ex_2_scene)
	end

# ╔═╡ 1ee0787e-1a08-11eb-233b-43a654f70117
let
	p = plot_scene(ex_2_scene, legend=false, xlim=(-11,11), ylim=(-11,11))
	
	path = accumulate(1:mirror_test_ray_N; init=snoopy) do old_photon, i
		step_ray(old_photon, ex_2_scene)
	end
	
	line = [snoopy.p, [r.p for r in path]...]
	plot!(p, first.(line), last.(line), lw=5)
	
	p
end |> as_svg

# ╔═╡ c492a1f8-1a0c-11eb-2c38-5921c39cf5f8
@bind sphere_test_ray_N Slider(1:30; default=4)

# ╔═╡ b3ab93d2-1a0b-11eb-0f5a-cdca19af3d89
ex_3_scene = [test_sphere, box_scene...]

# ╔═╡ b65d9a0c-1a0c-11eb-3cd5-e5a2c4302c7e
let
	p = plot_scene(ex_3_scene, legend=false, xlim=(-11,11), ylim=(-11,11))
	
	path = accumulate(1:sphere_test_ray_N; init=snoopy) do old_photon, i
		step_ray(old_photon, ex_3_scene)
	end
	
	line = [snoopy.p, [r.p for r in path]...]
	plot!(p, first.(line), last.(line), lw=5, color=:red)
	
	p
end |> as_svg

# ╔═╡ c00eb0a6-cab2-11ea-3887-070ebd8d56e2
md"
#### Spherical aberration
Now we can put it all together into an image of spherical aberration!
"

# ╔═╡ eb35ac4a-1acc-11eb-0729-ff85c8406c45
@bind aberration_viz_ior Slider(1.0:0.0001:5.0, show_value=true)

# ╔═╡ bff04784-1acc-11eb-36c2-9335a58be23a
function aberration_viz(ior)
	s = Sphere([5,0], 1, ior)
	aberration_scene = [s, box_scene...]
	
	p = plot_scene(aberration_scene, legend=false, xlim=(3,8), ylim=(-1.5,1.5))
	
	for y in LinRange(-0.9, 0.9, 8)
		start = Photon([0,y], [1,0], 1.0)
		
		path = accumulate(1:3; init=start) do old_photon, i
			step_ray(old_photon, aberration_scene)
		end
		
		line = [start.p, [r.p for r in path]...]
		plot!(p, first.(line), last.(line), lw=2, color=:darkred)
	end

	p |> as_svg
end

# ╔═╡ f83da7f8-1acc-11eb-02d7-f33ffe518531
aberration_viz(aberration_viz_ior)

# ╔═╡ ebd05bf0-19c3-11eb-2559-7d0745a84025
if student.name == "Jazzy Doe" || student.kerberos_id == "jazz"
	md"""
	!!! danger "Before you submit"
	    Remember to fill in your **name** and **Kerberos ID** at the top of this notebook.
	"""
end

# ╔═╡ ec275590-19c3-11eb-23d0-cb3d9f62ba92
md"## Function library

Just some helper functions used in the notebook."

# ╔═╡ ec31dce0-19c3-11eb-1487-23cc20cd5277
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ c25caf08-1a13-11eb-3c4d-0567faf4e662
md"""
You can use `ray.ior == 1.0` to check whether this is a ray _entering_ or _leaving_ the sphere.
""" |> hint

# ╔═╡ ec3ed530-19c3-11eb-10bb-a55e77550d1f
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ ec4abc12-19c3-11eb-1ca4-b5e9d3cd100b
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ ec57b460-19c3-11eb-2142-07cf28dcf02b
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ ec5d59b0-19c3-11eb-0206-cbd1a5415c28
yays = [md"Fantastic!", md"Splendid!", md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."]

# ╔═╡ ec698eb0-19c3-11eb-340a-e319abb8ebb5
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ 19c6d3ae-1a0f-11eb-0e7a-4768e080408a
md"""
# description of what i changed in these exercises

This is a cool exercise! I made two changes/additions:

### Intersection type

Instead of slowly building up a `propagate` function with a growing if statement, we use types and multiple dispatch to build up functionality. The main idea is that we have a new type:


```julia
struct Intersection{T<:Object}
	object::T
	distance::Float64
	point::Vector{Float64}
end

```

that contains the intersection result. It is a possible return type of the `intersection(::Photon, ::Object)` function. Because it is a _parametric_ type, we can later dispatch on the type of object that the intersection happened on, and do something different (i.e. refract / reflect) based on this type.

#### Sorting intersections

We also introduce a second type to signify a miss:

```julia
struct Miss end
```

We could create an abstract type `MaybeIntersection` that is the supertype of `Miss` and `Intersection`, but this is not necessary.

And we define methods to compare different `MaybeIntersection`s:

```julia
Base.isless(a::Miss, b::Miss) = false
Base.isless(a::Miss, b::Intersection) = false
Base.isless(a::Intersection, b::Miss) = true
Base.isless(a::Intersection, b::Intersection) = a.distance < b.distance
```

This allows us to get the closest intersection using:
```julia
minimum(vect_of_intersections)
```

Neat!

This allows us to naturally extend our work to ex 3, where we add methods to existing functions to support spheres.
""" |> correct

# ╔═╡ 0e9a240c-1ac5-11eb-1a7e-b3c43c459484
let
	if length(box_scene) != 4
		keep_working()
	elseif !(box_scene isa Vector{Wall})
		keep_working(md"`box_scene` should be a Vector of `Wall` objects.")
	else
		w = last(box_scene)
		
		if w.position != [0,10]
			keep_working(md"The wall's position is not correct.")
		elseif w.normal != [0,-1]
			keep_working(md"The wall's direction is not correct.")
		else
			correct()
		end
	end
end

# ╔═╡ 0787f130-1aca-11eb-24b4-2ff2ddd0bc48
let
	p = Photon([5,0], [1,0], 1.0)
	w = Wall([10,10], normalize([-1,-1]))
	
	result = intersection_distance(p, w)
	
	
	if result isa Missing
		still_missing()
	elseif !(result isa Real)
		keep_working(md"You need to return a number.")
	else
		if abs(result - (20 - 5)) > 0.1
			if abs(-result - (20 - 5)) > 0.1
				keep_working(md"The returned distance is not correct.")
			else
				keep_working(md"Did you forget the minus sign?")
			end
		else
			correct()
		end
	end
end

# ╔═╡ 038d5e88-1ac7-11eb-2020-a9d7e19feebc
let
	p = Photon([5,0], [1,0], 1.0)
	w = Wall([10,10], normalize([-1,-1]))
	
	result = intersection(p, w)
	
	
	if result isa Missing
		still_missing()
	elseif !(result isa Miss || result isa Intersection)
		keep_working(md"You need to return a `Miss` or a `Intersection`.")
	else
		if result isa Miss
			keep_working(md"You returned a `Miss` for a photon that hit the wall.")
		else
			if abs(result.distance - (20 - 5)) > 0.1
				keep_working(md"The returned distance is not correct.")
			else
				
				correct()
			end
		end
	end
end

# ╔═╡ ec7638e0-19c3-11eb-1ca1-0b3aa3b40240
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ ec85c940-19c3-11eb-3375-a90735beaec1
TODO = html"<span style='display: inline; font-size: 2em; color: purple; font-weight: 900;'>TODO</span>"

# ╔═╡ 92290e54-1940-11eb-1a24-5d1eaee9f6ca
md"""
$TODO talk about timestepping

## **Exercise 1:** _Walls_

As discussed in lecture, event-driven simulations are the traditional method used for raytracing. Here, we look for any objects in our path and analytically determine how far away they are. From there, we take one big timestep all the way to the surface boundary, calculate refraction or reflection to see what direction we are moving in, and then seek out any other object we could potentially run into.

So let's start simple with determining when a ray of light could intersect with a wall

#### Exercise 1.1 - _what is a wall?_

To start, let's create the concept of a wall. Similar to Spheres, these will be Objects that rays can hit. For our purposes, walls will be infinitely long, so we only need to create an object that has a position and a normal vector at that position:
"""

# ╔═╡ 4e535f52-1ac8-11eb-163c-7b26f4896650
md"""
$TODO more tests, dont make them hidden
"""

# ╔═╡ 492b257a-194f-11eb-17fb-f770b4d3da2e
md"
So we need a way of finding all of these.

To start, let's remember back to the `inside_of(...)` function we defined above. There, we stated that so long as the relative distance between the ray's tip and the sphere's center satisfies the sphere equation, we can be considered inside of the sphere. More specifically, we are inside the sphere if:

$(x_s-x_r)^2+(y_s-y_r) < r^2.$

where the $s$ and $r$ subscripts represent the sphere and ray, respectively. We know we are *on* the sphere if

$(x_s-x_r)^2+(y_s-y_r) = r^2.$

As has been the theme for this homework set, we can rewrite this in vector notation as:

$(\mathbf{R} - \mathbf{S})\cdot(\mathbf{R} - \mathbf{S}) = r^2,$

where $\mathbf{R}$ and $\mathbf{S}$ are the $x$, $y$, and $z$ location of the ray and sphere, respectively.

Returning to the timestepping example from above, we know that our ray is moving forward with time such that $\mathbf{R} = \mathbf{R}_0 + v dt = \mathbf{R}_0 + \ell t$. We now need to ask ourselves if there is any time when our ray interacts with the sphere. Plugging this in to the dot product from above, we get

$(\mathbf{R}_0 + \ell t - \mathbf{S})\cdot(\mathbf{R}_0 + \ell t - \mathbf{S}) = r^2$

To solve this for $t$, we first need to reorder everything into the form of a polynomial, such that:

$t^2(\ell\cdot\ell)+2t\ell\cdot(\mathbf{R_0}-\mathbf{S})+(\mathbf{R}_0-\mathbf{S})\cdot(\mathbf{R}_0-\mathbf{S}) - r^2=0.$

This can be solved with the good ol' fashioned quadratic equation:

$\frac{-b\pm\sqrt{b^2-4ac}}{2a},$

where $a = \ell\cdot\ell$, $b = 2\ell\cdot(\mathbf{R}_0-\mathbf{S})$, and $c=(\mathbf{R}_0-\mathbf{S})\cdot(\mathbf{R}_0-\mathbf{S}) - r^2$

If the quadratic equation returns no roots, there is no intersection. If it returns 1 root, the ray just barely hits the edge of the sphere. If it returns 2 roots, it goes right through!

The easiest way to check this is by looking at the discriminant $d = b^2-4ac$.

```math
\text{Number of roots} = \left\{
    \begin{align}
       &0, \qquad \text{if } d < 0 \\
       &1, \qquad \text{if } d = 0 \\
       &2, \qquad \text{if } d > 0 \\
    \end{align}
\right.
```

In the case that there are 2 roots, the second root corresponds to when the ray would interact with the far edge of the sphere *if there were no refraction or reflection!*; therefore, we only care about returning the closest point.

With all this said, we are ready to write some code:

👉 $TODO write a description for this exercise explaining what to do

"

# ╔═╡ 8cfa4902-1ad3-11eb-03a1-736898ff9cef
TODO_note(text) = Markdown.MD(Markdown.Admonition("warning", "TODO note", [text]))

# ╔═╡ 49d2b7de-1adc-11eb-0457-1998946eb71d
md"""
I have distributed the original paragraphs from James's draft throughout the notebook to where they are most appropriate, but most of them still need to be rewritten to match the current exercise.
""" |> TODO_note

# ╔═╡ 7ae770d2-1adc-11eb-0848-8b72bfbf5464
md"""
A visual test
""" |> TODO_note

# ╔═╡ b157247e-1a0c-11eb-3980-bdaaa74f7aff
md"""
$TODO add some more (at least visual) test cases: 
- miss the ball, 
- start after the ball, 
- start inside the ball
""" |> TODO_note

# ╔═╡ 333b7b84-1ad3-11eb-0741-e91314ada8ea
md"""
Perhaps we should just write this function ourselves? It was quite time consuming for me to get right, and there is no computer sciency lesson here.

---

What is missing in this description is that the normal needs to point in the opposite direction as the incoming velocity vector. So you need to **flip the normal** if `c < 0`. 

We can also refer to the derivation on Wikipedia:

[https://en.wikipedia.org/wiki/Snell%27s_law#Vector_form](https://en.wikipedia.org/wiki/Snell%27s_law#Vector_form)

(Or perhaps we did it in a lecture?)





""" |> TODO_note

# ╔═╡ Cell order:
# ╟─1df32310-19c4-11eb-0824-6766cd21aaf4
# ╟─1df82c20-19c4-11eb-0959-8543a0d5630d
# ╟─1e01c912-19c4-11eb-269a-9796cccdf274
# ╟─1e109620-19c4-11eb-013e-1bc95c14c2ba
# ╟─1e202680-19c4-11eb-29a7-99061b886b3c
# ╟─1e2cd0b0-19c4-11eb-3583-0b82092139aa
# ╠═c3e52bf2-ca9a-11ea-13aa-03a4335f2906
# ╟─19c6d3ae-1a0f-11eb-0e7a-4768e080408a
# ╟─49d2b7de-1adc-11eb-0457-1998946eb71d
# ╟─92290e54-1940-11eb-1a24-5d1eaee9f6ca
# ╠═333d815a-193f-11eb-0f43-b515f8055468
# ╠═99c61b74-1941-11eb-2323-2bdb7c120a28
# ╠═0906b340-19d3-11eb-112c-e568f69deb5d
# ╠═e45e1d36-1a12-11eb-2720-294c4be6e9fd
# ╟─6de1bafc-1a01-11eb-3d67-c9d9b6c3cea8
# ╟─eff9329e-1a05-11eb-261f-734127d36750
# ╟─5f551588-1ac4-11eb-1f86-197442f1ef1d
# ╠═d257a728-1a04-11eb-281d-bde30644f5f5
# ╠═ac9bafaa-1ac4-11eb-16c4-0df8133f9c98
# ╠═0393dd3a-1a06-11eb-18a9-494ae7a26bc0
# ╟─293776f8-1ac4-11eb-21db-9d023c09e89f
# ╟─0e9a240c-1ac5-11eb-1a7e-b3c43c459484
# ╠═24b0d4ba-192c-11eb-0f66-e77b544b0510
# ╟─aa43ef1c-1941-11eb-04de-552719a08da0
# ╠═8acef4b0-1a09-11eb-068d-79a259244ed1
# ╠═8018fbf0-1a05-11eb-3032-95aae07ca78f
# ╟─e9c5d68c-1ac2-11eb-04ec-3b72eb133239
# ╠═5a9d00f6-1ac3-11eb-01fb-53c35796e766
# ╟─5aa7c4e8-1ac3-11eb-23f3-03bd58e75c4b
# ╠═9df1d0f2-1ac3-11eb-0eac-d90eccca669c
# ╠═bc10541e-1ac3-11eb-0b5f-916922f1a8e8
# ╟─d39f149e-1ac3-11eb-39a2-41c2030d7d49
# ╟─e135d490-1ac2-11eb-053e-914051f16e31
# ╠═f76ab794-1ac9-11eb-26e3-b9d0baa05d49
# ╟─0787f130-1aca-11eb-24b4-2ff2ddd0bc48
# ╠═7ae770d2-1adc-11eb-0848-8b72bfbf5464
# ╟─42d65f56-1aca-11eb-1079-e32f85554349
# ╠═aa19faa4-1941-11eb-2b61-9b78aaf42876
# ╠═038d5e88-1ac7-11eb-2020-a9d7e19feebc
# ╠═4e535f52-1ac8-11eb-163c-7b26f4896650
# ╠═6544be90-19d3-11eb-153c-218025f738c6
# ╠═a306e880-19eb-11eb-0ff1-d7ef49777f63
# ╠═2158a356-1a05-11eb-3f5b-4dfa810fc602
# ╠═5501a700-19ec-11eb-0ded-53e41f7f821a
# ╠═3663bf80-1a06-11eb-3596-8fbbed28cc38
# ╟─711a5ea2-194c-11eb-2e66-079f417ef3bb
# ╟─d70380a4-1ad0-11eb-1184-f7e9b84a83ad
# ╠═6c37c5f4-1a09-11eb-08ae-9dce752f29cb
# ╠═c3090e4a-1a09-11eb-0f32-d3bbfd9992e0
# ╠═754eeec4-1a07-11eb-1329-8d9ae0948613
# ╟─e9c6a0b8-1ad0-11eb-1606-0319caf0948a
# ╟─522e6b22-194d-11eb-167c-052e65f6b703
# ╟─dad5acfa-194c-11eb-27f9-01f40342a681
# ╠═43306bd4-194d-11eb-2e30-07eabb8b29ef
# ╟─b6614d80-194b-11eb-1edb-dba3c29672f8
# ╠═e70b9e24-1a07-11eb-13db-b95c07880893
# ╠═76ef6e46-1a06-11eb-03e3-9f40a86dc9aa
# ╠═9f73bfb6-1a06-11eb-1c02-43331228da14
# ╠═a45e1012-194d-11eb-3252-bb89daed3c8d
# ╟─7ba5dda0-1ad1-11eb-1c4e-2391c11f54b3
# ╠═900d6622-1a08-11eb-1475-bfadc2aac749
# ╠═3cd36ac0-1a09-11eb-1818-75b36e67594a
# ╠═1ee0787e-1a08-11eb-233b-43a654f70117
# ╟─ba0a869a-1ad1-11eb-091f-916e9151f052
# ╠═3aa539ce-193f-11eb-2a0f-bbc6b83528b7
# ╟─caa98732-19cd-11eb-04ce-2f018275cf01
# ╠═e5c0e960-19cc-11eb-107d-39b397a783ab
# ╠═2a2b7284-1ade-11eb-3b71-d17fe2ca638a
# ╟─e2a8d1d6-1add-11eb-0da1-cda1492a950c
# ╟─337918f4-194f-11eb-0b45-b13fef3b23bf
# ╟─492b257a-194f-11eb-17fb-f770b4d3da2e
# ╠═885ac814-1953-11eb-30d9-85dcd198a1d8
# ╠═251f0262-1a0c-11eb-39a3-09be67091dc8
# ╠═83aa9cea-1a0c-11eb-281d-699665da2b4f
# ╠═b157247e-1a0c-11eb-3980-bdaaa74f7aff
# ╟─584ce620-1935-11eb-177a-f75d9ad8a399
# ╠═333b7b84-1ad3-11eb-0741-e91314ada8ea
# ╟─78915326-1937-11eb-014f-fff29b3660a0
# ╠═14dc73d2-1a0d-11eb-1a3c-0f793e74da9b
# ╟─71b70da6-193e-11eb-0bc4-f309d24fd4ef
# ╟─54b81de0-193f-11eb-004d-f90ec43588f8
# ╠═6fdf613c-193f-11eb-0029-957541d2ed4d
# ╟─392c25b8-1add-11eb-225d-49cfca27bef4
# ╟─c25caf08-1a13-11eb-3c4d-0567faf4e662
# ╠═e1cb1622-1a0c-11eb-224c-559af7b90f49
# ╟─c492a1f8-1a0c-11eb-2c38-5921c39cf5f8
# ╟─b65d9a0c-1a0c-11eb-3cd5-e5a2c4302c7e
# ╠═b3ab93d2-1a0b-11eb-0f5a-cdca19af3d89
# ╟─c00eb0a6-cab2-11ea-3887-070ebd8d56e2
# ╟─eb35ac4a-1acc-11eb-0729-ff85c8406c45
# ╟─f83da7f8-1acc-11eb-02d7-f33ffe518531
# ╟─bff04784-1acc-11eb-36c2-9335a58be23a
# ╟─ebd05bf0-19c3-11eb-2559-7d0745a84025
# ╟─ec275590-19c3-11eb-23d0-cb3d9f62ba92
# ╟─ec31dce0-19c3-11eb-1487-23cc20cd5277
# ╟─ec3ed530-19c3-11eb-10bb-a55e77550d1f
# ╟─ec4abc12-19c3-11eb-1ca4-b5e9d3cd100b
# ╟─ec57b460-19c3-11eb-2142-07cf28dcf02b
# ╟─ec5d59b0-19c3-11eb-0206-cbd1a5415c28
# ╠═ec698eb0-19c3-11eb-340a-e319abb8ebb5
# ╟─ec7638e0-19c3-11eb-1ca1-0b3aa3b40240
# ╟─ec85c940-19c3-11eb-3375-a90735beaec1
# ╠═8cfa4902-1ad3-11eb-03a1-736898ff9cef
