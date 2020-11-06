### A Pluto.jl notebook ###
# v0.12.7

using Markdown
using InteractiveUtils

# ╔═╡ c3e52bf2-ca9a-11ea-13aa-03a4335f2906
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
			Pkg.PackageSpec(name="Plots", version="1.6-1"),
			Pkg.PackageSpec(name="PlutoUI", version="0.6.8-0.6"),
			Pkg.PackageSpec(name="Images", version="0.23"),
			Pkg.PackageSpec(name="ImageMagick"),
			])
	using Plots
	using PlutoUI
	using LinearAlgebra
	using Images
end

# ╔═╡ 1df32310-19c4-11eb-0824-6766cd21aaf4
md"_homework 8, version 1_"

# ╔═╡ 84d846d8-203a-11eb-3ab9-5ba145aa501c
md"""
# TODO:
1. Use scene instead of vector of Objects
2. Finish the step_ray function 
3. Transcripts for youtube lectures
"""

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

# **Homework 8**: _Raytracing in 3D_
`18.S191`, fall 2020

This notebook contains _built-in, live answer checks_! In some exercises you will see a coloured box, which runs a test case on your code, and provides feedback based on the result. Simply edit the code, run it, and the check runs again.

_For MIT students:_ there will also be some additional (secret) test cases that will be run as part of the grading process, and we will look at your notebook and write comments.

This particular homework will continue from the previous week's homework, so we will define a number of functions at the start of this homework set.

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

# ╔═╡ 4e917968-1f87-11eb-371f-e3899b76dc24
md"""
### Some minor bookkeeping

Before continuing, we need to comment on a few small changes from last notebook:
1. The concept of a `Photon` now carries color information and no longer carries the index of refraction. The reason we needed the index of refraction in the previous exercise was because it made the timestepping approach a little easier. In the case of a purely event-driven simulation, we no longer need it.
2. We will no longer be focusing on the spherical aberration example, so at some point in this notebook, that exercise might not be possible with the new framework.

Outside of these changes, all functions from the previous homework can be taken "as-is" when converting to 3D
"""

# ╔═╡ d851a202-1ca0-11eb-3da0-51fcb656783c
abstract type Object end

# ╔═╡ 24b0d4ba-192c-11eb-0f66-e77b544b0510
struct Photon
	"Position vector"
	p::Vector{Float64}

	"Direction vector"
	l::Vector{Float64}

	"Color associated with the photon"
	c::RGB
end

# ╔═╡ 8acef4b0-1a09-11eb-068d-79a259244ed1
struct Miss end

# ╔═╡ 8018fbf0-1a05-11eb-3032-95aae07ca78f
struct Intersection{T<:Object}
	object::T
	distance::Float64
	point::Vector{Float64}
end

# ╔═╡ 5a9d00f6-1ac3-11eb-01fb-53c35796e766
a_miss = Miss()

# ╔═╡ 43306bd4-194d-11eb-2e30-07eabb8b29ef
reflect(ℓ₁::Vector, n̂::Vector)::Vector = ℓ₁ - 2 * dot(ℓ₁, n̂) * n̂

# ╔═╡ 14dc73d2-1a0d-11eb-1a3c-0f793e74da9b
function refract(
		ℓ₁::Vector, n̂::Vector,
		old_ior, new_ior
	)
	
	r = old_ior / new_ior
	
	n̂_oriented = if -dot(ℓ₁, n̂) < 0
		-n̂
	else
		n̂
	end
	
	c = -dot(ℓ₁, n̂_oriented)
	
	normalize(r * ℓ₁ + (r*c - sqrt(1 - r^2 * (1 - c^2))) * n̂_oriented)
end

# ╔═╡ 452d6668-1ec7-11eb-3b0a-0b8f45b43fd5
md"""
## Exercise 6: Camera and Skyboxes

Now we can begin looking into the 3D nature of raytracing to create visualizations similar to those in lecture.
The first step is setting up the camera and another stuct known as a *sky box* to collect all the rays of light.

Luckily, the transition from 2D to 3D for raytracing is relatively straightforward and we can use all of the functions and concepts we have built in 2D moving forward.

Firstly, the camera:

"""

