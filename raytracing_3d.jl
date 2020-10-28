### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ 8989d43e-190e-11eb-3e48-7d10df903b5d
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
			Pkg.PackageSpec(name="Plots", version="1"),
			Pkg.PackageSpec(name="Images", version="0.23"),
			Pkg.PackageSpec(name="ImageMagick"),
			Pkg.PackageSpec(name="PlutoUI", version="0.6.8-0.6"),
			])
	using Images
	using Plots
	using PlutoUI
end

# ╔═╡ 4417b3e0-190f-11eb-1efe-53d279a306e6
using LinearAlgebra

# ╔═╡ 45a028a0-190f-11eb-355d-ad3c55fb1e2f
using Test

# ╔═╡ 853789be-1911-11eb-1121-679f89fe62db
md"""
Pluto notebook adaptation of https://github.com/leios/simuleios/tree/master/raytracing

See
https://www.youtube.com/watch?v=JwyQezsQkkw
"""

# ╔═╡ f4c96d10-190e-11eb-0e8e-11ded1c8830e
# TODO: get refraction to work without offsets in quadratic / inside_of fxs
#       Also, use dot product to see if exiting lens

function Base.isapprox(n1::Nothing, n2::Nothing)
    return true
end

# ╔═╡ 8bc95210-1910-11eb-2af9-cb247912835a
# For now, all cameras are aligned on the z axis
struct Camera
    # Set of all pixels, counts as scene resolution
    pixels

    # physical size of aperture
    size::Vector{Float64}

    # camera's distance from screen
    focal_length::Float64

    # camera's position
    p::Vector{Float64}
end

# ╔═╡ 8bc95210-1910-11eb-1617-6553c4a38187
struct Ray
    # Velocity vector
    v::Vector{Float64}

    # Position vector
    p::Vector{Float64}

    # Color
    c::RGB
end

# ╔═╡ 8bccfb90-1910-11eb-07e2-89c2354c0ec5
struct Surface

    # Reflectivity
    r::Float64

    # Transmission
    t::Float64

    # Color
    c::RGBA

    # index of refraction
    ior::Float64

    function Surface(in_r, in_t, in_c, in_ior)
        if !isapprox(in_r+in_t+in_c.alpha, 1)
            error("invalid surface definition, RTC < 1")
        end
        new(in_r,in_t,in_c, in_ior)
    end

    Surface(in_r, in_t, in_c::Float64, in_ior) =
         new(in_r, in_t, RGBA(0,0,0,0), in_ior)
end

# ╔═╡ 8bdfe750-1910-11eb-1eb6-c9c61b3333cf
abstract type Object end

# ╔═╡ 8bea95b0-1910-11eb-3850-9f624fa3e6c0
struct Sphere <: Object
    # Lens position
    p::Vector{Float64}

    # Lens radius
    r::Float64

    s::Surface
end

# ╔═╡ 8bec1c50-1910-11eb-2f63-9151c9c3cb3b
function Lens(p, r, ior)
    return Sphere(p, r, Surface(0,1,RGBA(0,0,0,0),ior))
end

# ╔═╡ 8bfbfad0-1910-11eb-1c82-17966c89f2b2
function ReflectingSphere(p, r)
    return Sphere(p,r,Surface(1,0,RGBA(0,0,0,0),0))
end

# ╔═╡ 8c09b670-1910-11eb-378a-7b49a6e0e0fa
function ColoredSphere(p, r, c::RGB)
    return Sphere(p, r, Surface(0,0,RGBA(c), 0))
end

# ╔═╡ 8c0b3d10-1910-11eb-26cc-234b48fb81b7
mutable struct SkyBox <: Object
    # Skybox position
    p::Vector{Float64}

    # Skybox radius
    r::Float64
end

# ╔═╡ 8c1acd70-1910-11eb-24e6-333b3aa1e91f
function sphere_normal_at(ray, sphere)
    n = normalize(ray.p .- sphere.p)

    return n
end

# ╔═╡ 8c1d3e70-1910-11eb-10af-7dd208f70edd
function inside_of(ray::Ray, sphere)
    return inside_of(ray.p, sphere)
end

# ╔═╡ 8c29e89e-1910-11eb-0ab3-bd8039bb7f10
function inside_of(pos, sphere)
    x = sphere.p[1] - pos[1]
    y = sphere.p[2] - pos[2]
    if (x^2 + y^2 <= sphere.r^2)
        return true
    else
        return false
    end
end

