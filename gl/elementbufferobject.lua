ElementBufferObject = Object()

function ElementBufferObject:ElementBufferObject()
	print "Yer"
	self.id = ffi.new("GLuint[1]")
	gl.glGenBuffers(1, self.id)
	self.id = self.id[0]
end

function ElementBufferObject:bind()
	gl.glBindBuffer(gl.GL_ELEMENT_ARRAY_BUFFER, self.id)
end

function ElementBufferObject:data(data)
	if type(data) == "table" then
		data = ffi.new("GLuint[" .. #data .. "]", data)
	end

	print(data)
	gl.glBufferData(gl.GL_ELEMENT_ARRAY_BUFFER, ffi.sizeof(data), data, gl.GL_STATIC_DRAW)
end