ElementBuffer = Object()

function ElementBuffer:ElementBuffer()
	print "Yer"
	self.id = ffi.new("GLuint[1]")
	gl.GenBuffers(1, self.id)
	self.id = self.id[0]
end

function ElementBuffer:bind()
	gl.BindBuffer(gl.GL_ELEMENT_ARRAY_BUFFER, self.id)
end

function ElementBuffer:data(data)
	if type(data) == "table" then
		local data = ffi.new("GLuint[" .. #data .. "]", data)
	end

	print(data)
	gl.BufferData(gl.GL_ELEMENT_ARRAY_BUFFER, ffi.sizeof(data), data, gl.GL_STATIC_DRAW)
end