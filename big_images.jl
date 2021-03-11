### A Pluto.jl notebook ###
# v0.12.20

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

# ╔═╡ a3a04d5f-b0f0-4740-9b37-92570864f142
high_res = true

# ╔═╡ a822ac82-5691-4f8e-a60a-1a4582cf59e7
dog_file = if high_res
		download("https://upload.wikimedia.org/wikipedia/commons/e/ef/Pluto_in_True_Color_-_High-Res.jpg")
else
	download("https://upload.wikimedia.org/wikipedia/commons/thumb/e/ef/Pluto_in_True_Color_-_High-Res.jpg/240px-Pluto_in_True_Color_-_High-Res.jpg")
end

# ╔═╡ 627461ce-9e80-4707-b0ba-ddc6bb9b4269
begin
	struct Dog end
	function Base.show(io::IO, ::MIME"image/jpg", ::Dog)
		write(io, read(dog_file))
	end
end

# ╔═╡ 5ce8ebc6-b509-42f0-acd5-8008673b04ab
md"Downloaded image is $(filesize(dog_file) / 1000) kB"

# ╔═╡ 8559d502-847e-4506-b9d6-031be014d262
import Distributed

# ╔═╡ 87620bae-16b3-48fe-a10d-5b906c7b337f


# ╔═╡ 5539db10-b0d2-48b6-8985-ef437b8ae0b5
show_dogs = false

# ╔═╡ 03307e43-cb61-4321-95ac-7bbb16e0cfc6
@bind x html"<input type=range max=10000>"

# ╔═╡ b18c2329-18d7-4041-962c-0ef98f8aa591
x

# ╔═╡ 1f48fe19-3ee8-44ac-a591-7b4df2d2f93a
md"""
This cell will have very large Uint8Arrays in the output body
"""

# ╔═╡ 8b0de539-42ef-4ce0-920d-af074f6dba1f
# show_dogs && fill(fill(Dog(), 20),5)

# ╔═╡ 74329553-ab9b-4b6c-a77b-9c24ac48490b
show_dogs && fill(Dog(), 20)

# ╔═╡ 1b5ea9f9-e2f9-4696-99c6-d70cedfb294e
md"""
Run the next cell to call GC on the server process:
"""

# ╔═╡ bfe37b62-576e-46e7-bf28-a7ac2483ffd8
# Distributed.remotecall_eval(Main, [1], :(GC.gc()))

# ╔═╡ Cell order:
# ╠═627461ce-9e80-4707-b0ba-ddc6bb9b4269
# ╠═a3a04d5f-b0f0-4740-9b37-92570864f142
# ╠═a822ac82-5691-4f8e-a60a-1a4582cf59e7
# ╟─5ce8ebc6-b509-42f0-acd5-8008673b04ab
# ╠═8559d502-847e-4506-b9d6-031be014d262
# ╠═87620bae-16b3-48fe-a10d-5b906c7b337f
# ╠═5539db10-b0d2-48b6-8985-ef437b8ae0b5
# ╠═03307e43-cb61-4321-95ac-7bbb16e0cfc6
# ╠═b18c2329-18d7-4041-962c-0ef98f8aa591
# ╟─1f48fe19-3ee8-44ac-a591-7b4df2d2f93a
# ╠═8b0de539-42ef-4ce0-920d-af074f6dba1f
# ╠═74329553-ab9b-4b6c-a77b-9c24ac48490b
# ╟─1b5ea9f9-e2f9-4696-99c6-d70cedfb294e
# ╠═bfe37b62-576e-46e7-bf28-a7ac2483ffd8
