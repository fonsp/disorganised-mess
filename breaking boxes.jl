### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ cf0eb30e-f299-43d7-ab31-8a48ebc647ed
using PlutoUI

# ╔═╡ d1696d25-1f3c-4a4a-b287-7f0035c897c7
using HypertextLiteral

# ╔═╡ 0bdfd444-f783-4707-ac69-3851dfaa61c2
using Plots

# ╔═╡ d5e2a7f1-5d44-4e58-91ef-df12e0d007c2
using PlutoTest

# ╔═╡ ad4f807a-ad18-422f-816b-ac75edfbcc60
overflow(x) = @htl("""
	<div style="max-height: 500px; overflow-y: auto;">
	$(x)
	</div>
	""")

# ╔═╡ eb0f1ea4-7e07-4670-8fe4-e531aa918ba3
jl(str) = Markdown.MD(Markdown.Code("julia", str))

# ╔═╡ 85920cbd-bad3-45d1-99ad-fe9acfab9a02
br = html"<br>"

# ╔═╡ 0c7a5125-302b-4239-a6bb-5475695c1e68
@htl("""
	
	<h1 style="text-align: center;">✨ Pluto 1.0 ✨ <span style="opacity: .7;">in Fall 2021</span></h1>
	
	""")

# ╔═╡ 4c019753-a360-4d69-86b2-a92710c5ffad


# ╔═╡ ed6d9e33-2a59-439b-9490-b8c996d257ea
@htl("""
	<h1><code>github.com/fonsp/Pluto.jl</code></h1>
	""")

# ╔═╡ 0e46ef73-60db-4ce6-8752-97f501ebe62f
names = split("""
Fons van der Plas
Nicholas Bochenski
Παναγιώτης Γεωργακόπουλος
Michiel Dral
Paul Berg
Benjamin Lungwitz
Connor Burns
Rogerluo
Eric Zhang
Felipe S. S. Schneider
Luka van der Plas
Glen Hertz
Eric Hanson
Shuhei Kadowaki
Jerry Ling
Jelmar Gerritsen
Rok Novosel
Supanat
Zachary Moon
pupuis
Michael Abbott
Nicholas Bauer
Patrick Bouffard
Shashank Polasa
TheCedarPrince
fghzxm
karlwessel
Ciarán O'Mara
Rik Huijzer
Aayush Joglekar
Alexis
Chris Foster
Dhruva Sambrani
Diego Javier Zea
Felix Cremer
Fredrik Ekre
Gautam Mishra
Iagoba Apellaniz
Ian Butterworth
Immortalin
Jeremiah
Jonas Jonker
János Veres
Leo
Logan Kilpatrick 
Marius Millea
Matt Helm
Musab Kılıç
Philip D Loewen
Robert Moss
Rémi Vezy
Satoshi Terasaki
Sebastian Stabinger
Sergey Konoplich
Chebro
Syx Pek
Tobias Skarhed
Troels Arnfred Bojesen
Utkarsh Shah
zuckberj
Vlad
Zhixing Wang
Zlatan Vasović
contradict
disberd
elliotsayes
gregod
heetbeet
holomorphism
romaindegivry
Ömür Özkir
""", "\n"; keepempty=false)

# ╔═╡ b684b0d3-609a-431f-a1ce-08a87d3d4fab
@htl("""
	<h4 style="text-align: center;">Thank you ❤️</h4>
	<br>
	<p style="background: #fff;">
	$(map(enumerate(names[2:end])) do (i,n)
	
		@htl("<span style=$(Dict(
			"font-weight" => 700 - i*20,
			"margin-right" => "$(max(5,20 - i))px",
			"font-size" => string(max(13, 20-.2i), "px"),
			"line-height" => string(max(10, 20-.5i), "px"),
			"background" => "#f5f5f5",
			"border-radius" => "6px",
			"padding" => "4px",
			"display" => "inline-block",
		))>$(n)$(i < length(names) - 1 ? "" : "") </span>")
	
	end)
	</p>
	""")

# ╔═╡ 48c1443e-9656-4a97-a42b-4f8db332c7cc
podcast = html"<iframe src='https://omny.fm/shows/future-of-coding/37-de-nerding-programming-jonathan-edwards/embed' width='100%' height='150' frameborder='0'></iframe>";

# ╔═╡ 0fbcf962-f8f4-471d-b2ed-38ec020df877
bigbreak = html"
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
"

# ╔═╡ 363429f1-d456-4195-9fbe-142ca7f62824
bigbreak

# ╔═╡ a4c1a119-0b52-4576-9d85-597726892b20
bigbreak

# ╔═╡ 54d2de83-e336-41fd-923f-76b0a67a094d
1 + 1

# ╔═╡ 7ec0f50b-937e-4f68-ab0e-af70937757fa
bigbreak

