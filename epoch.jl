### A Pluto.jl notebook ###
# v0.8.11

using Markdown
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.peek, el) ? Base.peek(el) : missing
        el
    end
end

# ╔═╡ f30da028-854c-11ea-20dc-65a990065083
using Plots

# ╔═╡ 17807bd2-854e-11ea-1409-758d522a64b5
using PlutoUI

# ╔═╡ c7febb2c-854c-11ea-24a4-ebc21ee25db6
function train()
	sleep(.1) # fake
end

# ╔═╡ 2682c10e-8552-11ea-0467-158e9dfe4e09
md"This is how you would compute 10 epochs in a standalone script:"

# ╔═╡ 9c43f83c-854c-11ea-2761-b5702ecef24f
begin
	errors1 = Float64[]
	for epoch in 1:10
		train()
		ϵ = 1.0 / epoch # fake
		push!(errors1, ϵ)
	end
end

# ╔═╡ 45db03e0-854d-11ea-0f8a-b14125e60872
plot(errors1, xlabel="epoch", ylabel="error")

# ╔═╡ 414a4670-8551-11ea-1de5-ab121ad27de6
md"The plot only gets generated when the previous cell has **finished**, i.e. when all epochs have been computed."

# ╔═╡ 30e6b0c0-8551-11ea-372a-7dd071dbcfb6
md"### More interactive"

# ╔═╡ 0e5528aa-854e-11ea-2120-8fb1bf1aba7e
md"Instead, you could split the code into cells, and use a `Button` to drive evaluations."

# ╔═╡ 50843c7e-854f-11ea-1dea-7569a8909ba6
errors2 = Float64[]

# ╔═╡ 101b0f58-854f-11ea-2d9b-b99d6a9464a3
@bind advance_epoch PlutoUI.Button("Advance epoch 🖐")

# ╔═╡ 424fca06-854f-11ea-2563-9dee2c216b3a
begin
	advance_epoch # reference the variable to make this cell react to it
	let
		epoch = length(errors2) + 1

		train()
		ϵ = 1.0 / epoch # fake
		push!(errors2, ϵ)
	end
	epoch_done = "🥔"
end

# ╔═╡ a931b57c-854f-11ea-3db4-6bc02dc496b8
let
	epoch_done # reference the variable to make this cell react to it
	plot(errors2, xlabel="epoch", ylabel="error")
end

# ╔═╡ 8503e5ee-8551-11ea-31e5-cd42466f72ea
md"The array `errors2` is only assigned to once, initialising it to the empty array. We later use `push!` to add elements _non-reactively_ - Pluto doesn't track value changes _(such as `x[2] = 456`)_, it only tracks variable assingments _(such as `x = [123, 456]`)_.

To make sure that the plot gets updated, we assign to a dummy variable, `epoch_done`. Because this is a regular global assignment, it will be reactive."

# ╔═╡ Cell order:
# ╠═f30da028-854c-11ea-20dc-65a990065083
# ╠═17807bd2-854e-11ea-1409-758d522a64b5
# ╠═c7febb2c-854c-11ea-24a4-ebc21ee25db6
# ╟─2682c10e-8552-11ea-0467-158e9dfe4e09
# ╠═9c43f83c-854c-11ea-2761-b5702ecef24f
# ╠═45db03e0-854d-11ea-0f8a-b14125e60872
# ╟─414a4670-8551-11ea-1de5-ab121ad27de6
# ╟─30e6b0c0-8551-11ea-372a-7dd071dbcfb6
# ╟─0e5528aa-854e-11ea-2120-8fb1bf1aba7e
# ╠═50843c7e-854f-11ea-1dea-7569a8909ba6
# ╠═101b0f58-854f-11ea-2d9b-b99d6a9464a3
# ╠═424fca06-854f-11ea-2563-9dee2c216b3a
# ╠═a931b57c-854f-11ea-3db4-6bc02dc496b8
# ╟─8503e5ee-8551-11ea-31e5-cd42466f72ea
