### A Pluto.jl notebook ###
# v0.11.12

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

# ╔═╡ 83eb9ca0-ed68-11ea-0bc5-99a09c68f867
md"_homework 1, version 0_"

# ╔═╡ 911ccbce-ed68-11ea-3606-0384e7580d7c
# edit the code below to set your name and kerberos ID (i.e. email without @mit.edu)

student = (name = "Jazzy Doe", kerberos_id = "jazz")

# press the ▶ button in the bottom right of this cell to run your edits
# or use Shift+Enter

# you might need to wait until all other cells in this notebook have completed running. 
# scroll down the page to see what's up

# ╔═╡ 8ef13896-ed68-11ea-160b-3550eeabbd7d
md"""

Submission by: **_$(student.name)_** ($(student.kerberos_id)@mit.edu)
"""

# ╔═╡ 65780f00-ed6b-11ea-1ecf-8b35523a7ac0
begin
	import Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ 74b008f6-ed6b-11ea-291f-b3791d6d1b35
begin
	Pkg.add(["Images", "ImageIO", "ImageMagick"])
	using Images
end

# ╔═╡ 6b30dc38-ed6b-11ea-10f3-ab3f121bf4b8
begin
	Pkg.add("PlutoUI")
	using PlutoUI
end

# ╔═╡ ac8ff080-ed61-11ea-3650-d9df06123e1f
md"""

# **Homework 1** - _convolutions_
`18.S191`, fall 2020

## **Exercise 1** - _Manipulating vectors (1D images)_

A `Vector` is a 1D array. We can think of that as a 1D image.

"""

# ╔═╡ 467856dc-eded-11ea-0f83-13d939021ef3
example_vector = [0.5, 0.4, 0.3, 0.2, 0.1, 0.0, 0.7, 0.0, 0.7, 0.0]

# ╔═╡ ad6a33b0-eded-11ea-324c-cfabfd658b56
md"#### Exerise 1.1
👉 Make a random vector `v` of length 10 using the `rand` function.
"

# ╔═╡ f51333a6-eded-11ea-34e6-bfbb3a69bcb0
v = missing # replace this with your code!

# ╔═╡ cf738088-eded-11ea-2915-61735c2aa990
md"👉 Make a function `mean` using a `for` loop."

# ╔═╡ 0ffa8354-edee-11ea-2883-9d5bfea4a236
function mean(x)
	
	return missing
end

# ╔═╡ 1f229ca4-edee-11ea-2c56-bb00cc6ea53c
md"👉 Define `m` to be the mean of `v`."

# ╔═╡ 2a391708-edee-11ea-124e-d14698171b68


# ╔═╡ e2863d4c-edef-11ea-1d67-332ddca03cc4
md"""👉 Write a function `demean`, which takes a vector `x` and subtracts the mean from each value in `x`."""

# ╔═╡ ec5efe8c-edef-11ea-2c6f-afaaeb5bc50c
function demean(x)
	
	return missing
end

# ╔═╡ 29e10640-edf0-11ea-0398-17dbf4242de3
md"Let's check that the mean of `demean(v)` is 0:

_Due to floating-point round-off error it may *not* be *exactly* 0._"

# ╔═╡ 73ef1d50-edf0-11ea-343c-d71706874c82
copy_of_v = copy(v); # in case demean modifies `x`

# ╔═╡ 38155b5a-edf0-11ea-3e3f-7163da7433fb
mean(demean(copy_of_v)) ≈ 0

# ╔═╡ a5f8bafe-edf0-11ea-0da3-3330861ae43a
md"""
#### Exercise 1.2

👉 Generate a vector of 100 zeros. Change the center 20 elements to 1.
"""

# ╔═╡ b6b65b94-edf0-11ea-3686-fbff0ff53d08
function create_bar()
	
	return missing
end

# ╔═╡ 22f28dae-edf2-11ea-25b5-11c369ae1253
md"""
#### Exercise 1.3

👉 Write a function that turns a `Vector` of `Vector`s into a `Matrix`.
"""

# ╔═╡ 8c19fb72-ed6c-11ea-2728-3fa9219eddc4
function vecvec_to_matrix(vecvec)
	
	return hcat(vecvec...)
end

# ╔═╡ c4761a7e-edf2-11ea-1e75-118e73dadbed
vecvec_to_matrix([[1,2], [3,4]])

# ╔═╡ 393667ca-edf2-11ea-09c5-c5d292d5e896
md"""


👉 Write a function that turns a `Matrix` into a`Vector` of `Vector`s .
"""

# ╔═╡ 9f1c6d04-ed6c-11ea-007b-75e7e780703d
function matrix_to_vecvec(matrix)
	
	return collect(eachcol(matrix))
end