# ╔═╡ 8c36e0f0-1910-11eb-1a50-6526ea1a9663
function refract(ray, lens::Sphere, ior)
	# note: light moves at a particular speed with respect to the medium it is
	#       moving through, so...
	#       n_2*v = n_1*l + (n_1*cos(theta_1) - n_2*cos(theta_2))*n
	#       Other approximations: ior = n_1/n_2, c = -n*l
	
    n = sphere_normal_at(ray, lens)

    if dot(n, ray.v) > 0
        n .*= -1
    end
    c = dot(-n, ray.v);
    d = 1.0 - ior^2 * (1.0 - c^2);

    if (d < 0.0)
        reflect!(ray, n)
        return
    end

    ray_vel = ior * ray.v + (ior * c - sqrt(d)) * n;
    return Ray(ray_vel, ray.p, ray.c)
end

# ╔═╡ 8c45ae00-1910-11eb-2908-ede9e1c04a53
abstract type Wall <: Object end;

# ╔═╡ 8c45ae00-1910-11eb-0726-79ba8d8e8085
mutable struct Mirror <: Wall
    # Normal vector
    n::Vector{Float64}

    # Position of mirror
    p::Vector{Float64}

    # Mirror size
    scale::Float64

    Mirror(in_n, in_p) = new(in_n, in_p, 2.5)
end

# ╔═╡ 8c63e460-1910-11eb-3a9f-cf493ae0a063
function is_behind(ray, mirror)
    if dot(ray.p.-mirror.p, mirror.n) >= 0
        return true
    else
        return false
    end
end

# ╔═╡ 8c67b4f0-1910-11eb-0efe-5f123cc14d53
# note: for reflection, l_x -> l_x, but l_y -> -l_y
#       In this case, the y component of l = cos(theta)*n
#       so new vector: v = l + 2cos(theta)*n
function reflect(ray, n)
    ray_vel = ray.v .- 2*dot(ray.v, n).*n
    ray_pos = ray.p .+ 0.001*ray.v
    return Ray(ray_vel, ray_pos, ray.c)
end

# ╔═╡ 8c7f3490-1910-11eb-3e86-d36bf13976d0
function draw_circle(p, r, res)
    return [x .+ (p[1], p[2]) for x in Plots.partialcircle(0, 2pi, res, r)]
end

# ╔═╡ 8c809420-1910-11eb-2f0d-e17ea7a04a51
function plot_rays(positions, objects::Vector{O},
                   filename) where {O <: Object}
    plt = plot(background_color=:black, aspect_ratio=:equal, legend=false)

    for i = 1:size(positions)[1]
        plot!(plt, (positions[i,:,1], positions[i,:,2]); label = "ray",
              linecolor=:white)
    end

    for object in objects
        if typeof(object) == Mirror
            dir = [-object.n[2], object.n[1]]
            extents = zeros(2,2)
            extents[1,:] .= object.p .- object.scale * dir
            extents[2,:] .= object.p .+ object.scale * dir
            plot!(plt, (extents[:,1], extents[:,2]), label = "mirror")
        elseif typeof(object) == Sphere
            circle = draw_circle(object.p, object.r, 100)
            plot!(circle; label="lens", linecolor=:lightblue)
        end 
    end

    savefig(plt, filename)
end

# ╔═╡ 8c99c170-1910-11eb-054a-1b007276a744
function step(ray::Ray, dt)
    ray.p .+= .+ ray.v.*dt
    return ray
end

# ╔═╡ 8c99c170-1910-11eb-2e24-49ed98b4dd2c
function intersection(ray::Ray, sphere::S;
                      threshold = 0.01) where
                      {S <: Union{Sphere, SkyBox}}
    relative_dist = ray.p-sphere.p
    a = dot(ray.v, ray.v)
    b = 2.0 * dot(relative_dist, ray.v)
    c = dot(relative_dist, relative_dist) - sphere.r*sphere.r
    discriminant = b*b - 4*a*c

    if discriminant < 0
        return nothing
    elseif discriminant > 0
        roots = [(-b + sqrt(discriminant)) / (2*a),
                 (-b - sqrt(discriminant)) / (2*a)]
        min = minimum(roots)
        max = maximum(roots)

        if min > threshold
            return (min)*ray.v
        elseif max > threshold
            return (max)*ray.v
        else
            return nothing
        end
    else
        # Returns nothing if tangential
        return nothing
        #return (-b/(2*a))*ray.v
    end 
end

