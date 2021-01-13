### A Pluto.jl notebook ###
# v0.12.18

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

# ╔═╡ 1724d36c-55e2-11eb-141c-75bf3e441715
md"""
# Hiding everything below a cell

This notebook defines a widget `hide_everything_below`. When shown as the output of a cell, all _subsequent_ cells will be hidden. You can unhide those cells by removing the widget.
"""

# ╔═╡ f77eadfc-dd72-4874-8e2d-e5f3f7e9b3c5
begin
	b = @bind reveal html"<input type=checkbox>"
	md"""
	## Example
	Reveal the rest of this notebook: $(b)
	"""
end

# ╔═╡ ac312d0b-35fc-4355-8273-dd37c80287dd
md"""
A Pluto notebook is made up of small blocks of Julia code (cells) and together they form a reactive notebook. When you change a variable, Pluto automatically re-runs the cells that refer to it. Cells can even be placed in arbitrary order - intelligent syntax analysis figures out the dependencies between them and takes care of execution.

Cells can contain arbitrary Julia code, and you can use external libraries. There are no code rewrites or wrappers, Pluto just looks at your code once before evaluation.
"""

# ╔═╡ 836189b1-0333-4305-99d2-6595752b4b44
x = 1

# ╔═╡ 00a4b7ce-277b-41aa-b608-4d0bf6bc73cb
123

# ╔═╡ aed0f069-17cd-43f2-aef1-0310b9c683e6
x + 2

# ╔═╡ 0d10052b-efb0-4190-b94d-857d5903cf41
hide_everything_below =
	html"""
	<style>
	pluto-cell.hide_everything_below ~ pluto-cell {
		display: none;
	}
	</style>
	
	<script>
	const cell = currentScript.closest("pluto-cell")
	
	const setclass = () => {
		console.log("change!")
		cell.classList.toggle("hide_everything_below", true)
	}
	setclass()
	const observer = new MutationObserver(setclass)
	
	observer.observe(cell, {
		subtree: false,
		attributeFilter: ["class"],
	})
	
	invalidation.then(() => {
		observer.disconnect()
		cell.classList.toggle("hide_everything_below", false)
	})
	
	</script>
	""";

# ╔═╡ a51c086d-3619-411e-9cbc-83f34fe78d71
if reveal === true
	md"Here we go!"
else
	hide_everything_below
end

# ╔═╡ 526393de-74f6-4513-9dbc-81919ae821fa
hide_everything_below

# ╔═╡ de4fda2e-81a8-455e-8ef9-e9554987fc88
md"""
I am hidden!
"""

# ╔═╡ Cell order:
# ╟─1724d36c-55e2-11eb-141c-75bf3e441715
# ╠═f77eadfc-dd72-4874-8e2d-e5f3f7e9b3c5
# ╠═a51c086d-3619-411e-9cbc-83f34fe78d71
# ╟─ac312d0b-35fc-4355-8273-dd37c80287dd
# ╠═836189b1-0333-4305-99d2-6595752b4b44
# ╠═00a4b7ce-277b-41aa-b608-4d0bf6bc73cb
# ╠═aed0f069-17cd-43f2-aef1-0310b9c683e6
# ╠═0d10052b-efb0-4190-b94d-857d5903cf41
# ╠═526393de-74f6-4513-9dbc-81919ae821fa
# ╟─de4fda2e-81a8-455e-8ef9-e9554987fc88
