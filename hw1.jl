### A Pluto.jl notebook ###
# v0.11.12

using Markdown
using InteractiveUtils

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

# ╔═╡ 6b30dc38-ed6b-11ea-10f3-ab3f121bf4b8
begin
	Pkg.add("PlutoUI")
	using PlutoUI
end

# ╔═╡ 74b008f6-ed6b-11ea-291f-b3791d6d1b35
begin
	Pkg.add(["Images", "ImageIO", "ImageMagick"])
	using Images
end

# ╔═╡ ac8ff080-ed61-11ea-3650-d9df06123e1f
md"""
# 18.S191 fall 2020 -- problem set 1

## **Exercise 1** - _Manipulating arrays (1D images)_

1. Make a random vector using `rand()`. Calculate the mean using a `for` loop and centre the data.

2. Generate a 1-dimensional array of 100 zeros, change the center 20 elements to 1, creating a box.

3. Create Vector of Vectors and make a matrix out of it, and back.
"""

# ╔═╡ f2d19642-ed6a-11ea-0ca2-075905dd0eee
md"""

## fonsi's ideas:

1: what does "centre the data" mean?

1: check if it is a vector

2: visualize!

3: two fuctions

"""

# ╔═╡ dce6944e-ed6b-11ea-04dd-690eba0e678b
random_vector = rand(100)

