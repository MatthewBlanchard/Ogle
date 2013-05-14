VertexArrayObject = Object()

function VertexArrayObject:VertexArrayObject()
	self.id = ffi.new("GLuint[1]")
	gl.glGenVertexArrays(1, self.id)
	self.id = self.id[0]
end

function VertexArrayObject:bind()
	gl.glBindVertexArray(self.id)
end