# ╔═╡ 70955aca-ed6e-11ea-2330-89b4d20b1795
matrix_to_vecvec([6 7; 8 9])

# ╔═╡ 5da8cbe8-eded-11ea-2e43-c5b7cc71e133
begin
	colored_line(x::Vector) = Gray.(hcat(x)')
	colored_line(x::Any) = nothing
end

# ╔═╡ 56ced344-eded-11ea-3e81-3936e9ad5777
colored_line(example_vector)

# ╔═╡ b18e2c54-edf1-11ea-0cbf-85946d64b6a2
colored_line(v)

# ╔═╡ d862fb16-edf1-11ea-36ec-615d521e6bc0
colored_line(create_bar())

# ╔═╡ e083b3e8-ed61-11ea-2ec9-217820b0a1b4
md"""
## **Exercise 2** - _Manipulating images_

In this exercise we will get familiar with matrices (2D arrays) in Julia, by manipulating images.
Recall that in Julia images are matrices of `RGB` color objects.

1. Load an image of your choosing.

2. Write a function `mean_colors` that accepts an object called `image`. It should calculate the mean (average) amounts of red, green and blue in the image and return a tuple `(r, g, b)` of those means.

3. Look up the documentation on the `floor` function. Use it to write a function `quantize(x)` that takes in a value $x$ (which you can assume is between 0 and 1) and "quantizes" it into bins of width 0.1. For example, check that 0.267 gets mapped to 0.2. 

4. Write a new **method** of the function `quantize`, i.e. a new *version* of the function with the *same* name. This method will accept a color object called `color`. Write the function signature as follows:

    ```julia
    function quantize(color::AbstractRGB)
        # your code here
    end
    ```
    
    Here, `::AbstractRGB` is a **type annotation**. This ensures that this version of the function will be chosen when passing in an object whose type is a **subtype** of the `AbstractRGB` abstract type. For example, both the `RGB` and `RGBX` types satisfy this.

    The method you write should return a new `RGB` object, in which each component ($r$, $g$ and $b$) are quantized.

5. Write a method `quantize(image::AbstractMatrix)` that quantizes an image by quantizing each pixel in the image. (You may assume that the matrix is a matrix of color objects.)

    Quantize your image from exercise [1]. Is it still recognisable?

6. Write a function `invert` that inverts a color, i.e. sends $(r, g, b)$ to $(1 - r, 1-g, 1-b)$.

    Invert your image.

7. (i) Write a function `noisify(x, s)` to add randomness of intensity $s$ to a value $x$, i.e. to add a random value between $-s$ and $+s$ to $x$. If the result falls outside the range $(0, 1)$ you should "clamp" it to that range. (Note that Julia has a `clamp` function, but you should write your own function `myclamp(x)`.)

    Hint: The `rand` function generates (uniform) random floating-point numbers between $0$ and $1$.
 
    (ii) Make a method `noisify(c, s)` to add random noise of intensity $s$ to each of the $(r, g, b)$ values in a colour. 
    
    (iii) Make a method `noisify(image, s)` to noisify each pixel of an image.
    
    (iv) Make an interactive visualisation using Pluto's `@bind` where you add different intensities of noise to your image. For which noise intensity does it become unrecognisable? [You may need noise intensities larger than 1. Why?]


"""

# ╔═╡ a7602b10-ed6a-11ea-101c-49422cfcbf91
md"""

## fonsi's ideas:


7: should create+modify a copy

7: a video input that ouputs a small webcam image _while you hold down a button_ - use this throughout the notebook to check out user-written functions

"""

# ╔═╡ e08781fa-ed61-11ea-13ae-91a49b5eb74a
md"""

## **Exercise 3** - Convolutions

As we have seen in the videos, we can produce cool effects using the mathematical technique of **convolutions**. We input one image $M$ and get a new image $M'$ back. 

Conceptually we think of $M$ as a matrix. In practice, in Julia it will be a `Matrix` of color objects, and we may need to take that into account. Ideally, however, we should write a **generic** function that will work for any type of data contained in the matrix.

A convolution works on a small **window** of an image, i.e. a region centered around a given point $(i, j)$. We will suppose that the window is a square region with odd side length $2\ell + 1$, running from $-\ell, \ldots, 0, \ldots, \ell$.

The result of the convolution over a given window, centred at the point $(i, j)$ is a *single number*; this number is the value that we will use for $M'_{i, j}$.
(Note that neighbouring windows overlap.)

To get started let's restrict ourselves to convolutions in 1D.
So a window is just a 1D region from $-\ell$ to $\ell$.

 We need to decide how to handle the **boundary conditions**, i.e. what happens if we try to access a position in the vector `v` beyond `1:n`.  The simplest solution is to assume that $v_{i}$ is 0 outside the original vector; however, this may lead to strange boundary effects.
    
A better solution is to use the *closest* value that is inside the vector. Effectively we are extending the vector and copying the extreme values into the extended positions. (Indeed, this is one way we could implement this; these extra positions are called **ghost cells**.)


1. Make a vector `v` of random numbers of length 1000.

2. Install and load the `Plots.jl` library and plot the result using `plot(v)`.

3. Write a function `extend(v, i)` that checks whether the position $i$ is inside `1:n`. If so, return the $i$th compoonent of `v`; otherwise, return the nearest end value.

4. Write a function `blur_1D(v, l)` that blurs a vector `v` with a window of length `n` by averaging the elements within a window from $-\ell$ to $\ell$. This is called a **box blur**.

5. Apply the box blur to your vector `v`. Plot the original and the new vectors. [Use `plot!` to add a new plot.] Make this interactive as a function of the length $\ell$.
   
6. The box blur is a simple example of a **convolution**, i.e. a linear function of a window around each point, given by 

    $$v'_{i} = \sum_{n}  \, v_{i - n} \, k_{n},$$
    
    where $k$ is a vector called a **kernel**.
    
    Again, we need to take care about what happens if $v_{i -n }$ falls off the end of the vector.
    
    Write a function `convolve_vector(v, k)` that performs this convolution. You need to think of the vector $k$ as being *centred* on the position $i$. So $n$ in the above formula runs between $-\ell$ and $\ell$, where $2\ell + 1$ is the length of the vector $k$. You will need to do the necessary manipulation of indices.

7. Write a function `gaussian_kernel`. Convolve your vector with the Gaussian kernel and make it interactive.
"""

# ╔═╡ b01858b6-edf3-11ea-0826-938d33c19a43
md"""
 
   
## Exercise 4: Convolutions of images 
    
Now let's move to 2D images. The convolution is then given by a **kernel** matrix $K$:
    
$$M'_{i, j} = \sum_{k, l}  \, M_{i- k, j - l} \, K_{k, l},$$
    
where the sum is over the possible values of $k$ and $l$ in the window. Again we think of the window as being *centered* at $(i, j)$.

1. Write a method of the `extend` function that takes a matrix `M` and indices `i` and `j`, and returns the closest element of the matrix.

2. Implement a function `convolve_image(M, K)`. 
    
3. Take the image provided ... and apply a **gaussian blur**. Make it interactive.

4. Take the image and apply a **Sobel edge detection filter**.
"""

# ╔═╡ f18c164a-ed6a-11ea-1653-8fc259915206
md"""

## fonsi's ideas:


7: should create+modify a copy

7: a video input that ouputs a small webcam image _while you hold down a button_ - use this throughout the notebook to check out user-written functions

"""

# ╔═╡ 5516c800-edee-11ea-12cf-3f8c082ef0ef
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]));

