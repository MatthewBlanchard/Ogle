Mesh = Entity()

function Mesh:Mesh(vertdata, indices)
	self.vao = VertexArrayObject()
	self.vao:bind()

	self.vbo = VertexBufferObject()
	self.vbo:bind()
	self.vbo:data(vertdata)

	self.ebo = ElementBufferObject()
	self.ebo:bind()
	self.ebo:data(indices)

	-- Set pointer for position parameter.`
	Attribute(0):enable()
	Attribute(0):pointer(3, 0, nil)

	Attribute(1):enable()
	Attribute(1):pointer(3, 0, ffi.sizeof(vertdata)/4/2)

	self.count = ffi.sizeof(vertdata)/2
end

function  Mesh:draw(program)
	self.vao:bind()
	program:use()

	local modelmat = program:uniform("model")
	modelmat:matrix4fv(self:matrix())

	gl.glDrawElements(gl.GL_TRIANGLES, self.count * 3, gl.GL_UNSIGNED_INT, nil);
end

function Mesh.preprocessOBJ(file)
	local verts, faces = Mesh.parseOBJ(file)

	verts = ffi.string(verts, ffi.sizeof(verts))
	faces = ffi.string(faces, ffi.sizeof(faces))

	local header = ffi.new("int[2]")
	header[0] = string.len(verts)
	header[1] = string.len(faces)
	local header = ffi.string(header, ffi.sizeof(header))

	util.writefile("processed.pobj", header .. verts .. faces)
end

function Mesh.preprocessedOBJ(file)
	local str = util.loadfile(file)

	local header = ffi.new("int[2]")
	ffi.copy(header, str, 8)

	local verts = ffi.new("float[?]", header[0]/4)
	ffi.copy(verts, string.sub(str, 9, header[0]))
	print(ffi.sizeof(verts), string.len(string.sub(str, 9, header[0])))

	local faces = ffi.new("unsigned int[?]", header[1])
	ffi.copy(faces, string.sub(str, header[0]+9), header[1])
	--print(string.len(string.sub(str, header[0]+9)), header[1])


	return Mesh:new(verts, faces)
end

function Mesh.OBJ(file)
	local verts, faces, normals = Mesh.parseOBJ(file)
	--Mesh.preprocessOBJ(file)
    return Mesh:new(verts, faces, normals)
end

function Mesh.parseOBJ(file)
	local verts, faces, normals = {}, {}, {}
	local vertnt, vertf, normalf = {}, {}, {}
	local fc = 0

	local str = util.loadfile(file)

	-- Find vertices
	for x, y, z in string.gfind(str, "v%s+(-?%d+.%d+)%s+(-?%d+.%d+)%s+(-?%d+.%d+)") do
     	table.insert(verts, tonumber(x))
		table.insert(verts, tonumber(y))
		table.insert(verts, tonumber(z))
    end

    for x, y, z in string.gfind(str, "vn%s+(-?%d+.%d+)%s+(-?%d+.%d+)%s+(-?%d+.%d+)") do
     	table.insert(normals, tonumber(x))
		table.insert(normals, tonumber(y))
	 	table.insert(normals, tonumber(z))
    end

    -- Find faces
	for v1, v2, v3 in string.gfind(str, "f%s+(%A-)%s+(%A-)%s+(%A-)%s+") do
		local face = {v1, v2, v3}
		for k, v in pairs(face) do
			for v, vt, vn in string.gfind(v, "(%d*)%p(%d*)%p(%d*)") do
				local v, vt, vn = tonumber(v), tonumber(vt), tonumber(vn)
				if not vertnt[v] then vertnt[v] = {} end
				if not vertnt[v][vn] then
					vertnt[v][vn] = fc

					table.insert(vertf, verts[(v-1)*3+1])
					table.insert(vertf, verts[(v-1)*3+2])
					table.insert(vertf, verts[(v-1)*3+3])

					table.insert(normalf, normals[(vn-1)*3+1])
					table.insert(normalf, normals[(vn-1)*3+2])
					table.insert(normalf, normals[(vn-1)*3+3])

					table.insert(faces, fc)
					fc = fc + 1
				else
					table.insert(faces, vertnt[v][vn])
				end
			end
		end
    end

    for k, v in pairs(normalf) do
    	table.insert(vertf, v)
    end

    local vertf = ffi.new("float[" .. #vertf .. "]", vertf)
    local facesf = ffi.new("unsigned int[" .. #faces .. "]", faces)

	str = nil
    return vertf, facesf, normalf
end