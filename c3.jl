### A Pluto.jl notebook ###
# v0.14.1

using Markdown
using InteractiveUtils

# ╔═╡ edf80d00-9caa-11eb-0068-3bb6690019b7
using HypertextLiteral

# ╔═╡ 3d989d8d-ad60-4809-a77a-3fc69dd88a85
using JSON

# ╔═╡ 8b1361b8-cf8c-49d3-bed8-5f4e24a3a3a3
html"""



"""

# ╔═╡ fe4f2aa9-09c6-47ec-bcd8-92b1d6436c15
html"""
<!-- Load c3.css -->
<link href="https://cdn.jsdelivr.net/npm/c3@0.7.20/c3.min.css" rel="stylesheet">

<!-- Load d3.js and c3.js -->
<script src="https://cdn.jsdelivr.net/npm/d3@5/dist/d3.min.js" charset="utf-8"></script>
<script src="https://cdn.jsdelivr.net/npm/c3@0.7.20/c3.min.js"></script>


<div id="chart"></div>

<script>
let chart = c3.generate({
    bindto: '#chart',
    data: {
      columns: [
        ['data1', 30, 200, 100, 400, 150, 250],
        ['data2', 50, 20, 10, 40, 15, 25]
      ]
    }
});

</script>

"""

# ╔═╡ Cell order:
# ╠═edf80d00-9caa-11eb-0068-3bb6690019b7
# ╠═3d989d8d-ad60-4809-a77a-3fc69dd88a85
# ╠═8b1361b8-cf8c-49d3-bed8-5f4e24a3a3a3
# ╠═fe4f2aa9-09c6-47ec-bcd8-92b1d6436c15