# ╔═╡ 1819c538-7ef2-419c-a81f-ee9807292aa1
md"""

# Programming is too difficult!

$(podcast)

$(br)
$(br)
$(br)

"""

# ╔═╡ 08f9dfa2-28f9-4cda-a888-7068153de44c
show_on_hover(x) = @htl("""
	<span class="show_on_hover">$(x)</span>
	<style>
	.show_on_hover {
		opacity: .1;
		display: block;
    transition: opacity .5s ease-out;
    -moz-transition: opacity .5s ease-out;
    -webkit-transition: opacity .5s ease-out;
    -o-transition: opacity .5s ease-out;
	}
	.show_on_hover:hover {
		opacity: 100%;
	}
	</style>
	""");

# ╔═╡ 399229b6-94d3-429f-9e36-eb49a1ca595f
md"""
> "(...) those of us who are good at abstraction are the ones that flourish in programming, yet, even we don't have the power enough to pull it off. **We're constantly failing and making mistakes and unable to comprehend what it is that we've just done.**"
> 
> -- _**Jonathan Edwards**, Future of Coding #37_
""" |> show_on_hover

# ╔═╡ e889bddb-fe84-40a0-87c9-badc32beafc9
md"""
> "If we could only just **minimize this intense intellectual burden** of programming, then regular people would be able to do it, but we'd also be able to do more."
> 
> -- _**Jonathan Edwards**, Future of Coding #37_



""" |> show_on_hover

# ╔═╡ c6f6f8e8-483a-489f-84c2-e179a5b9de4d
md"""
# Visual programming?
"""

# ╔═╡ 35d6d38c-6795-4608-a046-5025b015eadd
md"""
_How to get the column sums of a matrix:_
"""

# ╔═╡ cb3a2807-038c-4637-a886-83f49d6d9a6a
bigbreak

# ╔═╡ c0d1f009-2690-44ea-98d8-7124a7b0b646
(a=1, b=[2,3], c=Ref(5))

# ╔═╡ 4462eaa4-dfb4-4dbb-bf68-d26c909b072a


# ╔═╡ fe8bd5ea-8190-43a8-9998-1e8ad74c60e2
(a = 123, b = rand(4), c = jl("""
	function f(x)
		y = rand(x)
	end
	"""))

# ╔═╡ 7606d86e-9d13-4b40-86b1-8766a2a19bb4


# ╔═╡ 5420f5c8-bcd9-4316-886c-c55955d523fd


# ╔═╡ 33931c2d-a63f-4bc1-9e6c-af12f49357df
md"""
### Used in PlutoTest.jl:
"""

# ╔═╡ f11d2ede-522c-4281-abdb-9002257d6191
@test sqrt(12 + 12) > 3

# ╔═╡ fabef496-0ba4-4ed8-b0ee-669b3a841f5b
@test 5 ∈ filter(iseven, [x^2 for x in 1:6])

# ╔═╡ a81d7ed8-cf2a-4082-b2e1-6b27348c4d33
hello

# ╔═╡ 00bc0ea3-bdd0-45bc-8890-2f31d99d9989
@test left == right

# ╔═╡ 9030f04b-09cd-42dd-bc62-d2fcbf5629e2
bigbreak

# ╔═╡ d250b611-6f42-4e43-886e-5c0550cda037
md"""
## Code and LaTeX
"""

# ╔═╡ 6a97635a-a6fa-4cae-bbe7-50c4db2ace99


# ╔═╡ 3159c138-3146-4572-956c-d49708714b07
bigbreak

# ╔═╡ 74c53f70-a993-4759-b31c-33d1708af27f
md"""
## Widgets and code
"""

# ╔═╡ 99c3580b-a22e-4df0-869f-d73303c087ff
@bind hi TextField(default="asdfasdfasdf")

# ╔═╡ 24776638-d84f-4438-8a8d-278e3f89b542
hi

# ╔═╡ b18fabaf-4f79-414c-9cb5-e63bbea84c41
br

# ╔═╡ cdbd6980-747c-4936-b5ee-597bd49b041c


# ╔═╡ 950faf39-8e9b-4cdd-afed-0f2aecfb4ef0
function TextField2(; default="")
	
	@htl("""
		
		<script>
		
		const init = $(default)
		
		const el = html`<input>`
		
		el.value = init
		
		const cm = currentScript.closest("pluto-cell").querySelector(".CodeMirror").CodeMirror
		
		el.addEventListener("input", () => {
			const old_value = cm.getValue()
		
			const new_command = `TextField2(default=\${JSON.stringify(el.value)})`
			
			
			cm.setValue(old_value.replace(/TextField2\\(.*default\\=\\".*\\"\\)/, new_command))
			
	})
		
		return el
		</script>
		
		""")
	
	
end

# ╔═╡ e3654826-c3e0-4473-ac0a-e750cd2677c9
@bind howdy TextField2(default="asdfasdfasdfasdf")

