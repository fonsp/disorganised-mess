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

# ╔═╡ cbf50820-1929-11eb-1353-fd694a1d3289
md"
# Raytracing set 1

This homework set will be a combination of different concepts for raytracing in 2D and will be comprised of 3 distinct problems with appropriate sub-problems

1. Timestepping with refraction
    1. Creating a Ray struct with the ability to move the simulation forward with time
    2. Implementing a refraction function and the concept of lenses

2. Event-driven mirror
    1. Determining when a ray interacts with a wall
    2. Implementing a reflection function and allowing light to bounce off the mirror

3. Event-driven spherical aberration
    1. Determining when a ray interacts with a sphere
    2. Creating spherical aberration image
"

# ╔═╡ acf4c5a6-ca9a-11ea-26c8-f740c13dcd83
md"
## Problem 1: Timestepping with Refraction

This homework problem aims to provide a detailed understanding of light as photons moving forward with time. As mentioned in the lecture, this is not the stereotypical form of raytracing; however, it provides the fundamentals for understanding timestepping, along with refraction.

### Problem 1a: Creating a Ray struct and the ability to move the simulation forward with time.

With this problem, we are ultimately working towards understanding how light moves forward with time, that is to say, we are interested in rewriting the following equation in code:

$x_1 = x_0 + \hat v dt.$

Here, $x_1$ is the ray's next position, $x_0$ is it's current position, $v$ is it's velocity, and $dt$ is a timestep. This equation basically says that every timestep, light moves forward a certain distance, and that distance is dictated by it's velocity,

$v = \frac{3.0\times 10^8 \text{meters/second}}{\text{Index of Refraction}} \hat\ell,$

where $\hat \ell$ is the light's direction and the Index of Refraction is determined depending on the medium. For air, it's roughly 1, but for water, it's roughly 1.33. This means tht light is moving 1.33 times *slower* in water than it is in air.

To start, define a struct `Ray` that takes the light's direction vector $\hat \ell$, it's position vector `p`, and the index of refraction at it's current location `ior`:
"

# ╔═╡ 24b0d4ba-192c-11eb-0f66-e77b544b0510
struct Photon
	"Position vector"
	p::Vector{Float64}

	"Direction vector"
	v::Vector{Float64}

    "Current Index of Refraction"
	ior::Real
end

# ╔═╡ 45499234-192c-11eb-2257-cff3b45fb0c9
md"
Now we need to create a `step!()` Simply put, this function should implement the following equation:

$x_1 = x_0 + \frac{\hat \ell}{\text{Index of Refraction}}dt,$

At this point, some people might be scratching their head and asking, 'what happened to the speed of light? $3.0\times10^8$? isn't that the actual speed that light is going?'

Yes, it is; however, light moves *really fast*. More than that, we are only really intrerested in it's *relative motion* to other rays around it. In addition, we control how small we want the timestep to be in our simulations... So in practice, we absorb the speed of light into the $dt$ term, such that

$dt_{true} = \frac{dt_{input}}{3.0\times10^8},$

where $dt_{true}$ is the *true, physically accurate timestep, and $dt_{input}$ is the timestep we actually input into the code.

So, now let's get to writing that step function:
"

# ╔═╡ 25d7e220-19cc-11eb-3a7c-f39290800b14
c = 3e1

# ╔═╡ 5ed52588-192c-11eb-2255-2d951196701b
function photon_step(photon::Photon, timestep::Real)
	
	Photon(photon.p + photon.v * timestep * c, photon.v, photon.ior)
end

# ╔═╡ e148565e-19c8-11eb-39c6-196ba4adbbe3
test_photon = Photon(
	[15.0, 2.0],
	normalize([1.0, 1.0]),
	1.0,
)

# ╔═╡ 198db3d0-19c9-11eb-3a94-fb412dafe96f
photon_step(test_photon, 1)

# ╔═╡ d912b92e-1930-11eb-29dd-5d3a3cec6e8c
md"
Now that we have the concept of a ray and a way to move them forward one step at a time, we need a function that will allow us to propagate light forward with time for $n$ timesteps and track their positions, which will be returned at the end of the function:
"

# ╔═╡ 864d35e0-19c9-11eb-2f5d-df89a4ffa506
step(0:.1:1)

# ╔═╡ 2ca39110-19c9-11eb-383b-c7332b442697
function propagate(photon::Photon, T::AbstractRange)
	accumulate(T, init=photon) do old_photon, t
		photon_step(old_photon, step(T))
	end
end

# ╔═╡ b33e14fc-1933-11eb-342e-eb576c7871f0
function propagate!(photon::Photon, dt, n)
	# Enter code here
