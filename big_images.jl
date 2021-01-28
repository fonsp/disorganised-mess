### A Pluto.jl notebook ###
# v0.12.19

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

# ╔═╡ a822ac82-5691-4f8e-a60a-1a4582cf59e7
dog_file = download("https://upload.wikimedia.org/wikipedia/commons/e/ef/Pluto_in_True_Color_-_High-Res.jpg")

# ╔═╡ 627461ce-9e80-4707-b0ba-ddc6bb9b4269
begin
	struct Dog end
	function Base.show(io::IO, ::MIME"image/jpg", ::Dog)
		write(io, read(dog_file))
	end
end

# ╔═╡ 5ce8ebc6-b509-42f0-acd5-8008673b04ab
md" $(filesize(dog_file) / 1000) kB"

# ╔═╡ 03307e43-cb61-4321-95ac-7bbb16e0cfc6
@bind x html"<input type=range max=10000>"

# ╔═╡ b18c2329-18d7-4041-962c-0ef98f8aa591
x

# ╔═╡ 87620bae-16b3-48fe-a10d-5b906c7b337f


# ╔═╡ 5539db10-b0d2-48b6-8985-ef437b8ae0b5
show_dogs = true

# ╔═╡ 8b0de539-42ef-4ce0-920d-af074f6dba1f
show_dogs && fill(Dog(), 20)

# ╔═╡ Cell order:
# ╠═627461ce-9e80-4707-b0ba-ddc6bb9b4269
# ╠═a822ac82-5691-4f8e-a60a-1a4582cf59e7
# ╠═5ce8ebc6-b509-42f0-acd5-8008673b04ab
# ╠═03307e43-cb61-4321-95ac-7bbb16e0cfc6
# ╠═b18c2329-18d7-4041-962c-0ef98f8aa591
# ╠═87620bae-16b3-48fe-a10d-5b906c7b337f
# ╠═5539db10-b0d2-48b6-8985-ef437b8ae0b5
# ╠═8b0de539-42ef-4ce0-920d-af074f6dba1f
