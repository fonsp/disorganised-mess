
import Serialization

module AAA

struct Wow
    a
    b
end
end

Wow = AAA.Wow

w = Wow(6, Wow(7, 8))

s(x) = sprint(Serialization.serialize, x)

Serialization.should_send_whole_type(s::Serialization.Serializer, t::DataType) = true

g = x -> x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + x + xvaaaaaaaaaaaaaaaaaaaaa

s(g)


f = "/tmp/a"

s(w)

s(AAA)

Serialization.serialize(f, w)

Serialization.deserialize(f)