# ╔═╡ e5abe8a4-ed6b-11ea-1807-157c51018bb4
Gray.(hcat(random_vector)')

# ╔═╡ 215ca9d8-ed6c-11ea-279c-0503c138e876
function create_box_vector(size=100)
	box_vector = zeros(size)
	
	box_vector[40:59] .= 1
	
	return box_vector
end

# ╔═╡ 58c41fe6-ed6c-11ea-38e7-b17f55982649
Gray.(hcat(create_box_vector())')

# ╔═╡ 8c19fb72-ed6c-11ea-2728-3fa9219eddc4
function vecvec_to_matrix(vecvec::Vector{<:Vector})::Matrix
	
	return hcat(vecvec...)
end

# ╔═╡ adfbe9b2-ed6c-11ea-09ac-675262f420df
vecvec_to_matrix([[6,7],[8,9]])

# ╔═╡ 9f1c6d04-ed6c-11ea-007b-75e7e780703d
function matrix_to_vecvec(matrix::Matrix)
# 	return [matrix[i,:] for i in 1:size(matrix,1)]
	return collect(eachcol(matrix))
end

# ╔═╡ 70955aca-ed6e-11ea-2330-89b4d20b1795
matrix_to_vecvec([6 7; 8 9])

# ╔═╡ ac28f1f4-ed6c-11ea-3d00-e31edf7646e9
matrix_to_vecvec([6 7 8; 8 9 10])

# ╔═╡ e083b3e8-ed61-11ea-2ec9-217820b0a1b4
md"""
## **Exercise 2** - _Manipulating images_

Recall that in Julia images are matrices of color objects.

1. Load an image of your choosing.

2. Calculate the mean amounts of red, green and blue in the image.

3. Write a function `quantize(x)` that takes in a value $x$ and "quantizes" it into bins of width 0.1. E.g. 0.267 gets mapped to 0.2.

3. Is the image still recognizable if you quantize the $(r, g, b)$ value of each pixel?

4. "Invert" the colors, i.e. send each $(r, g, b)$ pixel to $(1 - r, 1-g, 1-b)$.

5. Write a function `randomize(x, s)` to add randomness of strength $r$ to a value $x$. This should be a uniform random number between $-s$ and $+s$. If the result falls outside the range $(0, 1)$ you should "clamp" it to that range.

    Hint: The Julia function `rand()` generates uniform random floating-point numbers between $0$ and $1$.
 
7. Add random noise to the $(r, g, b)$ values of each pixel using your `randomize` function.
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

As we have seen in the videos, we can produce cool effects using the mathematical technique of **convolutions**. We input one image ``M`` and get a new image ``M'`` back. 

Conceptually we think of ``M`` as a matrix of real numbers. In our case, we are working with digital images, so in Julia it will be a `Matrix` of color objects, and we may need to take that into account. Ideally, however, we should write a **generic** function that will work for any type of data contained in the matrix.

A convolution works on a small **window** of an image, i.e. a region centered around a given point ``(i, j)``. We will suppose that the window is a square region with odd side length ``2\ell + 1``, running from ``-\ell, \ldots, 0, \ldots, \ell``.

The result of the convolution over a given window, centred at the point ``(i, j)`` is a *single number*; this number is the value that we will use for ``M'_{i, j}``.




Note that neighbouring windows will overlap.


1. **Write a simple "box" blur function that averages the values in each window.**

    One of the difficulties that we will face is: What do we do if we are supposed to use a value of ``M_{i, j}`` which does not exist? There are various solutions to this problem of **boundary conditions**.
    
    The simplest solution is to assume that ``M_{i, j}`` equals ``0`` outside the original image; however, this may lead to strange boundary effects.
    
    A better solution is to use the closest value on the boundary.
    
    Use this technique by checking the new values of $i$ and $j$ and "clamping" them to the allowed region in the original image.
    
    
2. A general convolution allows for different coefficients multiplying each of the input values in the window. These coefficients are stored in a matrix called a **kernel**, $K$.

    The formula is then
    
    $$M'_{i, j} = \sum_{k, l}  \, M_{i + k, j + l} K_{k, l},$$
    
    where the sum is over the possible values of $k$ and $l$ in the window.

    **Implement a function `convolution(M, K)`. Use the same boundary conditions as in the previous question.**
    
    
3. Take the image provided ... and apply a **gaussian blur**.

4. Take the image and apply a **Sobel edge detection filter**.

5. For many noisy images, such as this one, the edge detection will not work well, since spurious edges will be detected. only work well if a gaussian blur is first applied. Do this.
"""

# ╔═╡ f18c164a-ed6a-11ea-1653-8fc259915206
md"""

## fonsi's ideas:


7: should create+modify a copy

7: a video input that ouputs a small webcam image _while you hold down a button_ - use this throughout the notebook to check out user-written functions

"""

# ╔═╡ Cell order:
# ╟─83eb9ca0-ed68-11ea-0bc5-99a09c68f867
# ╟─8ef13896-ed68-11ea-160b-3550eeabbd7d
# ╠═911ccbce-ed68-11ea-3606-0384e7580d7c
# ╠═65780f00-ed6b-11ea-1ecf-8b35523a7ac0
# ╠═6b30dc38-ed6b-11ea-10f3-ab3f121bf4b8
# ╠═74b008f6-ed6b-11ea-291f-b3791d6d1b35
# ╟─ac8ff080-ed61-11ea-3650-d9df06123e1f
# ╠═f2d19642-ed6a-11ea-0ca2-075905dd0eee
# ╠═dce6944e-ed6b-11ea-04dd-690eba0e678b
# ╟─e5abe8a4-ed6b-11ea-1807-157c51018bb4
# ╠═215ca9d8-ed6c-11ea-279c-0503c138e876
# ╟─58c41fe6-ed6c-11ea-38e7-b17f55982649
# ╠═8c19fb72-ed6c-11ea-2728-3fa9219eddc4
# ╠═adfbe9b2-ed6c-11ea-09ac-675262f420df
# ╠═9f1c6d04-ed6c-11ea-007b-75e7e780703d
# ╠═70955aca-ed6e-11ea-2330-89b4d20b1795
# ╠═ac28f1f4-ed6c-11ea-3d00-e31edf7646e9
# ╟─e083b3e8-ed61-11ea-2ec9-217820b0a1b4
# ╠═a7602b10-ed6a-11ea-101c-49422cfcbf91
# ╟─e08781fa-ed61-11ea-13ae-91a49b5eb74a
# ╠═f18c164a-ed6a-11ea-1653-8fc259915206