end

# ╔═╡ b14ff3e0-19c9-11eb-116a-bfce94704f36
function plot_photon_path!(p::Plots.Plot, ray::Vector{Photon}; kwargs...)
	positions = [photon.p for photon in ray]
	plot!(p, first.(positions), last.(positions); kwargs...)
end

# ╔═╡ 3e509920-1934-11eb-2a57-bff78f50083b
md"
At this stage, we should be able to shoot a bunch of rays of light in some direction and wath them for a number of timesteps, so we need 2 things:

1. A function to plot all the ray positions
2. A function to send the rays off in some direction

Let's start with 1:
"

# ╔═╡ b4eb38ba-1934-11eb-21d2-ddab2cec65f2
# function plot_rays(positions)
# 	plt = plot(background_color=:black, aspect_ratio=:equal)
# 	for i = 1:size(positions)[1]
#         plot!(plt, (positions[i,:,1], positions[i,:,2]); label = "ray",
#               linecolor=:white)
#     end
# 	plt
# end

# ╔═╡ b596c0f4-1934-11eb-16e6-e9177d663b82
md"
Now we will send a bunch of rays of light off exclusively in the x direction, but different y positions. This should create a set of parallel rays, all moving to the left. When plotted, it should look like a sheet music.

This fucntion should take the number of rays, number of timesteps, the timestep size, and the filename to output to
"

# ╔═╡ 124a7b2e-1935-11eb-15b1-133d0bb72a8b
# function parallel_propagate(ray_num, n, dt)
# 	# Write code here
# end

