-- Vanilla Luau vector implementation
-- Provides vector library on 3-wide mode if no existing implementation is available
-- Missing: vector functions other than vector.create
-- Last checked: 2025-11-23
local type = type
local typeof = typeof

local vector = vector
if not vector then
    local VectorObjectInternal = {}
    VectorObjectInternal.__type = "vector"
    VectorObjectInternal.__metatable = "This metatable is locked."

    VectorObjectInternal.__index = function(self, index)
        if index == "__type" then
            return VectorObjectInternal.__type
        end

        assert(false, `attempt to index vector with '{index}'`)
    end
    VectorObjectInternal.__newindex = function(self, index)
        assert(false, `attempt to index vector with '{index}'`)
    end
    VectorObjectInternal.__unm = function(self)
        return vector.create(-self.x, -self.y, -self.z)
    end
    VectorObjectInternal.__add = function(lhs, rhs)
        local rhs_x = typeof(rhs) == "number" and rhs or rhs.x
        local rhs_y = typeof(rhs) == "number" and rhs or rhs.y
        local rhs_z = typeof(rhs) == "number" and rhs or rhs.z

        return vector.create(lhs.x + rhs_x, lhs.y + rhs_y, lhs.z + rhs_z)
    end
    VectorObjectInternal.__sub = function(lhs, rhs)
        local rhs_x = typeof(rhs) == "number" and rhs or rhs.x
        local rhs_y = typeof(rhs) == "number" and rhs or rhs.y
        local rhs_z = typeof(rhs) == "number" and rhs or rhs.z

        return vector.create(lhs.x - rhs_x, lhs.y - rhs_y, lhs.z - rhs_z)
    end
    VectorObjectInternal.__mul = function(lhs, rhs)
        local rhs_x = typeof(rhs) == "number" and rhs or rhs.x
        local rhs_y = typeof(rhs) == "number" and rhs or rhs.y
        local rhs_z = typeof(rhs) == "number" and rhs or rhs.z

        return vector.create(lhs.x * rhs_x, lhs.y * rhs_y, lhs.z * rhs_z)
    end
    VectorObjectInternal.__div = function(lhs, rhs)
        local rhs_x = typeof(rhs) == "number" and rhs or rhs.x
        local rhs_y = typeof(rhs) == "number" and rhs or rhs.y
        local rhs_z = typeof(rhs) == "number" and rhs or rhs.z

        return vector.create(lhs.x / rhs_x, lhs.y / rhs_y, lhs.z / rhs_z)
    end
    VectorObjectInternal.__idiv = function(lhs, rhs)
        local rhs_x = typeof(rhs) == "number" and rhs or rhs.x
        local rhs_y = typeof(rhs) == "number" and rhs or rhs.y
        local rhs_z = typeof(rhs) == "number" and rhs or rhs.z

        return vector.create(lhs.x // rhs_x, lhs.y // rhs_y, lhs.z // rhs_z)
    end
    VectorObjectInternal.__concat = function(_lhs, rhs)
        assert(false, "attempt to concatenate vector with " .. typeof(rhs))
        return
    end
    VectorObjectInternal.__mod = function(_lhs, rhs)
        if (typeof(rhs) == "table") and (rhs["__type"] == "vector") then
            assert(false, "attempt to perform arithmetic (mod) on vector")
        end

        assert(false, "attempt to perform arithmetic (mod) on vector and " .. typeof(rhs))
    end
    VectorObjectInternal.__pow = function(_lhs, rhs)
        if (typeof(rhs) == "table") and (rhs["__type"] == "vector") then
            assert(false, "attempt to perform arithmetic (pow) on vector")
        end

        assert(false, "attempt to perform arithmetic (pow) on vector and "..typeof(rhs))
    end
    VectorObjectInternal.__tostring = function(self)
        return string.format("%f, %f, %f", self.x, self.y, self.z)
    end
    VectorObjectInternal.__eq = function(lhs, rhs)
        if (typeof(rhs) ~= "vector") then
            return false
        end

        return (lhs.x == rhs.x) and (lhs.y == rhs.y) and (lhs.z == rhs.z)
    end
    VectorObjectInternal.__lt = function(lhs, rhs)
        if (typeof(rhs) ~= "vector") then
            return false
        end

        return (lhs.x < rhs.x) and (lhs.y < rhs.y) and (lhs.z < rhs.z)
    end
    VectorObjectInternal.__le = function(lhs, rhs)
        if (typeof(rhs) ~= "vector") then
            return false
        end

        return (lhs.x <= rhs.x) and (lhs.y <= rhs.y) and (lhs.z <= rhs.z)
    end
    VectorObjectInternal.__len = function()
        assert(false, "attempt to get length of a vector value")
        return
    end
    VectorObjectInternal.__iter = function()
        assert(false, "attempt to iterate a vector value")
        return
    end

    vector = {}
    vector.create = function(x: number, y: number, z: number?)
        return setmetatable({x = x, y = y, z = z or 0}, VectorObjectInternal)
    end
    vector.zero = vector.create(0, 0, 0)
    vector.one = vector.create(1, 1, 1)

    local oldtype = type
    type = function(v)
        return if (oldtype(v) == "table") and v["__type"] then v["__type"] else oldtype(v)
    end

    local oldtypeof = typeof
    typeof = function(v)
        return if (oldtypeof(v) == "table") and v["__type"] then v["__type"] else oldtypeof(v)
    end
end
