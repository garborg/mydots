try
    using Revise
catch e
    @warn "Error initializing Revise" exception=(e, catch_backtrace())
end

atreplinit() do repl
    try
        @eval using OhMyREPL
    catch e
        @warn "Error initializing OhMyREPL" e
    end

    # If projects are subdirectories activate first one
    if contains(Base.active_project(), "/environments/v")
        for p in readdir()
            if isdir(p) && ispath(joinpath(p, "Project.toml"))
                @eval using Pkg; Pkg.activate(p)
                @info "Activated project in subdir '$p'"
            end
        end
    end
end
