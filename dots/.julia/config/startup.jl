atreplinit() do repl
    try
        @eval using Revise
        @async Revise.wait_steal_repl_backend()
    catch e
        @warn(e.msg)
    end
    try
        @eval using OhMyREPL
    catch e
        @warn(e.msg)
    end
end
