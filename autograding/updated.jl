### A Pluto.jl notebook ###
# v0.12.4

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

# ╔═╡ 65d601a6-fe45-11ea-22c6-270bf7d353bc
begin
	
		import Pluto
		import UUIDs: UUID
		import Distributed
		using PlutoUI
		using DataFrames
		import CSV
	
end

# ╔═╡ 122cbbdc-00cd-11eb-223b-ef82328f674f
let
	function solution_pascal(n)
		if n <= 1
			[1.0]
		else
			prev = solution_pascal(n - 1)
			0.5 * ([prev..., 0] .+ [0, prev...])
		end
	end

	function solution_gaussian_kernel(n)
		solution_pascal(2n+1)
	end

	K = solution_gaussian_kernel(9)
		K[1] < K[5] < K[9] > K[13] > K[17]
end

# ╔═╡ 68da9dec-e6e1-11ea-1d9e-cdb7028f9b6a
md"# Part 1: autograding"

# ╔═╡ 836cc4be-e6d7-11ea-2a6e-436c187304da
md"## Step 1: Select submission files"

# ╔═╡ 4e4e78d2-f865-11ea-0c21-fdd76cbf3532
md"You need to write some code that returns the **absolute paths** to the students' homework submissions. The following code works for me, but probably not for you."

# ╔═╡ 427f19de-e6d2-11ea-10a8-5d3552224b31
submission_files = let
	all = readdir("/home/fons/disorganised-mess/autograding/submissions/"; join=true)
	filter(f -> endswith(f, ".jl"), all)
end

# ╔═╡ 6b40e1d0-f865-11ea-3c2a-39fb643c8068
md"It should return an arrays of strings, something like:"

# ╔═╡ 728d1ca8-f865-11ea-1a3e-33cb0a44b9dd
submission_files_EXAMPLE = ["/home/fonsi/hw1/submissions/hw1 - fonsi.jl", "/home/fonsi/hw1/submissions/hw1 - template.jl"]

# ╔═╡ 54c9b77c-e6e2-11ea-03ff-5d0d4a9dd763
if !all(isabspath, submission_files)
	md"""
!!! warning
    Submission paths need to be _absolute_
	"""
end

# ╔═╡ d0dd703a-e6da-11ea-1d4f-0b10bf75fad6
md"## Step 2: autograde actions"

# ╔═╡ a0776916-f865-11ea-387a-bf2e3094a182
md"I have already written these, you can ignore this."

# ╔═╡ 490cc11a-00cb-11eb-24bc-2fb026c3094e
all

# ╔═╡ 8c6c6114-e6d7-11ea-20b1-e718907e0767
md"## Step 3: autograde all notebooks"

# ╔═╡ a1598cfc-e6d7-11ea-1f0b-f5560304fe7a
md"**Click to start running the notebooks:**

 $(@bind run_notebooks CheckBox()) run $(length(submission_files)) notebooks

---"

# ╔═╡ b5d0d970-e6d9-11ea-20a5-01f0c4e3875c
pluto_session = Pluto.ServerSession(;options=Pluto.Configuration.from_flat_kwargs(
	launch_browser=false, 
	require_secret_for_open_links=false,
	require_secret_for_access=false,
	workspace_use_distributed=false,
	port=2468,
))

# ╔═╡ a6fe722e-e6da-11ea-21e8-1dea77b462ef
submission_files_to_run = run_notebooks ? Pluto.tamepath.(submission_files) : String[]

# ╔═╡ 9982bbfa-00c0-11eb-0a5c-818fae8c01ce
Pluto

# ╔═╡ 5642a754-e6d9-11ea-35b6-0fe20d6a098e
notebooks = let
	for nb in values(pluto_session.notebooks)
		Pluto.SessionActions.shutdown(pluto_session, nb)
    end
	map(submission_files_to_run) do path
		nb = Pluto.load_notebook(Pluto.tamepath(path))
		pluto_session.notebooks[nb.notebook_id] = nb
		Pluto.update_save_run!(pluto_session, nb, nb.cells; run_async=false, prerender_text=true)
		nb
	end
end

# ╔═╡ 3f0aec92-e6e1-11ea-1b53-29b7b543674d


# ╔═╡ 3fb6b20c-e6e1-11ea-35eb-e74598e31daf
md"# Part 2: manual review"

