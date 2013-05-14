Mesh = Entity()

function Mesh:Mesh(verts, faces, normals)
	self.vao = VertexArrayObject()
	self.vao:bind()

	if normals then
		normoff = #verts
		for k,v in pairs(normals) do
			table.insert(verts, v)
		end
	end

	self.vbo = VertexBufferObject()
	self.vbo:bind()
	self.vbo:data(verts)

	self.ebo = ElementBufferObject()
	self.ebo:bind()
	self.ebo:data(faces)

	-- Set pointer for position parameter.`
	Attribute(0):enable()
	Attribute(0):pointer(3, 0, nil)

	if normals then
		Attribute(1):enable()
		Attribute(1):pointer(3, 0, normoff)
	end

	self.count = #verts
end

function  Mesh:draw(program)
	self.vao:bind()
	program:use()

	local modelmat = program:uniform("model")
	modelmat:matrix4fv(self:matrix())

	gl.glDrawElements(gl.GL_TRIANGLES, self.count * 3, gl.GL_UNSIGNED_INT, nil);
end

function Mesh.OBJ(file, color)
	local verts, faces, normals = {}, {}, {}
	local vertnt, vertf, normalf = {}, {}, {}
	local fc = 0

	str = util.loadfile(file)

	-- Find vertices
	for x, y, z in string.gfind(str, "v%s+(-?%d+.%d+)%s+(-?%d+.%d+)%s+(-?%d+.%d+)") do
		x, y, z = tonumber(x), tonumber(y), tonumber(z)
     	table.insert(verts, Vector(x, y, z))
    end

    for x, y, z in string.gfind(str, "vn%s+(-?%d+.%d+)%s+(-?%d+.%d+)%s+(-?%d+.%d+)") do
    	x, y, z = tonumber(x), tonumber(y), tonumber(z)
     	table.insert(normals, Vector(x, y, z))
    end

    -- Find faces
	for v1, v2, v3 in string.gfind(str, "f%s+(%A-)%s+(%A-)%s+(%A-)%s+") do
		if tonumber(v1) then
			table.insert(faces,  tonumber(v1)-1)
       		table.insert(faces,  tonumber(v2)-1)
     		table.insert(faces,  tonumber(v3)-1)
     		
     		for k,v in pairs(verts) do
     			table.insert(vertf, v.x)
     			table.insert(vertf, v.y)
     			table.insert(vertf, v.z)
     		end
		else
			local face = {v1, v2, v3}
			for k, v in pairs(face) do
				for v, vt, vn in string.gfind(v, "(%d*)%p(%d*)%p(%d*)") do
					v, vt, vn = tonumber(v), tonumber(vt), tonumber(vn)
					if not vertnt[v] then vertnt[v] = {} end
					if not vertnt[v][vn] then
						vertnt[v][vn] = fc

						table.insert(vertf, verts[v].x)
						table.insert(vertf, verts[v].y)
						table.insert(vertf, verts[v].z)

						table.insert(normalf, normals[vn].x)
						table.insert(normalf, normals[vn].y)
						table.insert(normalf, normals[vn].z)

						table.insert(faces, fc)
						fc = fc + 1
					else
						table.insert(faces, vertnt[v][vn])
					end
				end
			end
		end
    end

    return Mesh:new(vertf, faces, normalf)
end