# ╔═╡ 8cb27992-1910-11eb-3602-1ba932c81088
function intersection(ray::Ray, wall::W) where {W <: Wall}
    intersection_pt = -dot((ray.p .- wall.p),wall.n)/dot(ray.v, wall.n)

    if isfinite(intersection_pt) && intersection_pt > 0 &&
       intersection_pt != NaN
        return intersection_pt*ray.v
    else
        return nothing
    end
end

# ╔═╡ 8cc03530-1910-11eb-107e-3db62b460115
function propagate(rays::Array{Ray}, objects::Vector{O},
                    num_intersections) where {O <: Object}
    for j = 1:length(rays)
        rays[j] = propagate(rays[j], objects, num_intersections)
    end

    return rays
end

# ╔═╡ 8cd93b70-1910-11eb-050a-5713b545f28e
function pixel_color(position)
    extents = 1000.0
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

# ╔═╡ 8cc03530-1910-11eb-3404-15f5c8f69f8f
function propagate(ray::Ray, objects::Vector{O},
                   num_intersections) where {O <: Object}

    for i = 1:num_intersections
        if ray.v != zeros(length(ray.v))
            intersect_final = [Inf, Inf]
            intersected_object = nothing
            for object in objects
                intersect = intersection(ray, object)
                if intersect != nothing &&
                   sum(intersect[:].^2) < sum(intersect_final[:].^2)
                    intersect_final = intersect
                    intersected_object = object
                end
            end

            if intersect_final != nothing
                ray.p .+= intersect_final
                if intersected_object isa Sphere
                    if !isapprox(intersected_object.s.t, 0)
                        ior = 1/intersected_object.s.ior
                        if dot(ray.v,
                               sphere_normal_at(ray,
                                                intersected_object)) > 0
                            ior = intersected_object.s.ior
                        end

                        ray = refract(ray, intersected_object, ior)
                    elseif !isapprox(intersected_object.s.r, 0)
                        n = sphere_normal_at(ray, intersected_object)
                        ray = reflect(ray, n)
                    elseif !isapprox(intersected_object.s.c.alpha, 0)
                        ray_color = RGB(intersected_object.s.c)
                        ray_vel = zeros(length(ray.v))
                        ray = Ray(ray_vel, ray.p, ray_color)
                    end

                elseif intersected_object isa Mirror
                    ray = reflect(ray, intersected_object.n)
                elseif intersected_object isa SkyBox
                    ray_color = pixel_color(ray.p)
                    ray_vel = zeros(length(ray.v))
                    ray = Ray(ray_vel, ray.p, ray_color)
                end
            else
                println("hit nothing")
            end
        end
    end

    return ray
end

# ╔═╡ 8cd93b70-1910-11eb-39eb-a7dd6c180bcf
function convert_to_img(rays::Array{Ray}, filename)
    color_array = Array{RGB}(undef, size(rays)[2], size(rays)[1])
    for i = 1:length(color_array)
         color_array[i] = rays[i].c
    end

    save(filename, color_array)
end

# ╔═╡ b1537ff0-1911-11eb-01c4-39237e7c8123
CartesianIndex(1,2)

# ╔═╡ 8cf0e220-1910-11eb-0933-b168f7031f46
function init_rays(cam::Camera)

    res = size(cam.pixels)
    dim = cam.size

    pixel_width = dim ./ res

    # create a set of rays that go through every pixel in our grid.
	rays = map(CartesianIndices(cam.pixels)) do I
		pixel_loc = [cam.p[1] + 0.5*dim[1] - I[1]*dim[1]/res[1] + 
					 0.5*pixel_width[1],
					 cam.p[2] + 0.5*dim[2] - I[2]*dim[2]/res[2] +
					 0.5*pixel_width[2],
					 cam.p[3]+cam.focal_length]
		l = normalize(pixel_loc - cam.p)
		Ray(l, pixel_loc, RGB(0))
	end

    return rays

end

# ╔═╡ 8cf0e220-1910-11eb-1237-23da08615add
function ray_trace(objects::Vector{O}, cam::Camera; filename="check.png",
                   num_intersections = 10) where {O <: Object}

    rays = init_rays(cam)

    rays = propagate(rays, objects, num_intersections)

    # convert_to_img(rays, filename)

    return rays
end

# ╔═╡ b766c970-1910-11eb-1457-9f5986c4807f
function as_image(rays::Array{Ray})
	[r.c for r in rays]
end