# ╔═╡ d7e02ef6-9c17-4c90-ac9b-4d6fca88cbea
howdy

# ╔═╡ 1c4d7d9a-3492-4018-bab3-62f49bf522e0
bigbreak

# ╔═╡ 32665c5c-39d8-472c-b4a0-2595dac8afaa
md"""
## Visual _and_ textual programming?
"""

# ╔═╡ fca45d57-e5d8-4cbe-bb09-3572870281a8
bigbreak

# ╔═╡ 7196aaff-78f2-460d-9b84-9e02f7036be3
bigbreak

# ╔═╡ 8629e702-7d21-49a3-a82d-99ae608a7077
macro widget(expr)
	esc(expr)
end

# ╔═╡ b8138809-cc22-4ee2-89b0-4801775bd32e
slider(x) = x

# ╔═╡ 2e51c19e-dfaa-44bb-9fdf-8bfa444353eb
x = [
	@widget(slider(95)) @widget(slider(44))
	@widget(slider(40)) @widget(slider(21))
	]

# ╔═╡ e4cbfda6-9c10-41db-977f-82948b3b542d
x

# ╔═╡ 8eade898-fc7a-4ea6-9bff-98726b2e7b09
checkbox(x) = x

# ╔═╡ e38b1738-38d1-4822-a699-a72f57ab4b42
plot([1,4,5]; 
	linewidth = @widget(slider(16)),
	legend = @widget(checkbox(false)),
)

# ╔═╡ 87206d83-5aea-4c88-b3ce-45b570cd15df
@widget(slider(28)), @widget(checkbox(true))

# ╔═╡ fee84fce-9c36-470e-ae6b-a682e4fc5a5a
stackrows(x) = permutedims(hcat(x...),(2,1))

# ╔═╡ 3115cec1-55fa-423d-8d85-6b74e040cca3
begin
	Base.@kwdef struct Div
		contents
		style=Dict()
	end
	
	Div(x) = Div(contents=x)
	
	function Base.show(io::IO, m::MIME"text/html", d::Div)
		h = @htl("""
			<div style=$(d.style)>
			$(d.contents)
			</div>
			""")
		show(io, m, h)
	end
	
	Div
end

# ╔═╡ 868e7ecc-908a-4c55-9a47-40bf00a5389e
outline(x) = Div(x, Dict(
		"border" => "3px solid rgba(0,0,0,.3)",
		"border-radius" => "3px",
		"padding" => "5px",
		))

# ╔═╡ f1a969cd-d7f7-4517-898f-23e772ffffb1
Div(
	[md"""
	```julia
	function height(p)
		c1 * sqrt(p * c2)
	end
	```
	""",
	md"to",
	md"""
	```julia
	function height(p)
		c1 * log(p * c2)
	end
	```
	"""],
	Dict(
		"display" => "flex",
		"justify-content" => "space-evenly",
		"align-items" => "center",
	))

# ╔═╡ e5a4b22c-bbb4-4c81-9f52-3d327bca00cf
flex(x::Union{AbstractVector,Base.Generator}; kwargs...) = flex(x...; kwargs...)

# ╔═╡ 1df0fc0c-21e4-498d-abf1-8e5924d31a28
function flex(args...; kwargs...)
	Div(;
		contents=collect(args),
		style=Dict("display" => "flex", ("flex-" * String(k) => string(v) for (k,v) in kwargs)...)
		)
end

# ╔═╡ f14424b0-8a3f-4892-aa46-9b37571ce8cb
flex([
		html"""
		<div>
		<h4>Scratch</h4>
		
		<p><img src="https://user-images.githubusercontent.com/6933510/124468203-1d862f00-dd99-11eb-8677-7f6b7b5c8989.png" width="80%"></p>
		</div>
		"""
		
		html"<div>"
		
		md"""
		#### LabVIEW
		
		![image](https://user-images.githubusercontent.com/6933510/124467529-40641380-dd98-11eb-8719-077965de1ea6.png)
		"""
	])


# ╔═╡ c84cf597-2bec-4d6f-b757-c7e986d8be67
function grid(items::AbstractMatrix; fill_width::Bool=true)
	Div(
		contents=Div.(vec(permutedims(items, [2,1]))), 
		style=Dict(
			"display" => fill_width ? "grid" : "inline-grid", 
			"grid-template-columns" => "repeat($(size(items,2)), auto)",
			"column-gap" => "1em",
		),
	)
end

# ╔═╡ 30c6024a-9a71-4058-acb0-dff147af4469
function aside(x)
	@htl("""
		<style>
		
		
		@media (min-width: calc(700px + 30px + 300px)) {
			aside.plutoui-aside-wrapper {
				position: absolute;
				right: -11px;
				width: 0px;
				transform: translate(0, -40%);
			}
			aside.plutoui-aside-wrapper > div {
				width: 300px;
			}
		}
		</style>
		
		<aside class="plutoui-aside-wrapper">
		<div>
		$(x)
		</div>
		</aside>
		
		""")
