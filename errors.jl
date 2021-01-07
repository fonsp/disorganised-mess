### A Pluto.jl notebook ###
# v0.9.3

using Markdown

# ╔═╡ af8a816e-a58f-11ea-1078-436ec68d41ad
function test(a)
	throw(InexactError(:test, a, a))
end

# ╔═╡ a96a4d8c-a58f-11ea-26a3-0f835366fe51
test([[0]])

# ╔═╡ 20f4a638-a593-11ea-3d80-7d6c40f0f864
struct Tomato
	
end

# ╔═╡ 28cba9ae-a593-11ea-12a3-33ebe53b1449
function Base.show(io::IO, ::MIME"text/plain", t::Tomato)
	throw(ErrorException("nooooo"))
end

# ╔═╡ 04192c74-a599-11ea-0e8f-4d39e2d534fe
rr = nothing

# ╔═╡ 3d13542e-a593-11ea-28dc-d95e572f28fc
Tomato()

# ╔═╡ 1a4d41cc-a594-11ea-10cb-e31f6b5ce9be


# ╔═╡ 11aac0ac-97b2-11ea-3b8b-377921d1c305
1+123

# ╔═╡ 7c2d19f0-97c3-11ea-0507-3506346b6643
function f(x)
	sqrt(x)
end

# ╔═╡ 1b09e6b4-97b2-11ea-2435-b32960f66bdb
f(-10)

# ╔═╡ fed3aa3e-97bb-11ea-2506-f56382c45428
try
	sqrt(-5)
catch ex
	global ex = ex
	global st = stacktrace(catch_backtrace())
end

# ╔═╡ d072a2f6-a591-11ea-01c7-2df3cd1469dd
CapturedException(ex, st)

# ╔═╡ 08a3ce72-97bc-11ea-2266-5d6a0987ae5e
sprint(showerror, ex)

# ╔═╡ fc213236-97c3-11ea-033c-3b2eacb690ef
s.inlined

# ╔═╡ c4a04f14-97b5-11ea-0940-9b000e26af10
html"""
<script>
function render_filename(filename) {
	
}

return html`<p>${1}</p>${[]}`

return html`<div>${[1,2,3].map(i => html`<p>${i*i}</p>`)}</div>`

</script>


"""

# ╔═╡ 136d0f08-a59f-11ea-150b-71540c58e102
html"""<script>
return html`asdf`
</script>"""

# ╔═╡ 84242fae-97c8-11ea-2565-37c14c431063
CapturedException(ex, [])

# ╔═╡ 98e4caa6-97ba-11ea-360a-112bced3a2fc
1
2

# ╔═╡ 986ef064-97b6-11ea-0280-4fbe97832914
Dict(:a => 1)

# ╔═╡ 5e5e8fe6-97b2-11ea-3831-dd299582e831
html"""

<script>
function render_filename(frame) {
	const sep_index = frame.file.indexOf("#==#")
	if(sep_index != -1){
		const a = DOM.element("a", {href: "#" + frame.file.substr(sep_index + 4), onclick: "window.cellRedirect(event)"}) 
		a.innerText = "Cell 😀"
		return a
	} else {
		return html`<em>${frame.file}:${frame.line}</em>`
	}
}

function render_error(state) {
	return html`
	<jlerror>
		<header>
			<strong>${state.msg}</strong>
		</header>
		<section>
			<p>Stack trace:</p>
			<ol>
			${state.stacktrace.map(frame => html`
				<li>
					<strong>${frame.call}</strong><span>@</span>${render_filename(frame)}
				</li>`
			)}
			</ol>
		</section>
	</jltree>`
}

test = JSON.parse(`{"msg":"UndefVarError(:++)","stacktrace":[{"call":"top-level scope","line":1,"file":"jl_MvpnbB.jl#==#1b09e6b4-97b2-11ea-2435-b32960f66bdb"}]}
`)
test = JSON.parse(`{"msg":"DomainError(-10.0,\\n \\\\"sqrt will only return a complex result if called with a complex argument. Try sqrt(Complex(x)).\\\\")","stacktrace":[{"call":"throw_complex_domainerror(::Symbol, ::Float64)","line":32,"file":"math.jl"},{"call":":sqrt","line":492,"file":"math.jl"},{"call":"sqrt(::Int64)","line":518,"file":"math.jl"},{"call":"top-level scope","line":1,"file":"jl_MvpnbB.jl#==#1b09e6b4-97b2-11ea-2435-b32960f66bdb"}]}`)

console.log(test)
this.parentElement.parentElement.classList.add("error")

return render_error(test)
</script>


"""

# ╔═╡ d6c50966-97c3-11ea-0694-9f08e8493546
s=st[2]

# ╔═╡ ed1766d0-97c7-11ea-36b3-810778e8824b
s=["<b>a</b>"]

# ╔═╡ Cell order:
# ╠═af8a816e-a58f-11ea-1078-436ec68d41ad
# ╠═a96a4d8c-a58f-11ea-26a3-0f835366fe51
# ╠═20f4a638-a593-11ea-3d80-7d6c40f0f864
# ╠═28cba9ae-a593-11ea-12a3-33ebe53b1449
# ╠═04192c74-a599-11ea-0e8f-4d39e2d534fe
# ╠═3d13542e-a593-11ea-28dc-d95e572f28fc
# ╠═1a4d41cc-a594-11ea-10cb-e31f6b5ce9be
# ╠═11aac0ac-97b2-11ea-3b8b-377921d1c305
# ╠═d072a2f6-a591-11ea-01c7-2df3cd1469dd
# ╠═1b09e6b4-97b2-11ea-2435-b32960f66bdb
# ╠═7c2d19f0-97c3-11ea-0507-3506346b6643
# ╠═fed3aa3e-97bb-11ea-2506-f56382c45428
# ╠═08a3ce72-97bc-11ea-2266-5d6a0987ae5e
# ╠═d6c50966-97c3-11ea-0694-9f08e8493546
# ╠═fc213236-97c3-11ea-033c-3b2eacb690ef
# ╠═ed1766d0-97c7-11ea-36b3-810778e8824b
# ╠═c4a04f14-97b5-11ea-0940-9b000e26af10
# ╠═136d0f08-a59f-11ea-150b-71540c58e102
# ╠═84242fae-97c8-11ea-2565-37c14c431063
# ╠═98e4caa6-97ba-11ea-360a-112bced3a2fc
# ╠═986ef064-97b6-11ea-0280-4fbe97832914
# ╟─5e5e8fe6-97b2-11ea-3831-dd299582e831