# ╔═╡ 791f0bd2-1ed1-11eb-0925-13c394b901ce
md"""
### Camera

For the purposes of this homework, we will constrain ourselves to a camera pointing exclusively downward.
This is simply because camera positioning can be a bit tricky and there is no reason to make the homework more complicated than it needs to be!

So, what is the purpose of the camera?

Well, in reality, a camera is a device that collects the color information from all the rays of light that are refracting and reflecting off of various objects in some sort of scene.
Because there are a nearly infinite number of rays bouncing around the scene at any time, we will actually constrain ourselves only to rays that are entering our camera.
In poarticular, we will create a 2D screen just in front of the camera and send a ray from the camera to each pixel in the screen, as shown in the following image:

$(RemoteResource("https://upload.wikimedia.org/wikipedia/commons/thumb/8/83/Ray_trace_diagram.svg/1920px-Ray_trace_diagram.svg.png", :width=>400, :style=>"display: block; margin: auto;"))
"""

# ╔═╡ 1a446de6-1ec9-11eb-1e2f-6f4376005d24
md"""
Because we are not considering camera motion for this exercise, we will assume that the image plane is constrained to the horizontal plane, but that the camera, itself, can be some distance behind it.
This distance from the image plane to the camera is called the *focal length* and is used to determine the field of view.

From here, it's clear we need to construct:
1. A camera struct
2. A function to initialize all the rays being generated by the camera

Let's start with the struct
"""

# ╔═╡ 88576c6e-1ecb-11eb-3e34-830aeb433df1
struct Camera <: Object
	"Set of all pixels, counts as scene resolution"
	pixels::Array{RGB,2}

	"Physical size of aperture"
	size::Vector{Float64}

	"Camera's distance from screen"
	focal_length::Float64

	"Camera's position"
	p::Vector{Float64}
end

# ╔═╡ 8f73824e-1ecb-11eb-0b28-4d1bc0eefbc3
md"""
Now we need to construct some method to create each individual ray extending from the camera to a pixel in the image plane.
This can be a little tricky becase we need to think about where the *center* of each pixel is.
For this, we need some concept of how large the image plane is in "real" coordinates along with the resolution (number of pixels).
From there, we know that

$$\text{Pixel size} = \frac{\text{Size}}{\text{Number of pixels in that direction}}$$

For example, if the image plane is of size $16\times9$ and of resolution $1920\times1080$, we know that the distance between pixels will be $16/1920 = 0.00833$ in $x$ and $9/1080 = 0.00833$ in $y$.
With these values, we can should be able to iterate through all pixel positions and find the centers.

As a final note, when finding the light direction, $\ell$ should be normalized to 1, so be sure to do that!

"""

# ╔═╡ 4006566e-1ecd-11eb-2ce1-9d1107186784
function init_rays(cam::Camera)
	# Camera resolution
	res = size(cam.pixels)
	
	# Physical size of the aperture
	dim = cam.size

	pixel_width = dim ./ res

	# create a set of rays that go through every pixel in our grid.
	rays = Array{Photon}(undef, res[1], res[2])
	for i = 1:res[1]
		for j = 1:res[2]
			pixel_loc = [cam.p[1] + 0.5*dim[1] - i*dim[1]/res[1] + 
						 0.5*pixel_width[1],
						 cam.p[2] + 0.5*dim[2] - j*dim[2]/res[2] +
						 0.5*pixel_width[2],
						 cam.p[3]+cam.focal_length]
			l = normalize(pixel_loc - cam.p)
			rays[res[2]*(i-1) + j] = Photon(l, pixel_loc, RGB(0))
		end
	end

	return rays

end

# ╔═╡ 494687f6-1ecd-11eb-3ada-6f11f45aa74f
md"""
### Sky Box

Now that we have the concept of a camera, we can technically do a fully 3D raytracing example; however, we want to ensure that each pixel will actually *hit* something -- preferrably something with some color gradient so we can make sure our simulation is working!

For this, we will introduce the concept of a sky box, which is standard for most gaming applications.
Here, the idea is that our entire scene is held within some additional object, just like the mirrors we used in the 2D example.
The only difference here is that we will be using some texture instead of a reflective surface.
In addition, even though we are calling it a box, we'll actually be treating it as a sphere.

Because we have already worked out how to make sure we have hit the interior of a spherical lens, we will be using a similar function here.
For this part of the exercise, we will need to construct 2 things:

1. A skybox struct
2. A function that returns some color gradient to be called whenever a ray of light interacts with a sky box

So let's start with the sky box struct
"""

