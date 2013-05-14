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
	local tempv = ffi.new("float[" .. #data .. "]", data)

	gl.glBufferData(gl.GL_ARRAY_BUFFER, ffi.sizeof(tempv), tempv, gl.GL_STATIC_DRAW)
end