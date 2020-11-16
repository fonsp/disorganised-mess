

struct Bond
    create_view::Function
    do_background_work::Function
end


@bind var b

# with b::Bond does this:

function bind(var::Symbol, b::Bond)

    # three channels are created:
    # a channel to set the value of the bound variable
    values = Channel(10)
    # channels to and from the webview
    to_webview = Channel(10)
    from_webview = Channel(10)


    worker_task = Task() do
        b.do_background_work(values, to_webview, from_webview)
    end
    push!(PlutoRunner.tasks_to_invalidate[in_which_cell_was_i_called()], worker_task)

    
    from_worker, to_worker = PlutoRunner.register_webview_channel(to_webview, from_webview)
    
    view = create_view(from_worker::String, to_worker::String)

    @async begin
        next_val = take!(values)
        PlutoRunner.set_reactive(var, next_val)
    end

    schedule(worker_task)
    
    return view
end







function in_which_cell_was_i_called()
    stack = stacktrace(backtrace())
    filenames = [frame.file for frame in stack]

    from_notebook = filter(f -> occursin("#==#"), filenames)

    return first(from_notebook)

    # zoiets
end








# EXAMPLES

##
# CLOCK WITHOUT FRONTEND
##

function clock(interval::Real)
    local i = 1
    do_background_work = (values, _x, _y) -> let
        while true
            put!(values, i)
            sleep(interval)
            i += 1
        end
    end

    create_view = (_a, _b) -> "hello i am a clock"

    return AbstractPlutoBond.Bond(create_view, do_background_work)
end


# usage

@bind x clock(0.5)

# will show

"hello i am a clock"

# and x will be assigned 1, 2, 3, etc in the background


##
# SAME THING, BUT WITH A STOP BUTTON IN THE FRONTEND
##

function clock_with_frontend(interval::Real)
    local i = 1
    local running = true
    do_background_work = (values, to_webview, from_webview) -> let
        @async begin
            _ = take!(from_webview)
            running = false
        end

        while running
            put!(values, i)
            sleep(interval)
            i += 1
        end
    end

    create_view = (from_worker, to_worker) -> HTML("""
    <script>
    const from_worker = $(from_worker)
    const to_worker = $(from_worker)

    const button = html`<button>STOP</button>`

    button.addEventListener("click", () => {
        to_worker.push("stop please")
    })

    return button
    </script>
    """)

    return AbstractPlutoBond.Bond(create_view, do_background_work)
end


# usage

@bind x clock_with_frontend(0.5)

# will show a button

# and x will be assigned 1, 2, 3, etc in the background, until you click the button