end

# ╔═╡ 69faf33d-ac2d-4050-a874-55a0fac77d23
cpp_ex = md"""
	#### C++
		
	```js
	vector <int> result;
	result.resize(cols);
	for(size_t j = 0; j < cols; ++j)
	{
		int sum = 0;
		for(size_t i = 0; i < rows; ++i)
		{
			sum += A[i][j];
		}
		result[j] = sum;
	}
	```
	""";

# ╔═╡ b58207ea-3797-4b7d-af0b-74cb1f5a107f
x86_ex = md"""
#### Assembly

```js
main:
        push    rbp
        mov     rbp, rsp
        push    rbx
        sub     rsp, 104
        lea     rax, [rbp-80]
        mov     rdi, rax
        call    std::vector<std::vector<int, std::allocator<int> >, std::allocator<std::vector<int, std::allocator<int> > > >::vector() [complete object constructor]
        mov     QWORD PTR [rbp-48], 2
        mov     QWORD PTR [rbp-56], 2
        mov     rdx, QWORD PTR [rbp-48]
        lea     rax, [rbp-80]
        mov     rsi, rdx
        mov     rdi, rax
        call    std::vector<std::vector<int, std::allocator<int> >, std::allocator<std::vector<int, std::allocator<int> > > >::resize(unsigned long)
        lea     rax, [rbp-112]
        mov     rdi, rax
        call    std::vector<int, std::allocator<int> >::vector() [complete object constructor]
        mov     rdx, QWORD PTR [rbp-56]
        lea     rax, [rbp-112]
        mov     rsi, rdx
        mov     rdi, rax
        call    std::vector<int, std::allocator<int> >::resize(unsigned long)
        mov     QWORD PTR [rbp-24], 0
        jmp     .L12
.L15:
        mov     DWORD PTR [rbp-28], 0
        mov     QWORD PTR [rbp-40], 0
        jmp     .L13
.L14:
        mov     rdx, QWORD PTR [rbp-40]
        lea     rax, [rbp-80]
        mov     rsi, rdx
        mov     rdi, rax
        call    std::vector<std::vector<int, std::allocator<int> >, std::allocator<std::vector<int, std::allocator<int> > > >::operator[](unsigned long)
        mov     rdx, rax
        mov     rax, QWORD PTR [rbp-24]
        mov     rsi, rax
        mov     rdi, rdx
        call    std::vector<int, std::allocator<int> >::operator[](unsigned long)
        mov     eax, DWORD PTR [rax]
        add     DWORD PTR [rbp-28], eax
        add     QWORD PTR [rbp-40], 1
.L13:
        mov     rax, QWORD PTR [rbp-40]
        cmp     rax, QWORD PTR [rbp-48]
        jb      .L14
        mov     ebx, DWORD PTR [rbp-28]
        mov     rdx, QWORD PTR [rbp-24]
        lea     rax, [rbp-112]
        mov     rsi, rdx
        mov     rdi, rax
        call    std::vector<int, std::allocator<int> >::operator[](unsigned long)
        mov     DWORD PTR [rax], ebx
        add     QWORD PTR [rbp-24], 1
.L12:
        mov     rax, QWORD PTR [rbp-24]
        cmp     rax, QWORD PTR [rbp-56]
        jb      .L15
        lea     rax, [rbp-112]
        mov     rdi, rax
        call    std::vector<int, std::allocator<int> >::~vector() [complete object destructor]
        lea     rax, [rbp-80]
        mov     rdi, rax
        call    std::vector<std::vector<int, std::allocator<int> >, std::allocator<std::vector<int, std::allocator<int> > > >::~vector() [complete object destructor]
        mov     eax, 0
        jmp     .L21
        mov     rbx, rax
        lea     rax, [rbp-112]
        mov     rdi, rax
        call    std::vector<int, std::allocator<int> >::~vector() [complete object destructor]
        jmp     .L18
        mov     rbx, rax
.L18:
        lea     rax, [rbp-80]
        mov     rdi, rax
        call    std::vector<std::vector<int, std::allocator<int> >, std::allocator<std::vector<int, std::allocator<int> > > >::~vector() [complete object destructor]
        mov     rax, rbx
        mov     rdi, rax
        call    _Unwind_Resume
.L21:
        mov     rbx, QWORD PTR [rbp-8]
        leave
        ret
.LC0:
        .string "vector::_M_default_append"

__static_initialization_and_destruction_0(int, int):
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     DWORD PTR [rbp-4], edi
        mov     DWORD PTR [rbp-8], esi
        cmp     DWORD PTR [rbp-4], 1
        jne     .L245
        cmp     DWORD PTR [rbp-8], 65535
        jne     .L245
        mov     edi, OFFSET FLAT:_ZStL8__ioinit
        call    std::ios_base::Init::Init() [complete object constructor]
        mov     edx, OFFSET FLAT:__dso_handle
        mov     esi, OFFSET FLAT:_ZStL8__ioinit
        mov     edi, OFFSET FLAT:_ZNSt8ios_base4InitD1Ev
        call    __cxa_atexit
.L245:
        nop
        leave
        ret
_GLOBAL__sub_I_main:
        push    rbp
        mov     rbp, rsp
        mov     esi, 65535
        mov     edi, 1
        call    __static_initialization_and_destruction_0(int, int)
        pop     rbp
        ret
```
""";

