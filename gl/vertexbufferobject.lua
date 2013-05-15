VertexBufferObject = Object()

function VertexBufferObject:VertexBufferObject()
	self.id = ffi.new("GLuint[1]")
	gl.glGenBuffers(1, self.id)
	self.id = self.id[0]
end

function VertexBufferObject:bind()
	gl.glBindBuffer(gl.GL_ARRAY_BUFFER, self.id)
end

function VertexBufferObject:data(data)
	if type(data) == "table" then
		data = ffi.new("float[" .. #data .. "]", data)
	end

	gl.glBufferData(gl.GL_ARRAY_BUFFER, ffi.sizeof(data), data, gl.GL_STATIC_DRAW)
end