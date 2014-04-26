VertexArray = Object()

function VertexArray:VertexArray()
	self.id = ffi.new("GLuint[1]")
	gl.GenVertexArrays(1, self.id)
	self.id = self.id[0]
end

function VertexArray:bind()
	gl.BindVertexArray(self.id)
end