# ╔═╡ 584ce620-1935-11eb-177a-f75d9ad8a399
md"""
Now we should have the ability to create a bunch of rays and move them forward with time. Now onto the next problem...

### Problem 1b: Implementing a refraction function and the concept of lenses

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

$\cos(\theta_2) = \sqrt{1-\sin(\theta_s)^2} = \sqrt{1-\frac{n_1}{n_2}\left(1-\cos(\theta_1)^2\right)}.$

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

# ╔═╡ 311000fe-19cb-11eb-2a63-0f82ba6527f8
# function photon_step(photon::Photon, timestep::Real, new_ior::Real)
	
# 	Photon(photon.p + photon.v * timestep, photon.v, photon.ior)
# end

# ╔═╡ 4a27d346-1937-11eb-0204-2bb4e253b8b0
function refract(ray::Photon, normal, new_ior)
	r = ray.ior / new_ior
	
	new_velocity = normalize(
		r * ray.v + 
		(r*c - sqrt(1 - r^2 * (1 - c^2))) * normal
		)
	
	Photon(ray.p, new_velocity, new_ior)
end

# ╔═╡ 823f957e-19cc-11eb-2bb4-35ebc3fc236e
test_photon.v

# ╔═╡ a4b06ae0-19cc-11eb-1a29-e9873a414c6b


# ╔═╡ 0b1d1182-193e-11eb-001d-69ac3c3712ae
md"
Now we just need to send a bunch of rays of light onto the surface of the water. The big question to ask ourselves now is, 'When, exactly, do we refract?'

The answer is: Whenever we are in the new medium! But how do we know that?

For now, let's just assume that the floor is water. Anything below 0 is in water. If our ray's location is under 0 and it's current index of refraction is different than the index of refraction of water, we refract.
"

# ╔═╡ 62ce4f10-193e-11eb-315f-af11f868ebc0
function water_refract()
end

# ╔═╡ 16747b00-19cb-11eb-3b16-ad3ef8e8ba96


# ╔═╡ 71b70da6-193e-11eb-0bc4-f309d24fd4ef
md"

Now to move on to lenses. Like in lecture, we will focus exclusively on spherical lenses. Ultimately, there isn't a big difference between a lens and a spherical drop of water. It just has a slightly different refractive index and it's normal is defined slightly differently.

For this, we will create an abstract type of Object that can take in both spheres and mirrors. The sphere will take 3 variables, a position vector `p`, a radius `r`, and an index of refraction `ior`:
"

# ╔═╡ 333d815a-193f-11eb-0f43-b515f8055468
abstract type Object end

# ╔═╡ 3aa539ce-193f-11eb-2a0f-bbc6b83528b7
struct Sphere <: Object
	# Position
	center::Vector{Float64}
	
	# Radius
	radius::Real
	
	# Index of refraction
	ior::Real
end

# ╔═╡ 54b81de0-193f-11eb-004d-f90ec43588f8
md"
Now we need a few auxiliary functions to find the normal at any position and whether we are inside of the sphere or not.

Firstly, the normal. Remember that the normal will always be pointing perpendicularly from the surface of the sphere. This means that no matter what point you are at, the normal will just be a normalized vector of your current location minus the sphere's position:
"

# ╔═╡ 6fdf613c-193f-11eb-0029-957541d2ed4d
function sphere_normal_at(p::Vector{Float64}, s::Sphere)
	normalize(p - s.center)
end

# ╔═╡ e5c0e960-19cc-11eb-107d-39b397a783ab
test_sphere = Sphere(
	[6, 0.6],
	2,
	1.5,
)

# ╔═╡ cea1ef8c-193f-11eb-2e35-ed266690b762
md"
Now to see if we are inside the sphere, which is a necessary element of how we implemented refraction from before.

For this, we simply need to ask ourselves if the $x$ and $y$ elements of our current position are within the sphere. In other words:

$(x_s-x_r)^2+(y_s-y_r) < r^2.$

Here, subscripts $s$ and $r$ are for sphere and ray, respectively.
"

# ╔═╡ 7053586c-193f-11eb-3d89-7174b9680818
function isinside(p::Vector{Float64}, s::Sphere)
	# write code here
	
	sum((p .- s.center).^2) <= s.radius^2
end

# ╔═╡ 0f188812-19d0-11eb-1fa5-57e31f84e4c2
isinside(p::Photon, x) = isinside(p.p, x)

# ╔═╡ 2dde274a-1940-11eb-3a96-29005cfef14b
md"
So now we have all the necessary elements to send a parallel bunch of rays at a sphere and create a semi-focusing event known as spherical aberration!

Let's do it!

This time, I'm not going to give you function arguments. Just go with the flow and model it off of the `parallel_propagate(...)` function from above!
"

# ╔═╡ 52ae6b8e-1940-11eb-267d-73fc8df8dfe9
function spherical_aberration()
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

# ╔═╡ aa05d0ae-19cd-11eb-054f-9321fca4e5a6
ex_1_scene = [
	Sphere(
		[6, 0],
		2,
		5,
	),
	# Sphere(
	# 	[17, 0],
	# 	5,
	# 	1.5,
	# ),
]

# ╔═╡ 92290e54-1940-11eb-1a24-5d1eaee9f6ca
md"
That's it for problem 1! Now on to problem 2, where we deal with events and mirrors!

## Problem 2: Event-driven mirror

As discussed in lecture, event-driven simulations are the traditional method used for raytracing. Here, we look for any objects in our path and analytically determine how far away they are. From there, we take one big timestep all the way to the surface boundary, calculate refraction or reflection to see what direction we are moving in, and then seek out any other object we could potentially run into.

So let's start simple with determining when a ray of light could intersect with a wall

### Problem 2a: Determining when a ray interacts with a wall

To start, let's create the concept of a wall. Similar to Spheres, these will be Objects that rays can hit. For our purposes, walls will be infinitely long, so we only need to create an object that has a position and a normal vector at that position:
"

# ╔═╡ 99c61b74-1941-11eb-2323-2bdb7c120a28
struct Wall <: Object
	# Position
	position::Vector{Float64}

	# Normal vector
	normal::Vector{Float64}
end

# ╔═╡ 0906b340-19d3-11eb-112c-e568f69deb5d
test_wall = Wall(
	[8,-1],
	normalize([-3,1]),
)

# ╔═╡ 84895a42-19d3-11eb-1a2f-d934246e07bf


# ╔═╡ 6544be90-19d3-11eb-153c-218025f738c6
snoopy = Photon([0, 1], normalize([1,.1]), 1.0)

# ╔═╡ 8acef4b0-1a09-11eb-068d-79a259244ed1
struct Miss end

# ╔═╡ 8018fbf0-1a05-11eb-3032-95aae07ca78f
struct Intersection{T<:Object}
	object::T
	distance::Float64
	point::Vector{Float64}
end

# ╔═╡ aa19faa4-1941-11eb-2b61-9b78aaf42876
function intersection(ray::Photon, wall::Wall; ϵ=1e-3)
	dist = -dot(ray.p - wall.position, wall.normal) / dot(ray.v, wall.normal)
	
	if dist > ϵ
		point = ray.p + dist * ray.v
		
		Intersection(wall, dist, point)
	else
		Miss()
	end
end

# ╔═╡ 93a5691e-1a01-11eb-3a29-a71a2b48ae14
func

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

# ╔═╡ d257a728-1a04-11eb-281d-bde30644f5f5
ex_2_scene_walls = [
	Wall(
		[10,0],
		[-1,0]
		),
	Wall(
		[-10,0],
		[1,0]
		),
	Wall(
		[0,10],
		[0,-1]
		),
	Wall(
		[0,-10],
		[0,1]
		),
	]

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
plot_scene(ex_2_scene_walls, legend=false, size=(400,200))

# ╔═╡ 2158a356-1a05-11eb-3f5b-4dfa810fc602
ex_2_scene = [ex_2_scene_walls..., test_wall]

# ╔═╡ 5501a700-19ec-11eb-0ded-53e41f7f821a
plot_scene(ex_2_scene, legend=false, size=(400,200))

# ╔═╡ 80e889d4-1a09-11eb-2240-15bddf3b61bc
Miss() < Miss()

# ╔═╡ 6c37c5f4-1a09-11eb-08ae-9dce752f29cb
begin
	Base.isless(a::Miss, b::Miss) = false
	Base.isless(a::Miss, b::Intersection) = false
	Base.isless(a::Intersection, b::Miss) = true
	Base.isless(a::Intersection, b::Intersection) = a.distance < b.distance
end

# ╔═╡ 3cd36ac0-1a09-11eb-1818-75b36e67594a
@bind mirror_test_ray_N Slider(1:30; default=4)

# ╔═╡ b6614d80-194b-11eb-1edb-dba3c29672f8
md"
Now we can find the intersection point of rays of light and a wall. The next step is to modify the propagate function to stop after a certain number of intersections instead of a certain number of timesteps and to allow for different objects. Essentially, we search through all the provided objects and ask if the ray intersects with them. If so, we return the intersection point. Otherwise, we return nothing and do not step the ray forward.
"

# ╔═╡ 711a5ea2-194c-11eb-2e66-079f417ef3bb
md"
Now let's send a few rays of light at a wall and make sure they hit at the right location.

For this, create a bunch of rays of light, some of which intersect and otherse of which don't and make sure the ones that should interact, do interact. Those that shouldn't interact should not interact.

I would recommend using the Test package in Julia for this.
"

# ╔═╡ b9db412c-194c-11eb-2c65-2bc84ff1e699
function intersection_test()
end

# ╔═╡ dad5acfa-194c-11eb-27f9-01f40342a681
md"
Now on to the next problem...

### Problem 2b: Implementing a reflection function and allowing light to bounce off the mirror

For this one, we need to implement a reflection function. This one is way easier than refraction. All we need to do is find how much of the light is moving in the direction of the surface's normal and subtract that twice.

$\ell_1 = \ell_0 - 2(\ell_0\cdot \hat n)\hat n$

Now we just need to write that in code:
"

# ╔═╡ 43306bd4-194d-11eb-2e30-07eabb8b29ef
function reflect(velocity::Vector{Float64}, normal::Vector{Float64})
	velocity - 2 * dot(velocity, normal) * normal
end

# ╔═╡ e70b9e24-1a07-11eb-13db-b95c07880893
function interact(ray::Photon, hit::Intersection{Wall})
	
	Photon(hit.point, reflect(ray.v, hit.object.normal), ray.ior)
end

# ╔═╡ 522e6b22-194d-11eb-167c-052e65f6b703
md"
Now we're going to make a bold claim: All walls in this simulation are mirrors. This is just for simplicity so we don't need to worry about rays stopping at the boundaries.

This means we need to update our propagate function so that if the ray interacts with something of type Wall, it reflects
"

# ╔═╡ a45e1012-194d-11eb-3252-bb89daed3c8d
md"
With that, we should be able to create a mirror that points diagonally (normal of $(-1/\sqrt{2}, 1/\sqrt{2})$), and shoot rays at them to make sure they reflect upwards!
"

# ╔═╡ a459fcb6-194d-11eb-3563-3bfddc789075
function mirror_check()
end

# ╔═╡ e0bb335a-194d-11eb-3b14-73b478a94a53
md"
And that's that! Now on to the last problem

## Problem 3: Event-driven spherical aberration

For this, the first step is determining when a ray will intersect with a sphere... So let's start with

### Problem 3a: Determining when a ray interacts with a sphere

This one is a bit more challenging than the intersction with the wall, in particular because there are 3 potential outcomes of a line interacting with a sphere:
1. No intersection
2. 1 intersection
3. 2 intersections

As shown below:
"

# ╔═╡ 337918f4-194f-11eb-0b45-b13fef3b23bf
PlutoUI.Resource("https://upload.wikimedia.org/wikipedia/commons/6/67/Line-Sphere_Intersection_Cropped.png")

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

"

# ╔═╡ 885ac814-1953-11eb-30d9-85dcd198a1d8
function intersection(ray::Photon, sphere::Sphere; ϵ=1e-3)
	a = dot(ray.v, ray.v)
	b = 2 * dot(ray.v, ray.p - sphere.center)
	c = dot(ray.p - sphere.center, ray.p - sphere.center) - sphere.radius^2
	
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
		
		point = ray.p + t * ray.v
		
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
function closest_hit(ray::Photon, objects::Vector{<:Object})
	hits = intersection.([ray], objects)
	
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

# ╔═╡ 14dc73d2-1a0d-11eb-1a3c-0f793e74da9b
function refract(velocity::Vector{Float64}, normal::Vector{Float64},
	old_ior, new_ior)
	
	r = new_ior / old_ior
	
	# this probably isn't correct but it _feels right_
	# just a placeholder
	normalize(velocity + (r - 1)*normal * sign(dot(velocity, normal)))
end

# ╔═╡ 6b5aaee0-19cc-11eb-0113-8fdd40620b5f
refract(test_photon, [0,1], 5)

# ╔═╡ 8f295f30-19cf-11eb-2854-d3bf221b55c0
function interact(photon::Photon, old_photon::Photon, sphere::Sphere)
	if isinside(photon, sphere) && !isinside(old_photon, sphere)
		refract(photon, sphere_normal_at(photon.p, sphere), sphere.ior)
	elseif !isinside(photon, sphere) && isinside(old_photon, sphere)
		refract(photon, sphere_normal_at(photon.p, sphere), 1.0)
	else
		photon
	end
end

# ╔═╡ c25caf08-1a13-11eb-3c4d-0567faf4e662
md"""
We use `ray.ior == 1.0` to check whether this is a ray _entering_ or _leaving_ the sphere.
"""

# ╔═╡ e1cb1622-1a0c-11eb-224c-559af7b90f49
function interact(ray::Photon, hit::Intersection{Sphere})
	old_ior = ray.ior
	new_ior = if ray.ior == 1.0
		hit.object.ior
	else
		1.0
	end
	
	normal = sphere_normal_at(hit.point, hit.object)
	
	Photon(hit.point, refract(ray.v, normal, old_ior, new_ior), new_ior)
end

# ╔═╡ a1280a9e-19d0-11eb-2dbb-b93196307957
function propagate(photon::Photon, T::AbstractRange, objects)
	accumulate(T, init=photon) do old_photon, t
		new_photon = photon_step(old_photon, step(T))
		reduce(objects; init=new_photon) do p, obj
			interact(p, old_photon, obj)
		end
	end
end

# ╔═╡ 76ef6e46-1a06-11eb-03e3-9f40a86dc9aa
function step_ray(ray::Photon, objects::Vector{<:Object})
	hit = closest_hit(ray, objects)
	
	interact(ray, hit)
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
ex_3_scene = [test_sphere, ex_2_scene_walls...]

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
Now we can put it all together into an image of spherical aberration!

### Problem 3b: Creating spherical aberration image

Firstly, we need to go back to the propagate function from before and add in a caveat for when we interact with the sphere. Similar to how we stated that all walls are mirrors, we will make the assumption that all spheres are lenses. Don't worry, we will make it more interesting next week!
"

# ╔═╡ 4bae5810-19c9-11eb-184f-dd279bbd9142
test_path = propagate(test_photon, 0:.1:1)

# ╔═╡ 378da510-19ca-11eb-16d5-875fdc674d78
let
	p = plot(legend=false, aspect_ratio=:equal)
	
	T = 0:.1:3
	
	for (i,ϕ) in enumerate(LinRange(0,2π, 20))
		start = Photon(
			[30cos(ϕ), 30sin(ϕ)],
			normalize([cos(ϕ+1), sin(ϕ+1)]),
			1.0
		)
		scatter!(p, start.p[1:1], start.p[2:2], color=i)
		ray = propagate(start, T)
		plot_photon_path!(p, ray; color=i)
	end
	p
end

# ╔═╡ d564d820-19d0-11eb-18b0-01fbb50038d2
propagate(test_photon, 0:.1:1, ex_1_scene)

# ╔═╡ dcfd9b12-19cd-11eb-0938-41f7279f52ca
let
	p = plot_scene(ex_1_scene, legend=false)
	
	T = 0:.01:.5
	
	for y in LinRange(-1.6,-1.6,1)
		start = Photon([0, y], [1,0], 1.0)
		
		ray = propagate(start, T, ex_1_scene)
		plot_photon_path!(p, ray)
	end
	
	p
end

# ╔═╡ d49ddea2-19d0-11eb-0aeb-9dce91de6fb7
propagate(Photon([0, 1], [1,0], 1.0), 0:.01:.5, ex_1_scene)

# ╔═╡ f5cce52a-cab2-11ea-07ea-ef2b5e48ece4
md"
Once this is done, we should create a bounding box of 4 mirrors and a sphere inside of them. Then we just need to create a bunch of rays of light that all point towards the sphere, similar to the `parallel_propagate(...)` function from before.

Once this is done, you should see a spherical aberration image!
"

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

# ╔═╡ 867e6168-1a11-11eb-1434-570cbfe4d49b
md"""
# Note to James

