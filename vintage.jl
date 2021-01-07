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

# ╔═╡ 760423a4-f14b-11ea-03c2-a1645ca7d054
begin
	import Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ 3f7fa7a6-f14c-11ea-0d95-c50b1bad9203
begin
	Pkg.add("Suppressor")
	using Suppressor
end

# ╔═╡ 50bc77fc-f158-11ea-2ca2-1f21a4c6836a


# ╔═╡ 5290bb1c-f158-11ea-2c02-0b7e3ec07f09


# ╔═╡ 5fb368ec-f150-11ea-3b5f-01f513e1ae20
html"<br><br><br><br>"

# ╔═╡ 2071984a-f150-11ea-2e87-999ed199fc03
md"""Are you ready for **the future**? $(@bind ready html"<input type=checkbox>")"""

# ╔═╡ 65d1e9d8-f150-11ea-08b6-299cdada12e4
html"<br><br><br><br>"

# ╔═╡ 4fe1a1d6-f14b-11ea-34ce-d9f10e65a14c
function with_vintage_terminal(f)
	local spam_out, spam_err
	@color_output false begin
		spam_out = @capture_out begin
			spam_err = @capture_err begin
				f()
			end
		end
	end
	spam_out, spam_err
	
	id = String(rand('a':'z', 8))
	HTML("""
		<style>
		div.vintage_terminal {
			
		}
		div.vintage_terminal pre {
			color: #ddd;
			background-color: #333;
			border: 5px solid pink;
			font-size: .75rem;
		}
		
		</style>
	<div class="vintage_terminal" id=$(id)>
		<pre>$(Markdown.htmlesc(spam_out))</pre>
		<audio src="https://upload.wikimedia.org/wikipedia/commons/d/db/Floppy_drive_sounds.ogg" >
	</div>
		<script>
		const terminal = document.querySelector("#$(id)")
		const pre = terminal.querySelector("pre")
		const audio = terminal.querySelector("audio")
		
		const original = pre.innerHTML
		var handle = 0
		var i = 0
		
		audio.play()
		handle = setInterval(() => {
			pre.innerHTML = original.substring(0,i)
		
			i+=2
			if(i > original.length) {
				audio.pause()
				clearInterval(handle)
			}
		}, 20)
		</script>
		
		
	""")
end

# ╔═╡ c2fc7586-f14d-11ea-02db-bfee78a3414a
if ready
	with_vintage_terminal() do
		@show "hello"
		@show "world"

		dump(:(f(x) = x+1))
	end
end

# ╔═╡ 9683b676-f14e-11ea-1061-4965e2edb9c3
function with_terminal(f)
	local spam_out, spam_err
	@color_output false begin
		spam_out = @capture_out begin
			spam_err = @capture_err begin
				f()
			end
		end
	end
	spam_out, spam_err
	
	HTML("""
		<style>
		div.vintage_terminal {
			
		}
		div.vintage_terminal pre {
			color: #ddd;
			background-color: #333;
			border: 5px solid pink;
			font-size: .75rem;
		}
		
		</style>
	<div class="vintage_terminal">
		<pre>$(Markdown.htmlesc(spam_out))</pre>
	</div>
	""")
end

# ╔═╡ 5279d5c4-f150-11ea-3770-ad5d6a055852
md"#### Boring mode:"

# ╔═╡ bd586bba-f14f-11ea-3c37-110412ca9852
with_terminal() do
	@show "hello"
	@show "world"
	
	dump(:(f(x) = x+1))
end

# ╔═╡ Cell order:
# ╠═760423a4-f14b-11ea-03c2-a1645ca7d054
# ╠═3f7fa7a6-f14c-11ea-0d95-c50b1bad9203
# ╠═50bc77fc-f158-11ea-2ca2-1f21a4c6836a
# ╠═5290bb1c-f158-11ea-2c02-0b7e3ec07f09
# ╟─5fb368ec-f150-11ea-3b5f-01f513e1ae20
# ╟─2071984a-f150-11ea-2e87-999ed199fc03
# ╠═c2fc7586-f14d-11ea-02db-bfee78a3414a
# ╟─65d1e9d8-f150-11ea-08b6-299cdada12e4
# ╟─4fe1a1d6-f14b-11ea-34ce-d9f10e65a14c
# ╟─9683b676-f14e-11ea-1061-4965e2edb9c3
# ╟─5279d5c4-f150-11ea-3770-ad5d6a055852
# ╠═bd586bba-f14f-11ea-3c37-110412ca9852