# ╔═╡ 9090ee3e-e6de-11ea-14c3-27032e8710d3
md"## Step 1: start notebook server"

# ╔═╡ 9c1c40f0-e6de-11ea-08d8-77acb2a550d4
md"**Click to start notebook server:**

 $(@bind run_server CheckBox()) run notebook server

---"

# ╔═╡ a3e47050-e6de-11ea-2a91-0597143f71ba
if run_server
	@async Pluto.run(pluto_session)
	
	md"> Server is running at [https://localhost:2468](https://localhost:2468)"
end

# ╔═╡ 657f23ce-f687-11ea-13c0-f9959437ddf5
md"## Step 2: manual grade actions"

# ╔═╡ 8904534a-e6e1-11ea-34b7-31d1f6f8ca8f
md"## Step 3: select notebook"

# ╔═╡ eade89f2-e6de-11ea-11bb-531a6b65c666
@bind inspected_notebook_index_str Select([string(i) => nb.path for (i,nb) in enumerate(notebooks)])

# ╔═╡ 9815b7f4-f686-11ea-0760-05b34811be7f
md"#### Autograde results for selected homework"

# ╔═╡ b8d4598c-f686-11ea-24dc-6f94370fc996
md"#### Editable view of selected homework"

# ╔═╡ ca945d02-f686-11ea-03b4-393858220381
md"#### Manual grading"

# ╔═╡ dfbaecac-f855-11ea-1f3e-0522a86136ea
md"Currently stored grades for this notebook:"

# ╔═╡ 0ae5802c-f856-11ea-11ac-31a3ba67606c
@bind reset_results Button("Reset manual results")

# ╔═╡ 633ee8e4-f68a-11ea-271e-433eafd12a62
manual_results_dict = let
	reset_results
	Dict()
end;

# ╔═╡ 06edecc6-f864-11ea-03b0-03db23d2c780


# ╔═╡ 1a999dfe-e6e1-11ea-12f4-ed24f03245e0
inspected_notebook_index = parse(Int, inspected_notebook_index_str)

# ╔═╡ 64c26a50-e6df-11ea-2762-57186f445501
inspected_notebook = notebooks[inspected_notebook_index]

# ╔═╡ b6b986c8-e6de-11ea-1d13-5d9d370eccdc
if run_server
	cd(inspected_notebook.path |> dirname)
	"""
	<iframe src="http://localhost:2468/edit?id=$(inspected_notebook.notebook_id)" style="width: calc(100% - 8px); height: 100vh; margin: 0; border: 4px solid pink;"  allow="camera;microphone">
	""" |> HTML
end

# ╔═╡ 8d1aaee8-e6de-11ea-2c2c-4d2ba138d5ce
md"# Appendix"

# ╔═╡ ce055a44-e6d8-11ea-3a07-75392c0f6c26
md"## Grading actions"

# ╔═╡ c1f5bd3a-e6d2-11ea-20ab-d93e142aa71e
abstract type GradingAction end

# ╔═╡ 9057dc04-e6d2-11ea-196b-1519cac7d248
struct AutoTestAction <: GradingAction
	name
	points_value::Number
	test::Expr
end

# ╔═╡ 3abb56e4-e6d3-11ea-3337-392a434e1a21
struct GetValue <: GradingAction
	name
	getter::Expr
end

# ╔═╡ eaa49370-e6da-11ea-21d9-ddf11a7df51f
actions = let
	prologue = quote

function solution_extend(v, i)
	if i < 1
		v[1]
	elseif i > length(v)
		v[end]
	else
		v[i]
	end
end

function solution_blur_1D(v, l)
	return map(eachindex(v)) do i
		mean([extend(v, i+j) for j in -l:l])
	end
end

function solution_convolve_vector(v, k)
	l = (length(k) - 1) ÷ 2
	return map(eachindex(v)) do i
		sum([extend(v, i - j) * k[j + 1 + l] for j in -l:l])
	end
end

function solution_pascal(n)
	if n <= 1
		[1.0]
	else
		prev = pascal(n - 1)
		0.5 * ([prev..., 0] .+ [0, prev...])
	end
end

function solution_gaussian_kernel(n)
	solution_pascal(2n+1)
end