# ╔═╡ 9e71183c-1ef4-11eb-1802-3fc60b51ceba
struct SkyBox <: Object
	# Skybox position
	p::Vector{Float64}

	# Skybox radius
	r::Float64
end

# ╔═╡ aa9e61aa-1ef4-11eb-0b56-cd7ded52b640
md"""
Now we have the ability to create a skybox, the only thing left is to create some sort of texture function so that when the ray of light hits the sky box, we can return some form of color information.
So for this, we will basically create a function that returns back a smooth gradient in different directions depending on the position of the ray when it hits the skybox.

For the color information, we will be assigning a color to each cardinal axis.
That is to say that there will be a red gradient along $x$, a blue gradient along $y$, and a green gradient along $z$.
For this, we will need to define some extent over which the gradient will be active in 'real' units.
From there, we can say that the gradient is

$$\frac{r+D}{2D},$$

where $r$ is the ray's position when it hits the skybox, and $D$ is the extent over which the gradient is active.

So let's get to it and write the function!
"""

# ╔═╡ c947f546-1ef5-11eb-0f02-054f4e7ae871
function pixel_color(position, extents)
	c = RGB(0)
	if position[1] < extents && position[1] > -extents
		c += RGB((position[1]+extents)/(2.0*extents), 0, 0)
	else
		println(position)
	end

	if position[2] < extents && position[2] > -extents
		c += RGB(0,0,(position[2]+extents)/(2.0*extents))
	else
		println(position)
	end

	if position[3] < extents && position[3] > -extents
		c += RGB(0,(position[3]+extents)/(2.0*extents), 0)
	else
		println(position)
	end

	return c
end

# ╔═╡ 26a820d2-1ef6-11eb-1bb1-1fc4b1c22e25
md"""
### Putting it all together!

Now we have a camera and a skybox and we can put everything together in order to do our first raytracing visualization.
For this, we need to start with a function that will take in our set of rays and return back an image that represents the image plane in the above example image.
"""

# ╔═╡ 595acf48-1ef6-11eb-0b46-934d17186e7b
function convert_to_img(rays)
	color_array = Array{RGB}(undef, size(rays)[2], size(rays)[1])
	for i = 1:length(color_array)
		 color_array[i] = rays[i].c
	end

	return color_array
end

# ╔═╡ 5c057466-1fb2-11eb-0451-45974dcc03c9
md"""
At this stage, we need a final function that steps all the rays forward
"""

# ╔═╡ df3f2178-1ef5-11eb-3098-b1c8c67cf136
md"""
So now all we need is a ray tracing function that simply takes in a camera and a set of objects / scene, and...
1. Initilializes all the rays
2. Propagates the rays forward
3. Converts everything into an image
"""

# ╔═╡ 78c85e38-1ef6-11eb-2fc7-f5677b0295b6
md"""
With this, we should have a simple image which is essentially a gradient of different colors by creating a sky box object, like so:
"""

# ╔═╡ eb157dd8-203c-11eb-1d05-b92969332928
md"""
The next step is to add objects, not too unlike what we did in the 2D example.
Similar to before, we will focus almost entirely onm sphere here, jsut because they are easy to work with.
"""

# ╔═╡ d175ff38-203c-11eb-38c6-a77e68196624
md"""

## Exercise 7: Dealing with Objects

In the 2D example, we dealt specifically with spheres that could either 100% reflect or refract.
In principle, it is possible for objects to either reflect or refract, something in-between.
That is to say, a ray of light can *split* when hitting an object surface, creating at least 2 more rays of light that will both return separate color values.
These color values will be combined at the end to create a final color for that ray.

As another note here, the objects that we create could, in principle, also have a color associated with them and just return the color value instead of reflecting or refracting.
In addition, the objects could cast a shadow on other objects or send diffuse light in all directions, but we will not deal with either of those cases in this homework.

For this homework, we will only deal with reflection, refraction, and color.

So, the first step is to create some form of surface *texture* that allows for a certain amount of reflectivity, transmittance, and coloring for each object.

After, we should be able to create a set of test orbs that all have different surfaces to make sure the code is working as intended.

So, first things first, let's make the surface struct!
"""