Hi James!

I did not finish it today, but what I did do is go through all the exercises and write out solutions in a way that kind of matches what they learned in the previous weeks.

I also made a mess of the notebook, sorry 😢

---

There is a green post-it before Problem 1 and before Problem 2 to go over the main changes that I made. Let me know what you think!

""" |> correct

# ╔═╡ ec7638e0-19c3-11eb-1ca1-0b3aa3b40240
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ ec85c940-19c3-11eb-3375-a90735beaec1
TODO = html"<span style='display: inline; font-size: 2em; color: purple; font-weight: 900;'>TODO</span>"

# ╔═╡ 3149791e-1a00-11eb-042d-67adb29b3da0
md"""
# $TODO fonsi's idea for problem 1 :

The problem as it is right now is too difficult, but a solution would be to onyl use a single circle.

Instead of only refracting at a timestep where the lens boundary is crossed, we refract at every timestep. In most timesteps, the ior before and after the timestep are the same, so nothing happens.

Only using one lens makes the code a lot easier, because the normal vector for refraction does not depend on which circle is being refracted from.

---

The plotting functions will be pre-written, and the `struct`s too.

---

I worked more on Problem 2 and 3, maybe read those first
""" |> correct

# ╔═╡ 78782214-1a13-11eb-348a-7b0c819898a9
md"""
$TODO this isn't correct yet, very WIP
"""

# ╔═╡ 19c6d3ae-1a0f-11eb-0e7a-4768e080408a
md"""
# $TODO fonsi's idea for problem 2 :

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

