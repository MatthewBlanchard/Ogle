Uniform = Object()

function Uniform:Uniform(location)
	self.id = location
end

local matbuffer = ffi.new("float[16]")
function Uniform:matrix4fv(matrix)
	for k,v in pairs(matrix) do
		matbuffer[k-1] = v
	end
	gl.UniformMatrix4fv( self.id, 1, gl.GL_FALSE, matbuffer )
end

function Uniform:enable()
	gl.EnableVertexAttribArray(self.id)
end