# ╔═╡ 57360a7a-edee-11ea-0c28-91463ece500d
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]));

# ╔═╡ dcb8324c-edee-11ea-17ff-375ff5078f43
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]));

# ╔═╡ 58af703c-edee-11ea-2963-f52e78fc2412
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]));

# ╔═╡ f3d00a9a-edf3-11ea-07b3-1db5c6d0b3cf
yays = [md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."];

# ╔═╡ 5aa9dfb2-edee-11ea-3754-c368fb40637c
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]));

# ╔═╡ 74d44e22-edee-11ea-09a0-69aa0aba3281
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]));

# ╔═╡ 397941fc-edee-11ea-33f2-5d46c759fbf7
if !@isdefined(v)
	not_defined(:v)
elseif ismissing(v)
	still_missing()
elseif !(v isa Vector)
	keep_working(md"`v` should be a `Vector`.")
elseif length(v) != 10
	keep_working(md"`v` does not have the correct size.")
else
	correct()
end

# ╔═╡ 38dc80a0-edef-11ea-10e9-615255a4588c
if !@isdefined(mean)
	not_defined(:mean)
else
	let
		result = mean([1,2,3])
		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif result !== 2
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ 2b1ccaca-edee-11ea-34b0-c51659f844d0
if !@isdefined(m)
	not_defined(:m)
elseif ismissing(m)
	still_missing()
elseif !(m isa Number)
	keep_working(md"`m` should be a number.")
elseif m != mean(v)
	keep_working()
else
	correct()
end

# ╔═╡ e3394c8a-edf0-11ea-1bb8-619f7abb6881
if !@isdefined(create_bar)
	not_defined(:create_bar)
else
	let
		result = create_bar()
		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif !(result isa Vector) || length(result) != 100
			keep_working(md"The result should be a `Vector` with 100 elements.")
		elseif result[[1,50,100]] != [0,1,0]
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ adfbe9b2-ed6c-11ea-09ac-675262f420df
if !@isdefined(vecvec_to_matrix)
	not_defined(:vecvec_to_matrix)
