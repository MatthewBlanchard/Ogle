ElementBufferObject = Object()

function ElementBufferObject:ElementBufferObject()
	self.id = ffi.new("GLuint[1]")
	gl.glGenBuffers(1, self.id)
	self.id = self.id[0]
end

function ElementBufferObject:bind()
	gl.glBindBuffer(gl.GL_ELEMENT_ARRAY_BUFFER, self.id)
end

function ElementBufferObject:data(data)
	local tempv = ffi.new("GLuint[" .. #data .. "]", data)
	
	for i = 1, #data do
		tempv[i-1] = data[i]
	end

	gl.glBufferData(gl.GL_ELEMENT_ARRAY_BUFFER, ffi.sizeof(tempv), tempv, gl.GL_STATIC_DRAW)
end