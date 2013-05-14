Entity = Object()

Entity.pos = Vector:new(0, 0, 0)
Entity.rot = Quaternion:new(0, 0, 0, 1)

function Entity:Entity()
	self.pos = Vector()
	self.rot = Quaternion()
end

function Entity:move(x, y, z)
	if type(x) ~= "table" then
		self.pos.x = self.pos.x + x
		self.pos.y = self.pos.y + y
		self.pos.z = self.pos.z + z
	else
		self.pos = self.pos + x
	end
end

function Entity:position(x, y, z)
	if z then
		self.pos.x = x
		self.pos.y = y
		self.pos.z = z
	elseif x then
		self.pos = x
	else
		return self.pos
	end
end

function Entity:rotation(quat)
	if quat == nil then
		return self.rot
	end

	self.rot = quat
	self.rot:normalize()
end

function Entity:moveForward(x, y, z)
	local vec
	if type(x) == "table" then
		vec = x
	else
		vec = Vector:new(x, y, z)
	end
	self.pos = self.pos + self.rot:conjugate():rotate(vec)
end

function Entity:draw()
end

function Entity:matrix()
	return self:rotation():matrix(self:position())
end

function Entity:cameramatrix()
	transform = util.transformationmatrix(self:position())
	rotation = self:rotation():matrix()
	return util.multiplymatrix(transform, rotation)
end