function solution_extend_mat(M::AbstractMatrix, i, j)
	if i < 1
		solution_extend_mat(M, 1, j)
	elseif i > size(M, 1)
		solution_extend_mat(M, size(M,1), j)
	else
		if j < 1
			solution_extend_mat(M, i, 1)
		elseif j > size(M, 2)
			solution_extend_mat(M, i, size(M,2))
		else
			M[i,j]
		end
	end
end

function solution_convolve_image(M::AbstractMatrix, K::AbstractMatrix)
	l = (size(K,1) - 1) ÷ 2
	
	map(CartesianIndices(M)) do i
		sum(CartesianIndices(K)) do a
			
			offset = a - CartesianIndex(-l-1, -l-1)
			
			extend_mat(M, (i - offset).I...) * K[a]
		end
	end
end

function solution_convolve_image_inverted(M::AbstractMatrix, K::AbstractMatrix)
	l = (size(K,1) - 1) ÷ 2
	
	map(CartesianIndices(M)) do i
		sum(CartesianIndices(K)) do a
			
			offset = a - CartesianIndex(-l-1, -l-1)
			
			extend_mat(M, (i + offset).I...) * K[a]
		end
	end
end


function solution_with_gaussian_blur(image; sigma=3, l=5)
	gauss(x,y; sigma=3) = (1/(2*pi*sigma^2))exp(-(x^2 + y^2)/(2*sigma^2))
	K_gauss = [gauss(xy...) for xy in Iterators.product(-l:l,-l:l)]
	convolve_image(image, K_gauss ./ sum(K_gauss))
end