# ╔═╡ d43d73a5-6dfc-441f-b298-2ed70cfbe6d7
Div(
	[
		Div(
			x86_ex
			,
			Dict(
				"max-width" => "200px",
				"max-height" => "400px",
				"overflow" => "auto",
				)),
	md"👉",
		Div(
			cpp_ex
			,
			Dict(
				"max-width" => "200px",
				)),
		
	md"👉",
	md"""
	#### Julia
	```julia
	sum(A; dims=1)
	```
	"""],
	Dict(
		"display" => "flex",
		"justify-content" => "space-evenly",
		"align-items" => "center",
	))

# ╔═╡ 99bdcfab-14ce-428d-997f-01038b863d69
import PlutoTest: @visual_debug

# ╔═╡ 3d1b0b7b-3231-4f90-be92-90124caa7594
@visual_debug begin
	(1+2) + (7-6)
	miniplot(2000 .+ 30 .* rand(2+2))
	4+5
	sqrt(sqrt(sqrt(5)))
	md"# Wow"
end

# ╔═╡ 9690aace-803f-41a1-894b-bafbb1476335
@visual_debug begin
	tex_example
	miniplot(2000 .+ 30 .* rand(2+2))
	4+5
	sqrt(sqrt(sqrt(5)))
	md"# Wow"
end

# ╔═╡ 95aa341e-f845-4500-a21b-27ec0bab9c4a
miniplot(x...; kwargs...) = Plots.plot(x...; kwargs..., size=(200,100))

# ╔═╡ c955769b-06cf-4bac-9ac9-59c3c7a0dcf0
begin
	Base.@kwdef struct SlottedLaTeX
		parts::Vector{String}
		slots::Vector{Any}
		# displaymode::Bool=true
	end
	function Base.show(io::IO, m::MIME"text/html", sl::SlottedLaTeX)
		h = @htl("""
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.13.11/dist/katex.min.css" integrity="sha384-Um5gpz1odJg5Z4HAmzPtgZKdTBHZdw8S29IecapCSB31ligYPhHQZMIlWLYQGVoc" crossorigin="anonymous">
			<style>
			.katex .base, 
			.katex .strut {
				/*display: inline-flex !important;*/
				pointer-events: none;
			}
			.SlottedLaTeX {
				font-size: .75em;
			}
			.SlottedLaTeX .slot {
				pointer-events: initial;
			}
			</style>
		<script src="https://cdn.jsdelivr.net/npm/katex@0.13.11/dist/katex.min.js" integrity="sha384-YNHdsYkH6gMx9y3mRkmcJ2mFUjTd0qNQQvY9VYZgQd7DcN7env35GzlmFaZ23JGp" crossorigin="anonymous"></script>
		<span class="SlottedLaTeX-slots" style="display: none;">
		$(
			map(sl.slots) do s
				@htl("<span class='slot'>$(s)</span>")
			end
		)
		</span>
		<script>

		// https://unicode-table.com/en/#2800
		const braille_start = 10240
		// https://unicode-table.com/en/#03B1
		const greek_start = 945

		const placeholder = (i) => String.fromCodePoint(braille_start + i)
		const placeholder_index = (s) => s.codePointAt(0) - braille_start

		const k = (segments, ...slots) => {

			const mock = [...slots.flatMap((_, i) => [segments[i], placeholder(i)]), segments[segments.length-1]].join("")

			const el = html`<span class='SlottedLaTeX'></span>`
			katex.render(mock, el, {
				displayMode: currentScript.closest("p") == null,
			})


			Array.from(el.querySelectorAll("span")).forEach(span => {
				const t = span.innerText
				if(t.length === 1) {
					const i = placeholder_index(t)
					if(0 <= i && i < slots.length) {
						span.replaceWith(slots[i])
					}

				}
			})

			return el
		}

		const parts = $(sl.parts)

		console.log(parts)
		const slots = Array.from(currentScript.previousElementSibling.children)

		console.log(slots)
		return k(parts, ...slots)

		</script>


		""")

		Base.show(io, m, h)
	end
end

