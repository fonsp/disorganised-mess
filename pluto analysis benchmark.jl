import Pluto
import Pluto: Configuration, Notebook, ServerSession, ClientSession, update_run!, Cell, WorkspaceManager, NotebookTopology, update_caches!, ExpressionExplorer, ReactiveNode, topological_order, updated_topology
import Pluto.Configuration: Options, EvaluationOptions
using BenchmarkTools


s = ServerSession();

fakeclient = ClientSession(:fake, nothing);
s.connected_clients[fakeclient.id] = fakeclient;

filename = download("https://raw.githubusercontent.com/fonsp/disorganised-mess/eaaf8b9198a52571013e140688fe455cb35320b1/big.jl")
nb = Pluto.load_notebook_nobackup(filename);

parse_and_lint() = let
    foreach(nb.cells) do cell
        cell.parsedcode = nothing
    end
    Pluto.update_caches!(nb, nb.cells)
end;

@benchmark parse_and_lint()

#= 

🧧 https://github.com/fonsp/Pluto.jl/commit/5c4fcb4ae16305fe0dc1fb3df7c5368f3b0fb115

BenchmarkTools.Trial: 
  memory estimate:  4.67 MiB
  allocs estimate:  68975
  --------------
  minimum time:     60.605 ms (0.00% GC)
  median time:      66.190 ms (0.00% GC)
  mean time:        67.423 ms (1.03% GC)
  maximum time:     80.370 ms (0.00% GC)
  --------------
  samples:          75
  evals/sample:     1

👜 https://github.com/fonsp/Pluto.jl/pull/538/commits/496d5b5c2f5dcdee348a6a9ad1972e1585151325

BenchmarkTools.Trial: 
  memory estimate:  4.69 MiB
  allocs estimate:  69335
  --------------
  minimum time:     59.811 ms (0.00% GC)
  median time:      62.654 ms (0.00% GC)
  mean time:        63.965 ms (1.22% GC)
  maximum time:     75.587 ms (10.12% GC)
  --------------
  samples:          79
  evals/sample:     1

x =#

explore_expressions() = let 
    foreach(nb.cells) do cell
        cell.parsedcode |>
            Pluto.ExpressionExplorer.try_compute_symbolreferences
    end
end;


Pluto.update_caches!(nb, nb.cells);

@benchmark explore_expressions()

#= 

🧧 https://github.com/fonsp/Pluto.jl/commit/5c4fcb4ae16305fe0dc1fb3df7c5368f3b0fb115

BenchmarkTools.Trial: 
  memory estimate:  16.99 MiB
  allocs estimate:  250448
  --------------
  minimum time:     82.046 ms (0.00% GC)
  median time:      91.009 ms (0.00% GC)
  mean time:        92.326 ms (2.55% GC)
  maximum time:     121.048 ms (0.00% GC)
  --------------
  samples:          55
  evals/sample:     1

👜 https://github.com/fonsp/Pluto.jl/pull/538/commits/496d5b5c2f5dcdee348a6a9ad1972e1585151325

BenchmarkTools.Trial: 
  memory estimate:  15.66 MiB
  allocs estimate:  243205
  --------------
  minimum time:     80.059 ms (0.00% GC)
  median time:      86.211 ms (0.00% GC)
  mean time:        87.509 ms (2.66% GC)
  maximum time:     106.478 ms (6.42% GC)
  --------------
  samples:          58
  evals/sample:     1 
  
x =#

const symstates = map(nb.cells) do cell
    cell.parsedcode |>
        Pluto.ExpressionExplorer.try_compute_symbolreferences
end;

get_those_nodes() = let 
    foreach(Pluto.ReactiveNode, symstates)
end;

@benchmark get_those_nodes()

#= 

🧧 https://github.com/fonsp/Pluto.jl/commit/5c4fcb4ae16305fe0dc1fb3df7c5368f3b0fb115



👜 https://github.com/fonsp/Pluto.jl/pull/538/commits/496d5b5c2f5dcdee348a6a9ad1972e1585151325

BenchmarkTools.Trial: 
  memory estimate:  690.30 KiB
  allocs estimate:  11543
  --------------
  minimum time:     3.198 ms (0.00% GC)
  median time:      3.446 ms (0.00% GC)
  mean time:        3.792 ms (3.17% GC)
  maximum time:     13.506 ms (62.87% GC)
  --------------
  samples:          1320
  evals/sample:     1

x =#

old = NotebookTopology();
new = updated_topology(old, nb, nb.cells);

compute_topo_order() = let 
    topological_order(nb, old, nb.cells)
end;

@benchmark compute_topo_order()

#= 

🧧 https://github.com/fonsp/Pluto.jl/commit/5c4fcb4ae16305fe0dc1fb3df7c5368f3b0fb115

BenchmarkTools.Trial: 
  memory estimate:  155.48 MiB
  allocs estimate:  1489294
  --------------
  minimum time:     520.097 ms (4.54% GC)
  median time:      537.135 ms (4.03% GC)
  mean time:        543.193 ms (3.88% GC)
  maximum time:     573.618 ms (3.18% GC)
  --------------
  samples:          10
  evals/sample:     1

👜 https://github.com/fonsp/Pluto.jl/pull/538/commits/496d5b5c2f5dcdee348a6a9ad1972e1585151325

BenchmarkTools.Trial: 
  memory estimate:  416.63 KiB
  allocs estimate:  1904
  --------------
  minimum time:     4.282 ms (0.00% GC)
  median time:      4.648 ms (0.00% GC)
  mean time:        4.895 ms (0.94% GC)
  maximum time:     11.165 ms (52.19% GC)
  --------------
  samples:          1022
  evals/sample:     1

x =#

old = NotebookTopology();
new = updated_topology(old, nb, nb.cells);

const cell_i = Ref(1)
compute_topo_order_single() = let
    i = mod1(cell_i[], length(nb.cells))
    topological_order(nb, old, nb.cells[i:i])
    cell_i[] += 1
end;

@benchmark compute_topo_order_single() seconds = 8

#= 

🧧 https://github.com/fonsp/Pluto.jl/commit/5c4fcb4ae16305fe0dc1fb3df7c5368f3b0fb115

BenchmarkTools.Trial: 
  memory estimate:  1.24 MiB
  allocs estimate:  11911
  --------------
  minimum time:     3.712 ms (0.00% GC)
  median time:      3.936 ms (0.00% GC)
  mean time:        4.403 ms (3.87% GC)
  maximum time:     14.936 ms (48.65% GC)
  --------------
  samples:          1817
  evals/sample:     1

👜 https://github.com/fonsp/Pluto.jl/pull/538/commits/496d5b5c2f5dcdee348a6a9ad1972e1585151325


BenchmarkTools.Trial: 
  memory estimate:  6.61 KiB
  allocs estimate:  59
  --------------
  minimum time:     46.457 μs (0.00% GC)
  median time:      51.919 μs (0.00% GC)
  mean time:        58.352 μs (1.42% GC)
  maximum time:     8.540 ms (97.31% GC)
  --------------
  samples:          10000
  evals/sample:     1

x =#