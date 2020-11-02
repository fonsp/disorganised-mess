# This file is a part of Julia. License is MIT: https://julialang.org/license

module PlutoSerialization

import Serialization

import Serialization: AbstractSerializer
import Serialization: serialize, serialize_any, serialize_array_data, serialize_cycle, serialize_cycle_header, serialize_dict_data, serialize_mod_names, serialize_type, serialize_type_data, serialize_typename
import Serialization: deserialize, deserialize_any, deserialize_array_data, deserialize_cycle, deserialize_cycle_header, deserialize_dict_data, deserialize_mod_names, deserialize_type, deserialize_type_data, deserialize_typename

import Base: unsafe_convert
import Core: svec, SimpleVector

mutable struct PlutoNotebookSerializer{I <: IO} <: AbstractSerializer
    io::I
    counter::Int
    table::IdDict{Any,Any}
    pending_refs::Vector{Int}
    known_object_data::Dict{UInt64,Any}
    PlutoNotebookSerializer{I}(io::I) where I <: IO = new(io, 0, IdDict(), Int[], Dict{UInt64,Any}())
end

PlutoNotebookSerializer(io::IO) = PlutoNotebookSerializer{typeof(io)}(io)

function serialize_mod_names(s::PlutoNotebookSerializer, m::Module)
    p = parentmodule(m)
    if p === m || m === Base
        key = Base.root_module_key(m)
        serialize(s, key.uuid === nothing ? nothing : key.uuid.value)
        serialize(s, Symbol(key.name))
    else
        serialize_mod_names(s, p)
        serialize(s, nameof(m))
    end
end

function serialize(s::PlutoNotebookSerializer, meth::Method)
    serialize_cycle(s, meth) && return
    writetag(s.io, METHOD_TAG)
    write(s.io, object_number(s, meth))
    serialize(s, meth.module)
    serialize(s, meth.name)
    serialize(s, meth.file)
    serialize(s, meth.line)
    serialize(s, meth.sig)
    serialize(s, meth.slot_syms)
    serialize(s, meth.nargs)
    serialize(s, meth.isva)
    if isdefined(meth, :source)
        serialize(s, Base._uncompressed_ast(meth, meth.source))
    else
        serialize(s, nothing)
    end
    if isdefined(meth, :generator)
        serialize(s, Base._uncompressed_ast(meth, meth.generator.inferred)) # XXX: what was this supposed to do?
    else
        serialize(s, nothing)
    end
    nothing
end

function serialize(s::PlutoNotebookSerializer, linfo::Core.MethodInstance)
    serialize_cycle(s, linfo) && return
    isa(linfo.def, Module) || error("can only serialize toplevel MethodInstance objects")
    writetag(s.io, METHODINSTANCE_TAG)
    serialize(s, linfo.uninferred)
    serialize(s, nothing)  # for backwards compat
    serialize(s, linfo.sparam_vals)
    serialize(s, Any)  # for backwards compat
    serialize(s, linfo.specTypes)
    serialize(s, linfo.def)
    nothing
end

function serialize(s::PlutoNotebookSerializer, g::GlobalRef)
    if (g.mod === __deserialized_types__ ) ||
        (g.mod === Main && isdefined(g.mod, g.name) && isconst(g.mod, g.name))

        v = getfield(g.mod, g.name)
        unw = unwrap_unionall(v)
        if isa(unw, DataType) && v === unw.name.wrapper && should_send_whole_type(s, unw)
            # handle references to types in Main by sending the whole type.
            # needed to be able to send nested functions (#15451).
            writetag(s.io, FULL_GLOBALREF_TAG)
            serialize(s, v)
            return
        end
    end
    writetag(s.io, GLOBALREF_TAG)
    serialize(s, g.mod)
    serialize(s, g.name)
end

function serialize(s::PlutoNotebookSerializer, t::Core.TypeName)
    serialize_cycle(s, t) && return
    writetag(s.io, TYPENAME_TAG)
    write(s.io, object_number(s, t))
    serialize_typename(s, t)
end

