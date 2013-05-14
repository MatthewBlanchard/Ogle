Uniform = Object()

function Uniform:Uniform(location)
	self.id = location
end

function Uniform:matrix4fv(matrix)
	gl.glUniformMatrix4fv( self.id, 1, gl.GL_FALSE, ffi.new("float[16]", matrix))
end

function Uniform:enable()
	gl.glEnableVertexAttribArray(self.id)
end