# ╔═╡ 70557b20-88e3-4346-a5fd-3382f68e0590
begin
	macro tex(x)
		tex(x)
	end
	# `_str` macros with interpolation are not reactive in pluto 🙈 until https://github.com/fonsp/Pluto.jl/pull/1032 is fixed. :((
	#macro tex_str(_x::String)
	#	x = Meta.parse("\"" * _x * "\"")
 	#	tex(x)
	#end
	function tex(ex::Expr)
		@assert ex.head === :string
		if ex.args[1] isa String
			parts = String[ex.args[1]]
			slots = Any[]
		else
			parts = ["\\hspace{0pt}"]
			slots = [ex.args[1]]
		end
		for x in ex.args[2:end]
			if x isa String			
				all(==(' '), x) ? push!(parts, "\\hspace{0pt}") : push!(parts, x)
			else
				length(parts) != length(slots) + 1 && push!(parts, "\\hspace{0pt}")
				push!(slots, x)
			end
		end
		if length(slots) == length(parts)
			push!(parts, "\\hspace{0pt}")
		end
		quote
			SlottedLaTeX(
				parts = $parts,
				slots = [$(esc.(slots)...)],
			)
		end
	end
	function tex(x::String)
		SlottedLaTeX(
			parts=[x],
			slots=[],
		)
	end
end

# ╔═╡ dbfa3b38-ccd3-48cb-add5-8ad3962a976c
tex_example = @tex("""
	f(x) = 
	\\oint_{
		x \\in \\mathbb{R}
	}
	\\frac{
		1 + $(Slider(1:100))
	}{
		$(embed_display([1,2,23])) + x
	}
	""")

# ╔═╡ ac065b33-f9fd-41d3-a9a8-f3579bd5f31b
smalldog = html"""
<img src='https://user-images.githubusercontent.com/6933510/116753174-fa40ab80-aa06-11eb-94d7-88f4171970b2.jpeg' height=30px>"""

# ╔═╡ 45e5c62b-40df-4f6a-8a22-ae093a2fcb12
@tex("""
	f(x) = 
	\\oint_{
		x \\in \\mathbb{R}
	}
	\\frac{
		1 + $(smalldog)
	}{
		$(@bind z Scrubbable(5)) + x
	}
	""")

# ╔═╡ fc4ea0a9-cfc9-42a0-ac03-63afaaaab117
z

# ╔═╡ 7d93e8bb-4305-4942-8fd9-a7c6757237a2
bigbreak

# ╔═╡ d2183a30-f1cd-4262-b51e-16e1e21ade38
bigbreak

# ╔═╡ 61277f1a-72b3-46f5-a2bd-5d9ca7c0f172
hello = 123

# ╔═╡ b2fbe633-21d9-4211-88ba-8dad66823d3b
@bind hello Slider(1:10)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoTest = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.8.0"
Plots = "~1.16.6"
PlutoTest = "~0.1.0"
PlutoUI = "~0.7.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c3598e525718abcc440f69cc6d5f60dda0a1b61e"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.6+5"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "e2f47f6d8337369411569fd45ae5753ca10394c6"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.0+6"