function solution_sobel_edge_detect(image)
	K_sobol = [
	1 0 -1
	2 0 -2
	1 0 -1
	]
	x = solution_convolve_image(image, K_sobol)
	y = solution_convolve_image(image, K_sobol')
	return x .* x .+ y .* y
end
		
		testimg() = rand(RGB, (10, 20))
end



actions = [
GetValue("name", :(student.name)),
GetValue("kerberos_id", :(student.kerberos_id)),

##Excercise 1.1
AutoTestAction("1.1 - random vector", 5, quote
length(random_vect) == 10 && length(Set(random_vect)) == 10
end),

AutoTestAction("1.1 - mean", 5, quote
mean([-1, -1, 2]) ≈ 0
end),

AutoTestAction("1.1 - mean of random vec", 2.5, quote
m == mean(random_vect)
end),

AutoTestAction("1.1 - demean function", 5, quote
demean([1,2,3,4,5]) ≈ [-2,-1,0,1,2]
end),

##Excercise 1.2
AutoTestAction("1.2 - create bar - 20", 2.5, quote
create_bar() ≈ let
		x = zeros(100)
		x[40:59] .= 1
		x
	end
end),

AutoTestAction("1.2 - create bar - 20 or 21", 2.5, quote
create_bar() ≈ let
		x = zeros(100)
		x[40:59] .= 1
		x
	end || 
create_bar() ≈ let
		x = zeros(100)
		x[40:60] .= 1
		x
	end
end),

##Excercise 1.3
AutoTestAction("1.3 - vecvec_to_matrix", 5, quote
vecvec_to_matrix([[1,2,3], [4,5,6], [7,8,9]]) == hcat([1,2,3], [4,5,6], [7,8,9]) ||
vecvec_to_matrix([[1,2,3], [4,5,6], [7,8,9]]) == hcat([1,2,3], [4,5,6], [7,8,9])'
end),

AutoTestAction("1.3 - matrix_to_vecvec", 5, quote
				let
					A = [1 2; 4 5; 7 8]
matrix_to_vecvec(A) == collect(eachcol(A)) ||
matrix_to_vecvec(A) == collect(eachrow(A))
				end
end),

##Excercise 2.1
AutoTestAction("2.1 - mean colors", 5, quote
$(prologue)
				t = testimg()
mean_colors(t) == (mean(t).r, mean(t).g, mean(t).b) ||
mean_colors(t) == RGB(mean(t).r, mean(t).g, mean(t).b)
end),

##Excercise 2.2
AutoTestAction("2.2 - quantize::Number", 5, quote
quantize(3) ≈ (floor(30) / 10)
end),

##Excercise 2.3
AutoTestAction("2.3 - quantize::Color", 2.5, quote
				c = rand(RGB)
quantize(c) == RGB(quantize(c.r), quantize(c.g), quantize(c.b))
end),

##Excercise 2.4
AutoTestAction("2.4 - quantize::AbstractMatrix", 2.5, quote
$(prologue)
				t = testimg()
quantize(t) == quantize.(t)
end),

##Excercise 2.5
AutoTestAction("2.5 - invert", 5, quote
				c = rand(RGB)
invert(c) == RGB(1-c.r, 1-c.g, 1-c.b)
end),

##Excercise 2.6
AutoTestAction("2.6 - noisify::Number - noise", 2.5, quote
				
				
let
	N = 10_000
	
	# x = [.5 + rand()*.5 + .25 for _ in 1:N]
	x = [noisify(.5, .25) for _ in 1:N]
	sample_mean = sum(x) / N

	sample_var = sum((x .- sample_mean) .^ 2) / N
	
	abs(sample_mean - .5) < .01 && abs(sample_var - 1/48) < .01
end

end),
AutoTestAction("2.6 - noisify::Number - clamp", 2.5, quote
				
				
let
	N = 10_000
	
	# x = [rand()*.5 + .25 for _ in 1:N]
	x = [noisify(.5, 10) for _ in 1:N]
	
	0.0 <= minimum(x) < maximum(x) <= 1.0
end

end),

AutoTestAction("2.6 - noisify::Color", 2.5, quote
	c = rand(RGB)
	noisify(c, .1) != c
end),

AutoTestAction("2.6 - noisify::Image", 2.5, quote
$(prologue)
	t = testimg()
	noisify(t, .1) != t
end),

##Excercise 3.1
# N/A

##Excercise 3.2
AutoTestAction("3.2 - extend", 10, quote
$(prologue)
extend(v, -5)  == solution_extend(v, -5)
end),

##Excercise 3.3
AutoTestAction("3.3 - blur_1D", 5, quote
$(prologue)
blur_1D(v, 2) == solution_blur_1D(v, 2)
end),

##Exercise 3.4
# N/A

##Excercise 3.5
AutoTestAction("3.5 - convolution", 5, quote
$(prologue)
convolve_vector([1, 10, 100, 1000, 10000], [0, 1, 0]) == solution_convolve_vector([1, 10, 100, 1000, 10000], [0, 1, 0])
end),

##Excercise 3.6
AutoTestAction("3.6 - gaussian_kernel - centered", 2.5, quote
K = gaussian_kernel(9)
				
center = length(K) ÷ 2
				
K[1] < K[center] > K[end]

end),

AutoTestAction("3.6 - gaussian_kernel - normalized", 2.5, quote
K = gaussian_kernel(9)
.9 < sum(K) < 1.1
end),

##Excercise 4.1
AutoTestAction("4.1 - extend mat", 10, quote
$(prologue)
				M = rand(Float64, (3,3))
				all([
		extend_mat(M, i, j) ≈ solution_extend_mat(M, i, j)
	for i in [-5,4,2], j in [-1,1,0,10]
		])
end),

##Excercise 4.2
# AutoTestAction("4.2 - convolve image", 15, quote
# $(prologue)
# 				M = testimg()
# 				K = rand(Float64, (3,3))
# 	convolve_image(M, K) ≈ solution_convolve_image(M, K) || 
# 	convolve_image(M, K) ≈ solution_convolve_image_inverted(M, K)
# end),

# ##Excercise 4.2
# AutoTestAction("4.2 - convolve image - kernel inverted correctly", 5, quote
# $(prologue)
# 				M = testimg()
# 				K = rand(Float64, (3,3))
# 	convolve_image(M, K) ≈ solution_convolve_image(M, K)
# end),

##Excercise 4.3
AutoTestAction("4.3 - with_gaussian_blur - no error", 5, quote
$(prologue)
		try
			with_gaussian_blur(rand(Gray, (20,10))) isa Array
		catch
			false
		end || try
			with_gaussian_blur(rand(Float64, (20,10))) isa Array
		catch
			false
		end || try
			with_gaussian_blur(rand(RGB, (20,10))) isa Array
		catch
			false
		end
end),

##Excercise 4.4
AutoTestAction("4.4 - sobel_edge_detect - no error", 5, quote
	$(prologue)
		try
			with_sobel_edge_detect(rand(Gray, (20,10))) isa Array
		catch
			false
		end || try
			with_sobel_edge_detect(rand(Float64, (20,10))) isa Array
		catch
			false
		end || try
			with_sobel_edge_detect(rand(RGB, (20,10))) isa Array
		catch
			false
		end
	end),
]

end

# ╔═╡ c0d9fb36-f858-11ea-35c0-77963b5cf57a
sum(actions) do action
	try
		action.points_value
	catch
		0
	end
end

# ╔═╡ 96917e4e-f687-11ea-2256-7b1057a3b523
begin
	struct ManualScoreAction <: GradingAction
		name
		points_value::Number
		rubric
	end
	ManualScoreAction(name, points_value) = ManualScoreAction(name, points_valie, name)
end

# ╔═╡ e5d3fa7c-f687-11ea-044f-6b00f0321da8
begin
	struct ManualCheckAction <: GradingAction
		name
		points_value::Number
		rubric
	end
	ManualCheckAction(name, points_value) = ManualCheckAction(name, points_valie, name)
end

# ╔═╡ 7b3bb8c8-f687-11ea-27bb-45ed5807090e
manual = [
	ManualCheckAction("3.1 - colored line", 5, md"Did they write `colored_line(v)`?"),
	
	ManualScoreAction("3.4 - make it interactive", 8, md"Did they create a slider? Does the slider control the amount of blur?"),
	
	ManualScoreAction("4.2 - convolve_image", 20, md"Is convole_image correct?"),
	ManualScoreAction("4.3 - Gaussian blur", 10, md"Does the Gaussian blur look okay?"),
	ManualScoreAction("4.4 - Sobel filter", 10, md"Does the Sobel filter look okay?"),
]

# ╔═╡ 144aa7ec-f864-11ea-35c4-43e19d898887
sum(manual) do action
	try
		action.points_value
	catch
		0
	end
end

# ╔═╡ 22fd661e-e6e7-11ea-2b4a-8981b17a790d
# struct ManualCheckAction <: GradingAction
# 		name
# 		points_value::Number
# 		rubric
# 	end
begin
	inspected_notebook
	manual_results_dict
@bind inspected_manual_results let
	boxes = map(enumerate(manual)) do (i,action)
		"""<tr>
		<td><input type='number' id='field$(i)' min=0 max=$(action.points_value) step=1 value=$(action.points_value)><code> / $(action.points_value)</code></td>
		<td>$(repr(MIME"text/html"(), action.rubric))</td>
		</tr>"""
	end
	
	"""
<div id="hello">
<table>
	<tbody>
	$(join(boxes))
	</tbody>
</table>
<input type="submit" value="Save!">
	</div>

	
<style>
	div#hello table td {
		text-align: left;
	}
	div#hello table input[type=number] {
		width: 4em;
		text-align: center;
	}
</style>
<script>
	const div = this.querySelector("#hello")
	const table = div.querySelector("table")
	const inputs = table.querySelectorAll("input")
	
	const update_value = () => {
		//div.value = Object.fromEntries(Array.from(inputs).map((b) => [b.id, b.value]))
		div.value = Array.from(inputs).map((b) => Number(b.value))
	}
	
	inputs.forEach(el => {
		el.oninput = (e) => {
			update_value()
			e.stopPropagation()
		}
	})
	
	const submit = div.querySelector("input[type=submit]")
	submit.onclick = () => {
		update_value()
		div.dispatchEvent(new CustomEvent("input", {}))
	}

</script>
""" |> HTML
end
end

# ╔═╡ e9b4c316-f852-11ea-3840-e7b1428df4e9
if inspected_manual_results === missing
	get(manual_results_dict, basename(inspected_notebook.path), 
	md"_Scores for this homework are not yet saved._"
		)
else
	inspected_manual_results
end

# ╔═╡ f131ee3a-f68a-11ea-3d6c-d34439133a63
# reactively add the result to our Dict
updated_manual_results_dict = let
	if inspected_manual_results !== missing
		manual_results_dict[inspected_notebook_index] = inspected_manual_results
	end
	manual_results_dict
end

# ╔═╡ 8b9a3f7a-e6d4-11ea-34c5-ef986e6af936
begin
	
	
	# default
	displayname(action::GradingAction) = action.name
end

# ╔═╡ e48f2a16-e6e1-11ea-070a-d58f87569b91
md"## Misc"

# ╔═╡ 33588e20-e6d4-11ea-08f6-7d10d9ef1481
function eval_in_notebook(notebook::Pluto.Notebook, expr)
	ws = Pluto.WorkspaceManager.get_workspace((pluto_session, notebook))
	fetcher = :(Core.eval($(ws.module_name), $(expr |> QuoteNode)))
	Distributed.remotecall_eval(Main, ws.pid, fetcher)
end

# ╔═╡ 31111cbe-e6d3-11ea-0130-a98e45b82f2b
begin
	function do_action(notebook::Pluto.Notebook, action::AutoTestAction)
		tester = quote
				try
					$(action.test)
				catch
					false
				end
			end
		
		if eval_in_notebook(notebook, tester) === true
			action.points_value
		else
			zero(action.points_value)
		end
	end
	
	function do_action(notebook::Pluto.Notebook, action::GetValue)
		eval_in_notebook(notebook, action.getter)
	end
end

# ╔═╡ 33e66768-e6d9-11ea-1aba-256b4c9998b8
autograde_results = map(notebooks) do nb
	map(actions) do action
		do_action(nb, action)
	end
end

# ╔═╡ 5ca8fb02-e6e3-11ea-0ad6-158746799400
autograde_results_df = DataFrame(map(autograde_results) do results
		(;
			map(zip(actions, results)) do (action, result)
				Symbol(displayname(action)) => result
			end...
		)
	end)

# ╔═╡ 7cb1c9bc-f684-11ea-00f3-dfd11c9b72ef
HTMLTable(autograde_results_df)

# ╔═╡ c9a66a4a-e6e4-11ea-0528-f3bbf6f17675
DownloadButton(sprint(CSV.write, autograde_results_df), "autograde_results.csv")

# ╔═╡ 991ddb18-e6e6-11ea-220d-71b6794f39d8
autograde_results_df[inspected_notebook_index, :]

# ╔═╡ 469a28fc-f856-11ea-2a6b-a706e607cf9f
manual_results_df = DataFrame(map(enumerate(collect(updated_manual_results_dict))) do (i,(filename, results))
		
		(;
			map(zip(manual, results)) do (action, result)
				Symbol(displayname(action)) => result
			end...,
			
			autograde_results_df[1,:]...,
		)
	end)

# ╔═╡ 459687e0-e6e3-11ea-0c85-89516c7a2da0
DownloadButton(sprint(CSV.write, manual_results_df), "manual_results.csv")

# ╔═╡ bbcd528e-e6e5-11ea-2d9c-a50835477b2e
md"## Not used"

# ╔═╡ 0796b462-f85c-11ea-1bf2-53ad24ec447c
struct GradedStudent
	name
	email
	grader
end

# ╔═╡ b6512e8e-f85b-11ea-0cb6-619a5b3f67bc
graders_raw = """
"""

# ╔═╡ c7553450-f85b-11ea-1dbd-3d72253a58d6
graders = map(split(graders_raw, '\n')) do line
	GradedStudent(split(line, '\t')...)
end

# ╔═╡ Cell order:
# ╠═65d601a6-fe45-11ea-22c6-270bf7d353bc
# ╠═122cbbdc-00cd-11eb-223b-ef82328f674f
# ╟─68da9dec-e6e1-11ea-1d9e-cdb7028f9b6a
# ╟─836cc4be-e6d7-11ea-2a6e-436c187304da
# ╟─4e4e78d2-f865-11ea-0c21-fdd76cbf3532
# ╠═427f19de-e6d2-11ea-10a8-5d3552224b31
# ╟─6b40e1d0-f865-11ea-3c2a-39fb643c8068
# ╟─728d1ca8-f865-11ea-1a3e-33cb0a44b9dd
# ╟─54c9b77c-e6e2-11ea-03ff-5d0d4a9dd763
# ╟─d0dd703a-e6da-11ea-1d4f-0b10bf75fad6
# ╟─a0776916-f865-11ea-387a-bf2e3094a182
# ╟─eaa49370-e6da-11ea-21d9-ddf11a7df51f
# ╠═490cc11a-00cb-11eb-24bc-2fb026c3094e
# ╠═c0d9fb36-f858-11ea-35c0-77963b5cf57a
# ╠═7cb1c9bc-f684-11ea-00f3-dfd11c9b72ef
# ╟─8c6c6114-e6d7-11ea-20b1-e718907e0767
# ╟─a1598cfc-e6d7-11ea-1f0b-f5560304fe7a
# ╠═b5d0d970-e6d9-11ea-20a5-01f0c4e3875c
# ╠═a6fe722e-e6da-11ea-21e8-1dea77b462ef
# ╠═9982bbfa-00c0-11eb-0a5c-818fae8c01ce
# ╠═5642a754-e6d9-11ea-35b6-0fe20d6a098e
# ╠═33e66768-e6d9-11ea-1aba-256b4c9998b8
# ╟─3f0aec92-e6e1-11ea-1b53-29b7b543674d
# ╟─5ca8fb02-e6e3-11ea-0ad6-158746799400
# ╟─c9a66a4a-e6e4-11ea-0528-f3bbf6f17675
# ╟─3fb6b20c-e6e1-11ea-35eb-e74598e31daf
# ╟─9090ee3e-e6de-11ea-14c3-27032e8710d3
# ╟─9c1c40f0-e6de-11ea-08d8-77acb2a550d4
# ╠═a3e47050-e6de-11ea-2a91-0597143f71ba
# ╟─657f23ce-f687-11ea-13c0-f9959437ddf5
# ╟─7b3bb8c8-f687-11ea-27bb-45ed5807090e
# ╟─144aa7ec-f864-11ea-35c4-43e19d898887
# ╟─8904534a-e6e1-11ea-34b7-31d1f6f8ca8f
# ╠═eade89f2-e6de-11ea-11bb-531a6b65c666
# ╟─9815b7f4-f686-11ea-0760-05b34811be7f
# ╠═991ddb18-e6e6-11ea-220d-71b6794f39d8
# ╟─b8d4598c-f686-11ea-24dc-6f94370fc996
# ╟─b6b986c8-e6de-11ea-1d13-5d9d370eccdc
# ╟─ca945d02-f686-11ea-03b4-393858220381
# ╟─dfbaecac-f855-11ea-1f3e-0522a86136ea
# ╟─e9b4c316-f852-11ea-3840-e7b1428df4e9
# ╟─22fd661e-e6e7-11ea-2b4a-8981b17a790d
# ╟─0ae5802c-f856-11ea-11ac-31a3ba67606c
# ╟─633ee8e4-f68a-11ea-271e-433eafd12a62
# ╟─469a28fc-f856-11ea-2a6b-a706e607cf9f
# ╟─459687e0-e6e3-11ea-0c85-89516c7a2da0
# ╟─06edecc6-f864-11ea-03b0-03db23d2c780
# ╟─f131ee3a-f68a-11ea-3d6c-d34439133a63
# ╟─1a999dfe-e6e1-11ea-12f4-ed24f03245e0
# ╟─64c26a50-e6df-11ea-2762-57186f445501
# ╟─8d1aaee8-e6de-11ea-2c2c-4d2ba138d5ce
# ╟─ce055a44-e6d8-11ea-3a07-75392c0f6c26
# ╠═c1f5bd3a-e6d2-11ea-20ab-d93e142aa71e
# ╠═9057dc04-e6d2-11ea-196b-1519cac7d248
# ╠═3abb56e4-e6d3-11ea-3337-392a434e1a21
# ╠═96917e4e-f687-11ea-2256-7b1057a3b523
# ╠═e5d3fa7c-f687-11ea-044f-6b00f0321da8
# ╠═31111cbe-e6d3-11ea-0130-a98e45b82f2b
# ╠═8b9a3f7a-e6d4-11ea-34c5-ef986e6af936
# ╟─e48f2a16-e6e1-11ea-070a-d58f87569b91
# ╠═33588e20-e6d4-11ea-08f6-7d10d9ef1481
# ╟─bbcd528e-e6e5-11ea-2d9c-a50835477b2e
# ╠═0796b462-f85c-11ea-1bf2-53ad24ec447c
# ╟─b6512e8e-f85b-11ea-0cb6-619a5b3f67bc
# ╠═c7553450-f85b-11ea-1dbd-3d72253a58d6