# ╔═╡ aa43ef1c-1941-11eb-04de-552719a08da0
md"""
Now to create a function that finds the location where we hit the wall.
As a note, this part can be done in a number of different ways. For the purposes of this homework, we will allow this function to return 2 things: $TODO
1. The location it hit the wall
2. A value of `nothing` if it does not intersect with the wall

So, how do we find the location where it hits the wall? Well, because our walls are infinitely long, we are essentially trying to find the point at which 2 lines intersect.

To do this, we can combine a few dot products: one to find how far away we are, and another to scale that distance. Mathematically, it would look like:

$p_i = -\frac{(p_{\text{ray}} - p_{\text{wall}})\cdot \hat n}{\hat \ell \cdot \hat n},$

where $p$ is the position, $\hat \ell$ is the direction of the light, and $\hat n$ is the normal vector for the wall. subscripts $i$, $r$, and $w$ represent the intersection point, ray, and wall respectively.

In code, we essentially need to find $x_i$ and return it if it is positive and finite.
"""

# ╔═╡ 42a54138-1a01-11eb-285b-25b72e75a8bd
md"""
$TODO ``p_i`` is the distance that the ray needs to travel before it hits the wall, right? Then we should also say that `ray.p + p_i * ray.v` will give the collision point
"""

# ╔═╡ b157247e-1a0c-11eb-3980-bdaaa74f7aff
md"""
$TODO add some more (at least visual) test cases: 
- miss the ball, 
- start after the ball, 
- start inside the ball
"""