function serialize_typename(s::PlutoNotebookSerializer, t::Core.TypeName)
    serialize(s, t.name)
    serialize(s, t.names)
    primary = unwrap_unionall(t.wrapper)
    serialize(s, primary.super)
    serialize(s, primary.parameters)
    serialize(s, primary.types)
    serialize(s, isdefined(primary, :instance))
    serialize(s, primary.abstract)
    serialize(s, primary.mutable)
    serialize(s, primary.ninitialized)
    if isdefined(t, :mt) && t.mt !== Symbol.name.mt
        serialize(s, t.mt.name)
        serialize(s, collect(Base.MethodList(t.mt)))
        serialize(s, t.mt.max_args)
        if isdefined(t.mt, :kwsorter)
            serialize(s, t.mt.kwsorter)
        else
            writetag(s.io, UNDEFREF_TAG)
        end
    else
        writetag(s.io, UNDEFREF_TAG)
    end
    nothing
end

# decide whether to send all data for a type (instead of just its name)
function should_send_whole_type(s::PlutoNotebookSerializer, t::DataType)
    tn = t.name
    if isdefined(tn, :mt)
        # TODO improve somehow
        # send whole type for anonymous functions in Main
        name = tn.mt.name
        mod = tn.module
        isanonfunction = mod === Main && # only Main
            t.super === Function && # only Functions
            unsafe_load(unsafe_convert(Ptr{UInt8}, tn.name)) == UInt8('#') && # hidden type
            (!isdefined(mod, name) || t != typeof(getfield(mod, name))) # XXX: 95% accurate test for this being an inner function
            # TODO: more accurate test? (tn.name !== "#" name)
        # TODO: iskw = startswith(tn.name, "#kw#") && ???
        # TODO: iskw && return send-as-kwftype
        return mod === __deserialized_types__ || isanonfunction
    end
    return false
end

function serialize_type_data(s::PlutoNotebookSerializer, @nospecialize(t::DataType))
    whole = should_send_whole_type(s, t)
    iswrapper = (t === unwrap_unionall(t.name.wrapper))
    if whole && iswrapper
        writetag(s.io, WRAPPER_DATATYPE_TAG)
        serialize(s, t.name)
        return
    end
    serialize_cycle(s, t) && return
    if whole
        writetag(s.io, FULL_DATATYPE_TAG)
        serialize(s, t.name)
    else
        writetag(s.io, DATATYPE_TAG)
        tname = t.name.name
        serialize(s, tname)
        mod = t.name.module
        serialize(s, mod)
    end
    if !isempty(t.parameters)
        if iswrapper
            write(s.io, Int32(0))
        else
            write(s.io, Int32(length(t.parameters)))
            for p in t.parameters
                serialize(s, p)
            end
        end
    end
    nothing
end

function serialize(s::PlutoNotebookSerializer, t::DataType)
    tag = sertag(t)
    tag > 0 && return write_as_tag(s.io, tag)
    if t === Tuple
        # `sertag` is not able to find types === to `Tuple` because they
        # will not have been hash-consed. Plus `serialize_type_data` does not
        # handle this case correctly, since Tuple{} != Tuple. `Tuple` is the
        # only type with this property. issue #15849
        return write_as_tag(s.io, TUPLE_TAG)
    end
    serialize_type_data(s, t)
end

function serialize_type(s::PlutoNotebookSerializer, @nospecialize(t::DataType), ref::Bool=false)
    tag = sertag(t)
    tag > 0 && return writetag(s.io, tag)
    writetag(s.io, ref ? REF_OBJECT_TAG : OBJECT_TAG)
    serialize_type_data(s, t)
end

function serialize(s::PlutoNotebookSerializer, u::UnionAll)
    writetag(s.io, UNIONALL_TAG)
    n = 0; t = u
    while isa(t, UnionAll)
        t = t.body
        n += 1
    end
    if isa(t, DataType) && t === unwrap_unionall(t.name.wrapper)
        write(s.io, UInt8(1))
        write(s.io, Int16(n))
        serialize(s, t)
    else
        write(s.io, UInt8(0))
        serialize(s, u.var)
        serialize(s, u.body)
    end
end

function serialize_any(s::PlutoNotebookSerializer, @nospecialize(x))
    tag = sertag(x)
    if tag > 0
        return write_as_tag(s.io, tag)
    end
    t = typeof(x)::DataType
    nf = nfields(x)
    if nf == 0 && t.size > 0
        serialize_type(s, t)
        write(s.io, x)
    else
        if t.mutable
            serialize_cycle(s, x) && return
            serialize_type(s, t, true)
        else
            serialize_type(s, t, false)
        end
        for i in 1:nf
            if isdefined(x, i)
                serialize(s, getfield(x, i))
            else
                writetag(s.io, UNDEFREF_TAG)
            end
        end
    end
    nothing
end

