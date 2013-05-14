Attribute = Object()

function Attribute:Attribute(location)
	self.id = location
end

function Attribute:pointer(components, stride, offset)
	local offsetfix = ffi.new("float*", nil)
	offsetfix = offsetfix + (offset or 0)
	gl.glVertexAttribPointer(self.id, components, gl.GL_FLOAT, gl.GL_FALSE, stride, offsetfix);
end

function Attribute:enable()
	gl.glEnableVertexAttribArray(self.id)
end