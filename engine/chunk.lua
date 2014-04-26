Chunk = Entity()

function Chunk:Chunk(size)
	self.size = size or Vector(32, 32, 32)
	self.data = ffi.new("unsigned char[?]", self.size.x * self.size.y * self.size.z)

	self.vao = VertexArray()
	self.vvbo = VertexBuffer()
	self.nvbo = VertexBuffer()

	print(self.size)
end

function Chunk:set(x, y, z, value)
	if not z then
		x, y, z = x.x, x.y, x.z
	end

--	print(x, y, z)print(x + (y * self.size.x) + (z * self.size.x * self.size.y))
--	print(x + self.size.y * (y + self.size.x * z))
--	print(x + y * self.size.x + z * self.size.x * self.size.y)
	self.data[x + (y * self.size.x) + (z * self.size.x * self.size.y)] = value
end

function Chunk:get(x, y, z)
	if not z then
		x, y, z = x.x, x.y, x.z
	end

	if 	x > self.size.x - 1 or y > self.size.y - 1 or z > self.size.z - 1 or
		x < 0 or y < 0 or z < 0
	then
		return true
	end

	return self.data[x + self.size.x * (y + self.size.y * z)]
end

function Chunk:random()
	for x = 0, self.size.x -1 do
		for y = 0, self.size.y - 1 do
			for z = 0, self.size.z - 1 do
				self:set(x, y, z, math.floor(math.random()*2))
			end
		end
	end

	self:rebuild()
end

function Chunk:fill()
		for x = 0, self.size.x -1 do
		for y = 0, self.size.y - 1 do
			for z = 0, self.size.z - 1 do
				self:set(x, y, z, 1)
			end
		end
	end

	self:rebuild()
end

local vertbuffer = ffi.new("float[?]", 128*128*8*6*2*3*3)
local normalbuffer = ffi.new("float[?]", 128*128*8*6*2*3*3)
function Chunk:rebuild()
	self.count = 0

	for x = 0, self.size.x - 1 do
		for y = 0, self.size.y - 1 do
			for z = 0, self.size.z - 1 do
				if self:get(x, y, z) == 1 then
					self:buildVoxel(x, y, z)
				end
			end
		end
	end

	self.vao:bind()

	self.vvbo:bind()
	self.vvbo:data(vertbuffer, self.count * 3 * ffi.sizeof("float"))


	Attribute(0):enable()
	Attribute(0):pointer(3, 0, nil)

	self.nvbo:bind()
	self.nvbo:data(normalbuffer, self.count * 3 * ffi.sizeof("float"))

	Attribute(1):enable()
	Attribute(1):pointer(3, 0, nil)
end

function Chunk:draw(program)
	self.vao:bind()
	program:use()

	local modelmat = program:uniform("model")
	modelmat:matrix4fv(self:matrix())

	--print(vertbuffer[0], vertbuffer[1], vertbuffer[2])
	--print(vertbuffer[3], vertbuffer[4], vertbuffer[5])
	--print(vertbuffer[6], vertbuffer[7], vertbuffer[8])
	gl.DrawArrays(gl.GL_TRIANGLES, 0, self.count * 3 ) ;
end


-- THESE FUNCTIONS SHOULD ONLY BE CALLED WITHIN REBUILD.

function Chunk:buildVoxel(x, y, z)
	--print(self:get(x-1, y, z))
    if not (self:get(x - 1, y, z) == 1) then
    	self:addNormal(-1, 0, 0)

		self:addVertex(x, y, z)
		self:addVertex(x, y, z + 1)
		self:addVertex(x, y + 1, z)
		self:addVertex(x, y, z + 1)
		self:addVertex(x, y + 1, z + 1)
		self:addVertex(x, y + 1, z)
	end

	if not (self:get(x + 1, y, z) == 1) then
		self:addNormal(1, 0, 0)

		self:addVertex(x + 1, y + 1, z)
		self:addVertex(x + 1, y, z + 1)
		self:addVertex(x + 1, y, z)
		self:addVertex(x + 1, y + 1, z)
		self:addVertex(x + 1, y + 1, z + 1)
		self:addVertex(x + 1, y, z + 1)
	end

	if not (self:get(x, y - 1, z) == 1) then
		self:addNormal(0, -1, 0)

		self:addVertex(x, y, z)
		self:addVertex(x + 1, y, z)
		self:addVertex(x, y, z + 1)
		self:addVertex(x + 1, y, z)
		self:addVertex(x + 1, y, z + 1)
		self:addVertex(x, y, z + 1)
	end

	if not (self:get(x, y + 1, z) == 1) then
		self:addNormal(0, 1, 0)

		self:addVertex(x, y + 1, z + 1)
		self:addVertex(x + 1, y + 1, z)
		self:addVertex(x, y + 1, z)
		self:addVertex(x, y + 1, z + 1)
		self:addVertex(x + 1, y + 1, z + 1)
		self:addVertex(x + 1, y + 1, z)
	end

	if not (self:get(x, y, z - 1) == 1) then
		self:addNormal(0, 0, -1)

		self:addVertex(x, y, z)
		self:addVertex(x, y + 1, z)
		self:addVertex(x + 1, y, z)
		self:addVertex(x, y + 1, z)
		self:addVertex(x + 1, y + 1, z)
		self:addVertex(x + 1, y, z)
	end

	if not (self:get(x, y, z + 1) == 1) then
		self:addNormal(0, 0, 1)

		self:addVertex(x + 1, y, z + 1)
		self:addVertex(x, y + 1, z + 1)
		self:addVertex(x, y, z + 1)
		self:addVertex(x + 1, y, z + 1)
		self:addVertex(x + 1, y + 1, z + 1)
		self:addVertex(x, y + 1, z + 1)
	end
end

function Chunk:addVertex(x, y, z)
	vertbuffer[self.count * 3 ]  = x
	vertbuffer[self.count * 3 + 1] = y
	vertbuffer[self.count * 3 + 2] = z

	self.count = self.count + 1
end

function Chunk:addNormal(x, y, z)
	normalbuffer[self.count * 3] = x
	normalbuffer[self.count * 3 + 1] = y
	normalbuffer[self.count * 3 + 2] = z

	normalbuffer[self.count * 3 + 3] = x
	normalbuffer[self.count * 3 + 4] = y
	normalbuffer[self.count * 3 + 5] = z

	normalbuffer[self.count * 3 + 6] = x
	normalbuffer[self.count * 3 + 7] = y
	normalbuffer[self.count * 3 + 8] = z

	normalbuffer[self.count * 3 + 9] = x
	normalbuffer[self.count * 3 + 10] = y
	normalbuffer[self.count * 3 + 11] = z

	normalbuffer[self.count * 3 + 12] = x
	normalbuffer[self.count * 3 + 13] = y
	normalbuffer[self.count * 3 + 14] = z

	normalbuffer[self.count * 3 + 15] = x
	normalbuffer[self.count * 3 + 16] = y
	normalbuffer[self.count * 3 + 17] = z
end