# ╔═╡ 8a4e888c-1ef7-11eb-2a52-17db130458a5
struct Surface
	# Reflectivity
	r::Float64

	# Transmission
	t::Float64

	# Color
	c::RGBA

	# index of refraction
	ior::Float64

end

# ╔═╡ 9c3bdb62-1ef7-11eb-2204-417510bf0d72
md"""
Now we need to update the sphere struct to take in some sort of surface...
"""

# ╔═╡ cb7ed97e-1ef7-11eb-192c-abfd66238378
struct Sphere <: Object
	# Lens position
	p::Vector{Float64}

	# Lens radius
	r::Float64

	s::Surface
end

# ╔═╡ 093b9e4a-1f8a-11eb-1d32-ad1d85ddaf42
function intersection(photon::Photon, sphere::S; ϵ=1e-3) where {S <: Union{SkyBox, Sphere}}
	a = dot(photon.l, photon.l)
	b = 2 * dot(photon.l, photon.p - sphere.p)
	c = dot(photon.p - sphere.p, photon.p - sphere.p) - sphere.r^2
	
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

# ╔═╡ 89e98868-1fb2-11eb-078d-c9298d8a9970
function closest_hit(photon::Photon, objects::Vector{<:Object})
	hits = intersection.([photon], objects)
	
	minimum(hits)
end

# ╔═╡ 3057c792-1fb2-11eb-1f27-097d353d0b4e
function step_ray(photon::Photon, objects::Vector{<:Object})
	hit = closest_hit(photon, objects)
	
	interact(photon, hit)
end

# ╔═╡ a4e81e2c-1fb2-11eb-0a19-27115387c133
function step_rays(rays::Array{Photon}, objects::Vector{O},
				   num_intersections) where {O <: Object}
	for j = 1:length(rays)
		rays[j] = step_ray(rays[j], objects, num_intersections)
	end

	return rays
end


# ╔═╡ 6b91a58a-1ef6-11eb-1c36-2f44713905e1
function ray_trace(objects::Vector{O}, cam::Camera;
				   num_intersections = 10) where {O <: Object}
	rays = init_rays(cam)

	rays = step_rays(rays, objects, num_intersections)

	convert_to_img(rays, filename)

	return rays

end

# ╔═╡ fb0ca4f0-203c-11eb-039f-2be758c11ed2
function skybox_only()
	sky = [SkyBox([0.0, 0.0, 0.0], 1000)]
	blank_img = Array{RGB}(undef, 800, 600)
	blank_img[:] .= RGB(0)

	cam = Camera(blank_img, [160,90], -100, [0,20,100])

	return ray_trace(objects, cam; num_intersections=20)

end

# ╔═╡ 6fdf613c-193f-11eb-0029-957541d2ed4d
function sphere_normal_at(p::Vector{Float64}, s::Sphere)
	normalize(p - s.center)
end

# ╔═╡ 64323080-1fb1-11eb-1d5c-9df3b29e38fa
md"""
At every interaction step, our ray will spawn 3 different children for
1. Reflection
2. Refraction
3. Coloring

So we need to modify out `step_ray(...)` function to take this into account.

For both reflection and refraction, a new ray will move in the corresponding direction, eventually returning color information back to their parent.
In the case that the object has a color already associated with it, then no sub ray will be spawned.
Instead, the ray will be colored according to the color of that object.

In the end, each ray will be colored based on the colors of it's child rays.
If the object's surface is 50% reflective and 50% transmittive, then 50% of the ray's final color will be determined by the reflective ray, and 50% will be determined by the refractive ray.

This means that we need to recursively call the `step_ray(...)` function for each ray child to determine the ray's final color.
"""

# ╔═╡ 98d811a2-1fb5-11eb-157b-5fed4e59f3f5
md"""
# This is what I need to modify!!!
"""