# ╔═╡ 53eaf592-194c-11eb-09e5-d9dbca43a006
function propagate(ray::Ray, objects::Vector{O}, n) where {O <: Object}
	
end

# ╔═╡ ed140a84-caa9-11ea-25f3-dd19092088fb
function propagate(ray::Ray, objects::Vector{O}, n) where {O <: Object}
end

# ╔═╡ 9157a1ea-194d-11eb-0058-edbd6aa098e3
function propagate(ray::Ray, objects::Vector{O}, n) where {O <: Object}
end

# ╔═╡ Cell order:
# ╟─1df32310-19c4-11eb-0824-6766cd21aaf4
# ╟─1df82c20-19c4-11eb-0959-8543a0d5630d
# ╟─1e01c912-19c4-11eb-269a-9796cccdf274
# ╟─867e6168-1a11-11eb-1434-570cbfe4d49b
# ╟─1e109620-19c4-11eb-013e-1bc95c14c2ba
# ╟─1e202680-19c4-11eb-29a7-99061b886b3c
# ╟─1e2cd0b0-19c4-11eb-3583-0b82092139aa
# ╠═c3e52bf2-ca9a-11ea-13aa-03a4335f2906
# ╟─cbf50820-1929-11eb-1353-fd694a1d3289
# ╠═3149791e-1a00-11eb-042d-67adb29b3da0
# ╟─acf4c5a6-ca9a-11ea-26c8-f740c13dcd83
# ╠═24b0d4ba-192c-11eb-0f66-e77b544b0510
# ╟─45499234-192c-11eb-2257-cff3b45fb0c9
# ╠═25d7e220-19cc-11eb-3a7c-f39290800b14
# ╠═5ed52588-192c-11eb-2255-2d951196701b
# ╠═e148565e-19c8-11eb-39c6-196ba4adbbe3
# ╠═198db3d0-19c9-11eb-3a94-fb412dafe96f
# ╟─d912b92e-1930-11eb-29dd-5d3a3cec6e8c
# ╠═864d35e0-19c9-11eb-2f5d-df89a4ffa506
# ╠═2ca39110-19c9-11eb-383b-c7332b442697
# ╠═4bae5810-19c9-11eb-184f-dd279bbd9142
# ╠═b33e14fc-1933-11eb-342e-eb576c7871f0
# ╠═b14ff3e0-19c9-11eb-116a-bfce94704f36
# ╠═378da510-19ca-11eb-16d5-875fdc674d78
# ╟─3e509920-1934-11eb-2a57-bff78f50083b
# ╠═b4eb38ba-1934-11eb-21d2-ddab2cec65f2
# ╟─b596c0f4-1934-11eb-16e6-e9177d663b82
# ╠═124a7b2e-1935-11eb-15b1-133d0bb72a8b
# ╟─584ce620-1935-11eb-177a-f75d9ad8a399
# ╟─78915326-1937-11eb-014f-fff29b3660a0
# ╠═311000fe-19cb-11eb-2a63-0f82ba6527f8
# ╠═4a27d346-1937-11eb-0204-2bb4e253b8b0
# ╠═823f957e-19cc-11eb-2bb4-35ebc3fc236e
# ╠═6b5aaee0-19cc-11eb-0113-8fdd40620b5f
# ╠═a4b06ae0-19cc-11eb-1a29-e9873a414c6b
# ╟─0b1d1182-193e-11eb-001d-69ac3c3712ae
# ╠═62ce4f10-193e-11eb-315f-af11f868ebc0
# ╠═16747b00-19cb-11eb-3b16-ad3ef8e8ba96
# ╟─71b70da6-193e-11eb-0bc4-f309d24fd4ef
# ╠═333d815a-193f-11eb-0f43-b515f8055468
# ╠═3aa539ce-193f-11eb-2a0f-bbc6b83528b7
# ╟─54b81de0-193f-11eb-004d-f90ec43588f8
# ╠═6fdf613c-193f-11eb-0029-957541d2ed4d
# ╠═e5c0e960-19cc-11eb-107d-39b397a783ab
# ╟─cea1ef8c-193f-11eb-2e35-ed266690b762
# ╠═7053586c-193f-11eb-3d89-7174b9680818
# ╠═0f188812-19d0-11eb-1fa5-57e31f84e4c2
# ╟─2dde274a-1940-11eb-3a96-29005cfef14b
# ╠═52ae6b8e-1940-11eb-267d-73fc8df8dfe9
# ╠═caa98732-19cd-11eb-04ce-2f018275cf01
# ╠═8f295f30-19cf-11eb-2854-d3bf221b55c0
# ╠═a1280a9e-19d0-11eb-2dbb-b93196307957
# ╟─d564d820-19d0-11eb-18b0-01fbb50038d2
# ╠═aa05d0ae-19cd-11eb-054f-9321fca4e5a6
# ╟─78782214-1a13-11eb-348a-7b0c819898a9
# ╠═dcfd9b12-19cd-11eb-0938-41f7279f52ca
# ╠═d49ddea2-19d0-11eb-0aeb-9dce91de6fb7
# ╟─19c6d3ae-1a0f-11eb-0e7a-4768e080408a
# ╟─92290e54-1940-11eb-1a24-5d1eaee9f6ca
# ╠═99c61b74-1941-11eb-2323-2bdb7c120a28
# ╠═0906b340-19d3-11eb-112c-e568f69deb5d
# ╠═e45e1d36-1a12-11eb-2720-294c4be6e9fd
# ╟─aa43ef1c-1941-11eb-04de-552719a08da0
# ╟─42a54138-1a01-11eb-285b-25b72e75a8bd
# ╠═aa19faa4-1941-11eb-2b61-9b78aaf42876
# ╠═84895a42-19d3-11eb-1a2f-d934246e07bf
# ╠═6544be90-19d3-11eb-153c-218025f738c6
# ╠═8acef4b0-1a09-11eb-068d-79a259244ed1
# ╠═8018fbf0-1a05-11eb-3032-95aae07ca78f
# ╠═a306e880-19eb-11eb-0ff1-d7ef49777f63
# ╠═93a5691e-1a01-11eb-3a29-a71a2b48ae14
# ╠═6de1bafc-1a01-11eb-3d67-c9d9b6c3cea8
# ╠═d257a728-1a04-11eb-281d-bde30644f5f5
# ╠═0393dd3a-1a06-11eb-18a9-494ae7a26bc0
# ╠═eff9329e-1a05-11eb-261f-734127d36750
# ╠═2158a356-1a05-11eb-3f5b-4dfa810fc602
# ╠═5501a700-19ec-11eb-0ded-53e41f7f821a
# ╠═3663bf80-1a06-11eb-3596-8fbbed28cc38
# ╠═76ef6e46-1a06-11eb-03e3-9f40a86dc9aa
# ╠═80e889d4-1a09-11eb-2240-15bddf3b61bc
# ╠═6c37c5f4-1a09-11eb-08ae-9dce752f29cb
# ╠═c3090e4a-1a09-11eb-0f32-d3bbfd9992e0
# ╠═754eeec4-1a07-11eb-1329-8d9ae0948613
# ╠═e70b9e24-1a07-11eb-13db-b95c07880893
# ╠═9f73bfb6-1a06-11eb-1c02-43331228da14
# ╠═900d6622-1a08-11eb-1475-bfadc2aac749
# ╠═3cd36ac0-1a09-11eb-1818-75b36e67594a
# ╠═1ee0787e-1a08-11eb-233b-43a654f70117
# ╟─b6614d80-194b-11eb-1edb-dba3c29672f8
# ╠═53eaf592-194c-11eb-09e5-d9dbca43a006
# ╟─711a5ea2-194c-11eb-2e66-079f417ef3bb
# ╠═b9db412c-194c-11eb-2c65-2bc84ff1e699
# ╟─dad5acfa-194c-11eb-27f9-01f40342a681
# ╠═43306bd4-194d-11eb-2e30-07eabb8b29ef
# ╟─522e6b22-194d-11eb-167c-052e65f6b703
# ╠═9157a1ea-194d-11eb-0058-edbd6aa098e3
# ╠═a45e1012-194d-11eb-3252-bb89daed3c8d
# ╠═a459fcb6-194d-11eb-3563-3bfddc789075
# ╟─e0bb335a-194d-11eb-3b14-73b478a94a53
# ╟─337918f4-194f-11eb-0b45-b13fef3b23bf
# ╟─492b257a-194f-11eb-17fb-f770b4d3da2e
# ╠═885ac814-1953-11eb-30d9-85dcd198a1d8
# ╠═251f0262-1a0c-11eb-39a3-09be67091dc8
# ╠═83aa9cea-1a0c-11eb-281d-699665da2b4f
# ╟─b157247e-1a0c-11eb-3980-bdaaa74f7aff
# ╠═14dc73d2-1a0d-11eb-1a3c-0f793e74da9b
# ╟─c25caf08-1a13-11eb-3c4d-0567faf4e662
# ╠═e1cb1622-1a0c-11eb-224c-559af7b90f49
# ╠═c492a1f8-1a0c-11eb-2c38-5921c39cf5f8
# ╠═b65d9a0c-1a0c-11eb-3cd5-e5a2c4302c7e
# ╠═b3ab93d2-1a0b-11eb-0f5a-cdca19af3d89
# ╟─c00eb0a6-cab2-11ea-3887-070ebd8d56e2
# ╠═ed140a84-caa9-11ea-25f3-dd19092088fb
# ╟─f5cce52a-cab2-11ea-07ea-ef2b5e48ece4
# ╟─ebd05bf0-19c3-11eb-2559-7d0745a84025
# ╟─ec275590-19c3-11eb-23d0-cb3d9f62ba92
# ╟─ec31dce0-19c3-11eb-1487-23cc20cd5277
# ╟─ec3ed530-19c3-11eb-10bb-a55e77550d1f
# ╟─ec4abc12-19c3-11eb-1ca4-b5e9d3cd100b
# ╟─ec57b460-19c3-11eb-2142-07cf28dcf02b
# ╟─ec5d59b0-19c3-11eb-0206-cbd1a5415c28
# ╟─ec698eb0-19c3-11eb-340a-e319abb8ebb5
# ╟─ec7638e0-19c3-11eb-1ca1-0b3aa3b40240
# ╟─ec85c940-19c3-11eb-3375-a90735beaec1