else
	let
		input = [[6,7],[8,9]]

		result = vecvec_to_matrix(input)
		shouldbe = [6 7; 8 9]

		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif !(result isa Matrix)
			keep_working(md"The result should be a `Matrix`")
		elseif result != shouldbe && result != shouldbe'
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ e06b7fbc-edf2-11ea-1708-fb32599dded3
if !@isdefined(matrix_to_vecvec)
	not_defined(:matrix_to_vecvec)
else
	let
		input = [6 7 8; 8 9 10]
		result = collect(matrix_to_vecvec(input))
		shouldbe = [[6,7,8],[8,9,10]]
		shouldbe2 = [[6,8], [7,9], [8,10]]

		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif result != shouldbe && result != shouldbe2
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ Cell order:
# ╟─83eb9ca0-ed68-11ea-0bc5-99a09c68f867
# ╟─8ef13896-ed68-11ea-160b-3550eeabbd7d
# ╠═911ccbce-ed68-11ea-3606-0384e7580d7c
# ╠═65780f00-ed6b-11ea-1ecf-8b35523a7ac0
# ╠═74b008f6-ed6b-11ea-291f-b3791d6d1b35
# ╟─ac8ff080-ed61-11ea-3650-d9df06123e1f
# ╟─467856dc-eded-11ea-0f83-13d939021ef3
# ╠═56ced344-eded-11ea-3e81-3936e9ad5777
# ╟─ad6a33b0-eded-11ea-324c-cfabfd658b56
# ╠═f51333a6-eded-11ea-34e6-bfbb3a69bcb0
# ╟─b18e2c54-edf1-11ea-0cbf-85946d64b6a2
# ╟─397941fc-edee-11ea-33f2-5d46c759fbf7
# ╟─cf738088-eded-11ea-2915-61735c2aa990
# ╠═0ffa8354-edee-11ea-2883-9d5bfea4a236
# ╟─38dc80a0-edef-11ea-10e9-615255a4588c
# ╟─1f229ca4-edee-11ea-2c56-bb00cc6ea53c
# ╠═2a391708-edee-11ea-124e-d14698171b68
# ╟─2b1ccaca-edee-11ea-34b0-c51659f844d0
# ╟─e2863d4c-edef-11ea-1d67-332ddca03cc4
# ╠═ec5efe8c-edef-11ea-2c6f-afaaeb5bc50c
# ╟─29e10640-edf0-11ea-0398-17dbf4242de3
# ╠═38155b5a-edf0-11ea-3e3f-7163da7433fb
# ╠═73ef1d50-edf0-11ea-343c-d71706874c82
# ╟─a5f8bafe-edf0-11ea-0da3-3330861ae43a
# ╠═b6b65b94-edf0-11ea-3686-fbff0ff53d08
# ╟─d862fb16-edf1-11ea-36ec-615d521e6bc0
# ╟─e3394c8a-edf0-11ea-1bb8-619f7abb6881
# ╟─22f28dae-edf2-11ea-25b5-11c369ae1253
# ╠═8c19fb72-ed6c-11ea-2728-3fa9219eddc4
# ╠═c4761a7e-edf2-11ea-1e75-118e73dadbed
# ╟─adfbe9b2-ed6c-11ea-09ac-675262f420df
# ╟─393667ca-edf2-11ea-09c5-c5d292d5e896
# ╠═9f1c6d04-ed6c-11ea-007b-75e7e780703d
# ╠═70955aca-ed6e-11ea-2330-89b4d20b1795
# ╟─e06b7fbc-edf2-11ea-1708-fb32599dded3
# ╟─5da8cbe8-eded-11ea-2e43-c5b7cc71e133
# ╠═6b30dc38-ed6b-11ea-10f3-ab3f121bf4b8
# ╟─e083b3e8-ed61-11ea-2ec9-217820b0a1b4
# ╠═a7602b10-ed6a-11ea-101c-49422cfcbf91
# ╟─e08781fa-ed61-11ea-13ae-91a49b5eb74a
# ╟─b01858b6-edf3-11ea-0826-938d33c19a43
# ╠═f18c164a-ed6a-11ea-1653-8fc259915206
# ╟─5516c800-edee-11ea-12cf-3f8c082ef0ef
# ╟─57360a7a-edee-11ea-0c28-91463ece500d
# ╟─dcb8324c-edee-11ea-17ff-375ff5078f43
# ╠═58af703c-edee-11ea-2963-f52e78fc2412
# ╠═f3d00a9a-edf3-11ea-07b3-1db5c6d0b3cf
# ╠═5aa9dfb2-edee-11ea-3754-c368fb40637c
# ╟─74d44e22-edee-11ea-09a0-69aa0aba3281
