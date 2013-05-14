local sqrt = math.sqrt

Vector = Object()

function Vector:Vector(x, y, z)
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
end

Vector.up = Vector(0, 1, 0)
Vector.side = Vector(1, 0, 0)
Vector.forward = Vector(0, 0, 1)

function Vector:__add(vec)
	return Vector:new(self.x + vec.x, self.y + vec.y, self.z + vec.z)
end

function Vector:__sub(vec)
	return Vector:new(self.x - vec.x, self.y - vec.y, self.z - vec.z)
end

function Vector:__mul(scalar)
	return Vector:new(self.x*scalar, self.y*scalar, self.z*scalar)
end

function Vector:__tostring()
	return self.x .. "\t" .. self.y .. "\t" .. self.z
end

function Vector:normal()
	local mag = sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
	return Vector:new(self.x/mag, self.y/mag, self.z/mag), mag
end

function Vector:inlinenormal()
	local mag = sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
	return self.x/mag, self.y/mag, self.z/mag, mag
end

function Vector:cross(vec)
	return Vector:new( 	self.y * vec.z - vec.y * self.z,
						self.z * vec.x - vec.z * self.x,
						self.x * vec.y - vec.x * self.y
					)
end

function Vector:dot(vec)
	return self.x*vec.x+self.y*vec.y+self.z*vec.z
end

function Vector:transform(vec)
	local x = self.x + vec.x
	local y = self.y + vec.y
	local z = self.z + vec.z
	return Vector:new(x, y, z)
end