# ╔═╡ 8d079e70-1910-11eb-01df-e5817d349353
sky = [SkyBox([0.0, 0.0, 0.0], 1000)]

# ╔═╡ 8d079e70-1910-11eb-0f98-95762a22a7f2
spheres = [Lens([50,0,-25], 20, 1.5), ReflectingSphere([0,0,-25],20),
		   ColoredSphere([-50,0,-25], 20, RGB(0.25, 1, 0.75))]

# ╔═╡ 8d1e5abe-1910-11eb-2a84-79f43f4a7e65
objects = vcat(sky, spheres)

# ╔═╡ 8d20cbc0-1910-11eb-0d98-31a55e7becde
doit() = let
	# blank_img = Array{RGB}(undef, 1920,1080)
	blank_img = Array{RGB}(undef, 200, 150)
	repeat
	blank_img[:] .= RGB(0)

	cam = Camera(blank_img, [16,9], -10, [0,0,100])

	ray_trace(objects, cam) |> as_image
end |> transpose

# ╔═╡ 210789e0-1912-11eb-11b6-bdb806bee14d
doit()

# ╔═╡ 25ab9680-1912-11eb-0650-6361aaf781ec
# [doit() for _ in 1:10];

# 3.1

# ╔═╡ Cell order:
# ╟─853789be-1911-11eb-1121-679f89fe62db
# ╠═8989d43e-190e-11eb-3e48-7d10df903b5d
# ╠═4417b3e0-190f-11eb-1efe-53d279a306e6
# ╠═45a028a0-190f-11eb-355d-ad3c55fb1e2f
# ╠═f4c96d10-190e-11eb-0e8e-11ded1c8830e
# ╠═8bc95210-1910-11eb-2af9-cb247912835a
# ╠═8bc95210-1910-11eb-1617-6553c4a38187
# ╠═8bccfb90-1910-11eb-07e2-89c2354c0ec5
# ╠═8bdfe750-1910-11eb-1eb6-c9c61b3333cf
# ╠═8bea95b0-1910-11eb-3850-9f624fa3e6c0
# ╠═8bec1c50-1910-11eb-2f63-9151c9c3cb3b
# ╠═8bfbfad0-1910-11eb-1c82-17966c89f2b2
# ╠═8c09b670-1910-11eb-378a-7b49a6e0e0fa
# ╠═8c0b3d10-1910-11eb-26cc-234b48fb81b7
# ╠═8c1acd70-1910-11eb-24e6-333b3aa1e91f
# ╠═8c1d3e70-1910-11eb-10af-7dd208f70edd
# ╠═8c29e89e-1910-11eb-0ab3-bd8039bb7f10
# ╠═8c36e0f0-1910-11eb-1a50-6526ea1a9663
# ╠═8c45ae00-1910-11eb-2908-ede9e1c04a53
# ╠═8c45ae00-1910-11eb-0726-79ba8d8e8085
# ╠═8c63e460-1910-11eb-3a9f-cf493ae0a063
# ╠═8c67b4f0-1910-11eb-0efe-5f123cc14d53
# ╠═8c7f3490-1910-11eb-3e86-d36bf13976d0
# ╠═8c809420-1910-11eb-2f0d-e17ea7a04a51
# ╠═8c99c170-1910-11eb-054a-1b007276a744
# ╠═8c99c170-1910-11eb-2e24-49ed98b4dd2c
# ╠═8cb27992-1910-11eb-3602-1ba932c81088
# ╠═8cc03530-1910-11eb-107e-3db62b460115
# ╠═8cc03530-1910-11eb-3404-15f5c8f69f8f
# ╠═8cd93b70-1910-11eb-050a-5713b545f28e
# ╠═8cd93b70-1910-11eb-39eb-a7dd6c180bcf
# ╠═b1537ff0-1911-11eb-01c4-39237e7c8123
# ╠═8cf0e220-1910-11eb-0933-b168f7031f46
# ╠═8cf0e220-1910-11eb-1237-23da08615add
# ╠═b766c970-1910-11eb-1457-9f5986c4807f
# ╠═8d079e70-1910-11eb-01df-e5817d349353
# ╠═8d1e5abe-1910-11eb-2a84-79f43f4a7e65
# ╠═8d079e70-1910-11eb-0f98-95762a22a7f2
# ╠═8d20cbc0-1910-11eb-0d98-31a55e7becde
# ╠═210789e0-1912-11eb-11b6-bdb806bee14d
# ╠═25ab9680-1912-11eb-0650-6361aaf781ec
