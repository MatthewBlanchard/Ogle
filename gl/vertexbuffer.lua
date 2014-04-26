VertexBuffer = Object()

function VertexBuffer:VertexBuffer()
	self.id = ffi.new("GLuint[1]")
	gl.GenBuffers(1, self.id)
	self.id = self.id[0]
end

function VertexBuffer:bind()
	gl.BindBuffer(gl.GL_ARRAY_BUFFER, self.id)
end

function VertexBuffer:data(data, size, drawtype)
	if type(data) == "table" then
		local data = ffi.new("float[" .. #data .. "]", data)
	end

	size = size or ffi.sizeof(data)
	drawtype = drawtype or gl.GL_STATIC_DRAW

	gl.BufferData(gl.GL_ARRAY_BUFFER, size, data, gl.GL_STATIC_DRAW)
end