function deserialize_module(s::PlutoNotebookSerializer)
    mkey = deserialize(s)
    if isa(mkey, Tuple)
        # old version, TODO: remove
        if mkey === ()
            return Main
        end
        m = Base.root_module(mkey[1])
        for i = 2:length(mkey)
            m = getfield(m, mkey[i])::Module
        end
    else
        name = String(deserialize(s)::Symbol)
        pkg = (mkey === nothing) ? Base.PkgId(name) : Base.PkgId(Base.UUID(mkey), name)
        m = Base.root_module(pkg)
        mname = deserialize(s)
        while mname !== ()
            m = getfield(m, mname)::Module
            mname = deserialize(s)
        end
    end
    return m
end

function deserialize(s::PlutoNotebookSerializer, ::Type{Method})
    lnumber = read(s.io, UInt64)
    meth = lookup_object_number(s, lnumber)
    if meth !== nothing
        meth = meth::Method
        makenew = false
    else
        meth = ccall(:jl_new_method_uninit, Ref{Method}, (Any,), Main)
        makenew = true
    end
    deserialize_cycle(s, meth)
    mod = deserialize(s)::Module
    name = deserialize(s)::Symbol
    file = deserialize(s)::Symbol
    line = deserialize(s)::Int32
    sig = deserialize(s)::Type
    syms = deserialize(s)
    if syms isa SimpleVector
        # < v1.2
        _ambig = deserialize(s)
    else
        slot_syms = syms::String
    end
    nargs = deserialize(s)::Int32
    isva = deserialize(s)::Bool
    template = deserialize(s)
    generator = deserialize(s)
    if makenew
        meth.module = mod
        meth.name = name
        meth.file = file
        meth.line = line
        meth.sig = sig
        meth.nargs = nargs
        meth.isva = isva
        if template !== nothing
            # TODO: compress template
            meth.source = template::CodeInfo
            meth.pure = template.pure
            if !@isdefined(slot_syms)
                slot_syms = ccall(:jl_compress_argnames, Ref{String}, (Any,), meth.source.slotnames)
            end
        end
        meth.slot_syms = slot_syms
        if generator !== nothing
            linfo = ccall(:jl_new_method_instance_uninit, Ref{Core.MethodInstance}, ())
            linfo.specTypes = Tuple
            linfo.inferred = generator
            linfo.def = meth
            meth.generator = linfo
        end
        mt = ccall(:jl_method_table_for, Any, (Any,), sig)
        if mt !== nothing && nothing === ccall(:jl_methtable_lookup, Any, (Any, Any, UInt), mt, sig, typemax(UInt))
            ccall(:jl_method_table_insert, Cvoid, (Any, Any, Ptr{Cvoid}), mt, meth, C_NULL)
        end
        remember_object(s, meth, lnumber)
    end
    return meth
end

function deserialize(s::PlutoNotebookSerializer, ::Type{Core.MethodInstance})
    linfo = ccall(:jl_new_method_instance_uninit, Ref{Core.MethodInstance}, (Ptr{Cvoid},), C_NULL)
    deserialize_cycle(s, linfo)
    linfo.uninferred = deserialize(s)::CodeInfo
    tag = Int32(read(s.io, UInt8)::UInt8)
    if tag != UNDEFREF_TAG
        # for reading files prior to v1.2
        handle_deserialize(s, tag)
    end
    linfo.sparam_vals = deserialize(s)::SimpleVector
    _rettype = deserialize(s)  # for backwards compat
    linfo.specTypes = deserialize(s)
    linfo.def = deserialize(s)::Module
    return linfo
end

module __deserialized_types__ end

function deserialize(s::PlutoNotebookSerializer, ::Type{Core.TypeName})
    number = read(s.io, UInt64)
    return deserialize_typename(s, number)
end