[[ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random", "StaticArrays"]
git-tree-sha1 = "c8fd01e4b736013bc61b704871d20503b33ea402"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.12.1"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "dc7dedc2c2aa9faf59a55c622760a25cbefbe941"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.31.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[DataAPI]]
git-tree-sha1 = "ee400abb2298bd13bfc3df1c412ed228061a2385"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.7.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "4437b64df1e0adccc3e5d1adbc3ac741095e4677"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.9"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "92d8f9f208637e8d2d28c664051a00569c01493d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.1.5+1"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b3bfd02e98aedfa5cf885665493c5598c350cd2f"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.2.10+0"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "LibVPX_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "3cc57ad0a213808473eafef4845a74766242e05f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.3.1+4"

[[FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "35895cf184ceaab11fd778b4590144034a167a2f"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.1+14"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "cbd58c9deb1d304f5a245a0b7eb841a2560cfec6"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.1+5"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "0c603255764a1fa0b61752d2bec14cfbd18f7fe8"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.5+1"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "b83e3125048a9c3158cbb7ca423790c7b1b57bea"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.57.5"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "e14907859a1d3aee73a019e7b3c98e9e7b8b5b3e"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.57.3+0"

[[GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "4136b8a5668341e58398bb472754bff4ba0456ff"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.3.12"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "47ce50b742921377301e15005c96e979574e130b"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.1+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "86ed84701fbfd1142c9786f8e53c595ff5a4def9"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.10"

[[HypertextLiteral]]
git-tree-sha1 = "1e3ccdc7a6f7b577623028e0095479f4727d8ec1"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.8.0"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "81690084b6198a2e1da36fcfda16eeca9f9f24e4"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.1"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "c7f1c695e06c01b95a67f0cd1d34994f3e7db104"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.2.1"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "a4b12a1bd2ebade87891ab7e36fdbce582301a92"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.6"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.81.0+0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[LibVPX_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "12ee7e23fa4d18361e7c2cde8f8337d4c3101bc7"
uuid = "dd192d2f-8180-539f-9fb4-cc70b1dcf69a"
version = "1.10.0+0"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "c9551dd26e31ab17b86cbd00c2ede019c08758eb"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+1"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "6a8a2a625ab0dea913aba95c11370589e0239ff0"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.6"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "4ea90bd5d3985ae1f9a908bd4500ae88921c5ce7"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.0"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "15003dcb7d8db3c6c857fda14891a539a8f2705a"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.10+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "c8abc88faa3f7a3950832ac5d6e690881590d6dc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "1.1.0"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[PlotThemes]]
deps = ["PlotUtils", "Requires", "Statistics"]
git-tree-sha1 = "a3a964ce9dc7898193536002a6dd892b1b5a6f1d"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "2.0.1"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "ae9a295ac761f64d8c2ec7f9f24d21eb4ffba34d"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.0.10"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs"]
git-tree-sha1 = "a680b659a1ba99d3663a40aa9acffd67768a410f"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.16.6"

[[PlutoTest]]
deps = ["HypertextLiteral", "InteractiveUtils", "Markdown", "Test"]
git-tree-sha1 = "3479836b31a31c29a7bac1f09d95f9c843ce1ade"
uuid = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
version = "0.1.0"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "b3fb709f3c97bfc6e948be68beeecb55a0b340ae"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.1.1"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "9b8e57e3cca8828a1bc759840bfe48d64db9abfb"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.3.3"

[[Reexport]]
git-tree-sha1 = "5f6c21241f0f655da3952fd60aa18477cf96c220"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.1.0"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "2ec1962eba973f383239da22e75218565c390a96"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.0"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "745914ebcd610da69f3cb6bf76cb7bb83dcb8c9a"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.4"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "1958272568dc176a1d881acb797beb909c785510"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.0.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "2f6792d523d7448bbe2fec99eca9218f06cc746d"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.8"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "Tables"]
git-tree-sha1 = "44b3afd37b17422a62aea25f04c1f7e09ce6b07f"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.5.1"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "8ed4a3ea724dac32670b062be3ef1c1de6773ae8"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.4.4"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll"]
git-tree-sha1 = "2839f1c1296940218e35df0bbb220f2a79686670"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.18.0+4"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+1"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "acc685bcf777b2202a904cdcb49ad34c2fa1880c"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.14.0+4"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.0+0"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7a5780a0d9c6864184b3a2eeeb833a0c871f00ab"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "0.1.6+4"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.41.0+1"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "16.2.1+1"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d713c1ce4deac133e3334ee12f4adff07f81778f"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2020.7.14+2"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "487da2f8f2f0c8ee0e83f39d13037d6bbf0a45ab"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.0.0+3"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─ad4f807a-ad18-422f-816b-ac75edfbcc60
# ╟─eb0f1ea4-7e07-4670-8fe4-e531aa918ba3
# ╟─85920cbd-bad3-45d1-99ad-fe9acfab9a02
# ╟─363429f1-d456-4195-9fbe-142ca7f62824
# ╟─0c7a5125-302b-4239-a6bb-5475695c1e68
# ╟─4c019753-a360-4d69-86b2-a92710c5ffad
# ╟─ed6d9e33-2a59-439b-9490-b8c996d257ea
# ╟─b684b0d3-609a-431f-a1ce-08a87d3d4fab
# ╟─a4c1a119-0b52-4576-9d85-597726892b20
# ╟─0e46ef73-60db-4ce6-8752-97f501ebe62f
# ╠═48c1443e-9656-4a97-a42b-4f8db332c7cc
# ╟─0fbcf962-f8f4-471d-b2ed-38ec020df877
# ╠═54d2de83-e336-41fd-923f-76b0a67a094d
# ╠═61277f1a-72b3-46f5-a2bd-5d9ca7c0f172
# ╟─7ec0f50b-937e-4f68-ab0e-af70937757fa
# ╟─1819c538-7ef2-419c-a81f-ee9807292aa1
# ╟─399229b6-94d3-429f-9e36-eb49a1ca595f
# ╟─e889bddb-fe84-40a0-87c9-badc32beafc9
# ╟─08f9dfa2-28f9-4cda-a888-7068153de44c
# ╟─c6f6f8e8-483a-489f-84c2-e179a5b9de4d
# ╟─f14424b0-8a3f-4892-aa46-9b37571ce8cb
# ╟─35d6d38c-6795-4608-a046-5025b015eadd
# ╟─d43d73a5-6dfc-441f-b298-2ed70cfbe6d7
# ╟─cb3a2807-038c-4637-a886-83f49d6d9a6a
# ╟─c0d1f009-2690-44ea-98d8-7124a7b0b646
# ╟─4462eaa4-dfb4-4dbb-bf68-d26c909b072a
# ╟─fe8bd5ea-8190-43a8-9998-1e8ad74c60e2
# ╟─7606d86e-9d13-4b40-86b1-8766a2a19bb4
# ╟─3d1b0b7b-3231-4f90-be92-90124caa7594
# ╟─5420f5c8-bcd9-4316-886c-c55955d523fd
# ╟─33931c2d-a63f-4bc1-9e6c-af12f49357df
# ╠═f11d2ede-522c-4281-abdb-9002257d6191
# ╠═fabef496-0ba4-4ed8-b0ee-669b3a841f5b
# ╠═b2fbe633-21d9-4211-88ba-8dad66823d3b
# ╠═a81d7ed8-cf2a-4082-b2e1-6b27348c4d33
# ╠═00bc0ea3-bdd0-45bc-8890-2f31d99d9989
# ╟─9030f04b-09cd-42dd-bc62-d2fcbf5629e2
# ╟─d250b611-6f42-4e43-886e-5c0550cda037
# ╟─45e5c62b-40df-4f6a-8a22-ae093a2fcb12
# ╠═fc4ea0a9-cfc9-42a0-ac03-63afaaaab117
# ╟─dbfa3b38-ccd3-48cb-add5-8ad3962a976c
# ╟─6a97635a-a6fa-4cae-bbe7-50c4db2ace99
# ╟─9690aace-803f-41a1-894b-bafbb1476335
# ╟─3159c138-3146-4572-956c-d49708714b07
# ╟─74c53f70-a993-4759-b31c-33d1708af27f
# ╠═cf0eb30e-f299-43d7-ab31-8a48ebc647ed
# ╠═99c3580b-a22e-4df0-869f-d73303c087ff
# ╠═24776638-d84f-4438-8a8d-278e3f89b542
# ╟─b18fabaf-4f79-414c-9cb5-e63bbea84c41
# ╠═e3654826-c3e0-4473-ac0a-e750cd2677c9
# ╠═d7e02ef6-9c17-4c90-ac9b-4d6fca88cbea
# ╟─cdbd6980-747c-4936-b5ee-597bd49b041c
# ╟─d1696d25-1f3c-4a4a-b287-7f0035c897c7
# ╟─950faf39-8e9b-4cdd-afed-0f2aecfb4ef0
# ╟─1c4d7d9a-3492-4018-bab3-62f49bf522e0
# ╟─32665c5c-39d8-472c-b4a0-2595dac8afaa
# ╠═2e51c19e-dfaa-44bb-9fdf-8bfa444353eb
# ╠═e4cbfda6-9c10-41db-977f-82948b3b542d
# ╟─fca45d57-e5d8-4cbe-bb09-3572870281a8
# ╟─7196aaff-78f2-460d-9b84-9e02f7036be3
# ╠═e38b1738-38d1-4822-a699-a72f57ab4b42
# ╠═87206d83-5aea-4c88-b3ce-45b570cd15df
# ╟─8629e702-7d21-49a3-a82d-99ae608a7077
# ╟─b8138809-cc22-4ee2-89b0-4801775bd32e
# ╟─8eade898-fc7a-4ea6-9bff-98726b2e7b09
# ╟─fee84fce-9c36-470e-ae6b-a682e4fc5a5a
# ╟─3115cec1-55fa-423d-8d85-6b74e040cca3
# ╟─868e7ecc-908a-4c55-9a47-40bf00a5389e
# ╟─f1a969cd-d7f7-4517-898f-23e772ffffb1
# ╟─e5a4b22c-bbb4-4c81-9f52-3d327bca00cf
# ╟─1df0fc0c-21e4-498d-abf1-8e5924d31a28
# ╟─c84cf597-2bec-4d6f-b757-c7e986d8be67
# ╟─30c6024a-9a71-4058-acb0-dff147af4469
# ╟─69faf33d-ac2d-4050-a874-55a0fac77d23
# ╟─b58207ea-3797-4b7d-af0b-74cb1f5a107f
# ╟─0bdfd444-f783-4707-ac69-3851dfaa61c2
# ╟─d5e2a7f1-5d44-4e58-91ef-df12e0d007c2
# ╟─99bdcfab-14ce-428d-997f-01038b863d69
# ╟─95aa341e-f845-4500-a21b-27ec0bab9c4a
# ╟─c955769b-06cf-4bac-9ac9-59c3c7a0dcf0
# ╟─70557b20-88e3-4346-a5fd-3382f68e0590
# ╟─ac065b33-f9fd-41d3-a9a8-f3579bd5f31b
# ╟─7d93e8bb-4305-4942-8fd9-a7c6757237a2
# ╟─d2183a30-f1cd-4262-b51e-16e1e21ade38
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