# ╔═╡ ce38cd94-1fb2-11eb-3c52-c564bab928c8
function step_ray(ray::Photon, objects::Vector{O},
				   num_intersections) where {O <: Object}

	for i = 1:num_intersections
		if ray.l != zeros(length(ray.l))
			intersect_final = [Inf, Inf]
			intersected_object = nothing
			for object in objects
				intersect = intersection(ray, object)
				   sum(intersect[:].^2) < sum(intersect_final[:].^2)
					intersect_final = intersect
					intersected_object = object
				end
			end

			if intersect_final != nothing
				ray = Ray(ray.l, ray.p .+ intersect_final, ray.c)
				if typeof(intersected_object) == Sphere
					reflected_ray = ray
					refracted_ray = ray
					colored_ray = ray
					if !isapprox(intersected_object.s.t, 0)
						ior = 1/intersected_object.s.ior
						if dot(ray.l,
							   sphere_normal_at(ray,
												intersected_object)) > 0
							ior = intersected_object.s.ior
						end

						refracted_ray = refract(ray, intersected_object, ior)
						refracted_ray = step_ray(refracted_ray, objects,
												 num_intersections-i)
					end

					if !isapprox(intersected_object.s.r, 0)
						n = sphere_normal_at(ray, intersected_object)
						reflected_ray = reflect(ray, n)
						reflected_ray = step_ray(reflected_ray, objects,
												 num_intersections-i)
					end

					if !isapprox(intersected_object.s.c.alpha, 0)
						ray_color = RGB(intersected_object.s.c)
						ray_vel = zeros(length(ray.l))
						colored_ray = Ray(ray_vel, ray.p, ray_color)
					end

					ray_color = intersected_object.s.t*refracted_ray.c +
								intersected_object.s.r*reflected_ray.c +
								intersected_object.s.c.alpha*colored_ray.c

					ray = Ray(zeros(length(ray.l)), ray.p, ray_color)

				elseif typeof(intersected_object) == SkyBox
					ray_color = pixel_color(ray.p, 1000)
					ray_vel = zeros(length(ray.l))
					ray = Ray(ray_vel, ray.p, ray_color)
				end
			else
				println("hit nothing")
			end
		end
	end

	return ray
end

# ╔═╡ d1970a34-1ef7-11eb-3e1f-0fd3b8e9657f
md"""
The last thing to do is create a scene with a number of balls inside of it.
To make sure the code is working, please create at least the following balls:
1. one that returns a color value
2. one that only reflects
3. one that only refracts
4. one that colors and refracts
5. one that colors and reflects
6. one that reflects and refracts
"""

# ╔═╡ 1f66ba6e-1ef8-11eb-10ba-4594f7c5ff19
function main()
	scene = [SkyBox([0.0, 0.0, 0.0], 1000),
			 Sphere([0,0,-25], 20, Surface(1.0, 0.0, RGBA(0,0,0,0.0), 1.5)),
			 Sphere([0,50,-100], 20, Surface(0.0, 1.0, RGBA(0,0,0,0.0), 0)),
			 Sphere([-50,0,-25], 20, Surface(0, 0.0, RGBA(0, 0, 1, 1), 0)),
			 Sphere([30, 25, -60], 20,
					Surface(0.0, 0.75, RGBA(1,0,0,0.25), 1.5)),
			 Sphere([50, 0, -25], 20,
					Surface(0.5, 0.0, RGBA(0,1,0,0.5), 1.5)),
			 Sphere([-30, 25, -60], 20,
					Surface(0.5, 0.5, RGBA(1,1,1,0), 1.5))]

	blank_img = Array{RGB}(undef, div(1920,2), div(1080,2))
	blank_img[:] .= RGB(0)

	cam = Camera(blank_img, [160,90], -100, [0,20,100])

	return ray_trace(scene, cam; num_intersections=20)

end

# ╔═╡ ce8fabbc-1faf-11eb-240a-77373e5528f9
main()

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

# ╔═╡ 06e2b3f0-1ecd-11eb-3bb7-3bedb1ed34cf
md"""
If you start counting at 1 or 0, you will not find the pixel center, but instead the pixel edge, so you need an offset of half the pixel width to ensure you are at the pixel center instead.
""" |> hint