function deserialize_typename(s::PlutoNotebookSerializer, number)
    name = deserialize(s)::Symbol
    tn = lookup_object_number(s, number)
    if tn !== nothing
        makenew = false
    else
        # reuse the same name for the type, if possible, for nicer debugging
        tn_name = isdefined(__deserialized_types__, name) ? gensym() : name
        tn = ccall(:jl_new_typename_in, Ref{Core.TypeName}, (Any, Any),
                   tn_name, __deserialized_types__)
        makenew = true
    end
    remember_object(s, tn, number)
    deserialize_cycle(s, tn)

    names = deserialize(s)::SimpleVector
    super = deserialize(s)::Type
    parameters = deserialize(s)::SimpleVector
    types = deserialize(s)::SimpleVector
    has_instance = deserialize(s)::Bool
    abstr = deserialize(s)::Bool
    mutabl = deserialize(s)::Bool
    ninitialized = deserialize(s)::Int32

    if makenew
        tn.names = names
        # TODO: there's an unhanded cycle in the dependency graph at this point:
        # while deserializing super and/or types, we may have encountered
        # tn.wrapper and throw UndefRefException before we get to this point
        ndt = ccall(:jl_new_datatype, Any, (Any, Any, Any, Any, Any, Any, Cint, Cint, Cint),
                    tn, tn.module, super, parameters, names, types,
                    abstr, mutabl, ninitialized)
        tn.wrapper = ndt.name.wrapper
        ccall(:jl_set_const, Cvoid, (Any, Any, Any), tn.module, tn.name, tn.wrapper)
        ty = tn.wrapper
        if has_instance && !isdefined(ty, :instance)
            # use setfield! directly to avoid `fieldtype` lowering expecting to see a Singleton object already on ty
            Core.setfield!(ty, :instance, ccall(:jl_new_struct, Any, (Any, Any...), ty))
        end
    end

    tag = Int32(read(s.io, UInt8)::UInt8)
    if tag != UNDEFREF_TAG
        mtname = handle_deserialize(s, tag)
        defs = deserialize(s)
        maxa = deserialize(s)::Int
        if makenew
            tn.mt = ccall(:jl_new_method_table, Any, (Any, Any), name, tn.module)
            if !isempty(parameters)
                tn.mt.offs = 0
            end
            tn.mt.name = mtname
            tn.mt.max_args = maxa
            for def in defs
                if isdefined(def, :sig)
                    ccall(:jl_method_table_insert, Cvoid, (Any, Any, Ptr{Cvoid}), tn.mt, def, C_NULL)
                end
            end
        end
        tag = Int32(read(s.io, UInt8)::UInt8)
        if tag != UNDEFREF_TAG
            kws = handle_deserialize(s, tag)
            if makenew
                tn.mt.kwsorter = kws
            end
        end
    end
    return tn::Core.TypeName
end

function deserialize_datatype(s::PlutoNotebookSerializer, full::Bool)
    slot = s.counter; s.counter += 1
    if full
        tname = deserialize(s)::Core.TypeName
        ty = tname.wrapper
    else
        name = deserialize(s)::Symbol
        mod = deserialize(s)::Module
        ty = getfield(mod, name)
    end
    if isa(ty, DataType) && isempty(ty.parameters)
        t = ty
    else
        np = Int(read(s.io, Int32)::Int32)
        if np == 0
            t = unwrap_unionall(ty)
        elseif ty === Tuple
            # note np==0 has its own tag
            if np == 1
                t = Tuple{deserialize(s)}
            elseif np == 2
                t = Tuple{deserialize(s),deserialize(s)}
            elseif np == 3
                t = Tuple{deserialize(s),deserialize(s),deserialize(s)}
            elseif np == 4
                t = Tuple{deserialize(s),deserialize(s),deserialize(s),deserialize(s)}
            else
                t = Tuple{Any[ deserialize(s) for i = 1:np ]...}
            end
        else
            t = ty
            for i = 1:np
                t = t{deserialize(s)}
            end
        end
    end
    s.table[slot] = t
    return t
end

# default DataType deserializer
function deserialize(s::PlutoNotebookSerializer, t::DataType)
    nf = length(t.types)
    if nf == 0 && t.size > 0
        # bits type
        return read(s.io, t)
    elseif t.mutable
        x = ccall(:jl_new_struct_uninit, Any, (Any,), t)
        deserialize_cycle(s, x)
        for i in 1:nf
            tag = Int32(read(s.io, UInt8)::UInt8)
            if tag != UNDEFREF_TAG
                ccall(:jl_set_nth_field, Cvoid, (Any, Csize_t, Any), x, i - 1, handle_deserialize(s, tag))
            end
        end
        return x
    elseif nf == 0
        return ccall(:jl_new_struct_uninit, Any, (Any,), t)
    else
        na = nf
        vflds = Vector{Any}(undef, nf)
        for i in 1:nf
            tag = Int32(read(s.io, UInt8)::UInt8)
            if tag != UNDEFREF_TAG
                f = handle_deserialize(s, tag)
                na >= i && (vflds[i] = f)
            else
                na >= i && (na = i - 1) # rest of tail must be undefined values
            end
        end
        return ccall(:jl_new_structv, Any, (Any, Ptr{Any}, UInt32), t, vflds, na)
    end
end

end