# ╔═╡ 28e9c33c-1ef8-11eb-01f7-0b5176eb6c0f
md"""
Remember when placing these spheres that the camera is pointing in the z direction! Be sure that the sphere location can be seen by the camera!
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

# ╔═╡ ec7638e0-19c3-11eb-1ca1-0b3aa3b40240
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ ec85c940-19c3-11eb-3375-a90735beaec1
TODO = html"<span style='display: inline; font-size: 2em; color: purple; font-weight: 900;'>TODO</span>"

# ╔═╡ 8cfa4902-1ad3-11eb-03a1-736898ff9cef
TODO_note(text) = Markdown.MD(Markdown.Admonition("warning", "TODO note", [text]))

# ╔═╡ Cell order:
# ╟─1df32310-19c4-11eb-0824-6766cd21aaf4
# ╟─1df82c20-19c4-11eb-0959-8543a0d5630d
# ╠═84d846d8-203a-11eb-3ab9-5ba145aa501c
# ╟─1e01c912-19c4-11eb-269a-9796cccdf274
# ╟─1e109620-19c4-11eb-013e-1bc95c14c2ba
# ╠═1e202680-19c4-11eb-29a7-99061b886b3c
# ╟─1e2cd0b0-19c4-11eb-3583-0b82092139aa
# ╠═c3e52bf2-ca9a-11ea-13aa-03a4335f2906
# ╟─4e917968-1f87-11eb-371f-e3899b76dc24
# ╠═d851a202-1ca0-11eb-3da0-51fcb656783c
# ╠═24b0d4ba-192c-11eb-0f66-e77b544b0510
# ╠═8acef4b0-1a09-11eb-068d-79a259244ed1
# ╠═8018fbf0-1a05-11eb-3032-95aae07ca78f
# ╠═89e98868-1fb2-11eb-078d-c9298d8a9970
# ╠═3057c792-1fb2-11eb-1f27-097d353d0b4e
# ╠═5a9d00f6-1ac3-11eb-01fb-53c35796e766
# ╟─43306bd4-194d-11eb-2e30-07eabb8b29ef
# ╟─14dc73d2-1a0d-11eb-1a3c-0f793e74da9b
# ╠═093b9e4a-1f8a-11eb-1d32-ad1d85ddaf42
# ╠═6fdf613c-193f-11eb-0029-957541d2ed4d
# ╟─452d6668-1ec7-11eb-3b0a-0b8f45b43fd5
# ╟─791f0bd2-1ed1-11eb-0925-13c394b901ce
# ╟─1a446de6-1ec9-11eb-1e2f-6f4376005d24
# ╠═88576c6e-1ecb-11eb-3e34-830aeb433df1
# ╟─8f73824e-1ecb-11eb-0b28-4d1bc0eefbc3
# ╟─06e2b3f0-1ecd-11eb-3bb7-3bedb1ed34cf
# ╠═4006566e-1ecd-11eb-2ce1-9d1107186784
# ╟─494687f6-1ecd-11eb-3ada-6f11f45aa74f
# ╠═9e71183c-1ef4-11eb-1802-3fc60b51ceba
# ╟─aa9e61aa-1ef4-11eb-0b56-cd7ded52b640
# ╠═c947f546-1ef5-11eb-0f02-054f4e7ae871
# ╟─26a820d2-1ef6-11eb-1bb1-1fc4b1c22e25
# ╠═595acf48-1ef6-11eb-0b46-934d17186e7b
# ╟─5c057466-1fb2-11eb-0451-45974dcc03c9
# ╠═a4e81e2c-1fb2-11eb-0a19-27115387c133
# ╟─df3f2178-1ef5-11eb-3098-b1c8c67cf136
# ╠═6b91a58a-1ef6-11eb-1c36-2f44713905e1
# ╠═78c85e38-1ef6-11eb-2fc7-f5677b0295b6
# ╠═fb0ca4f0-203c-11eb-039f-2be758c11ed2
# ╟─eb157dd8-203c-11eb-1d05-b92969332928
# ╠═d175ff38-203c-11eb-38c6-a77e68196624
# ╠═8a4e888c-1ef7-11eb-2a52-17db130458a5
# ╟─9c3bdb62-1ef7-11eb-2204-417510bf0d72
# ╠═cb7ed97e-1ef7-11eb-192c-abfd66238378
# ╟─64323080-1fb1-11eb-1d5c-9df3b29e38fa
# ╠═98d811a2-1fb5-11eb-157b-5fed4e59f3f5
# ╠═ce38cd94-1fb2-11eb-3c52-c564bab928c8
# ╟─d1970a34-1ef7-11eb-3e1f-0fd3b8e9657f
# ╟─28e9c33c-1ef8-11eb-01f7-0b5176eb6c0f
# ╠═1f66ba6e-1ef8-11eb-10ba-4594f7c5ff19
# ╠═ce8fabbc-1faf-11eb-240a-77373e5528f9
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
