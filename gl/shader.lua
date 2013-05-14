Shader = Object()

function Shader:Shader(stype, source)
	self.id = gl.glCreateShader(stype)

	if source then
		self:source(source)
		self:compile()
	end
end

function Shader:source(source)
	temp = ffi.new("char[?]", #source)
	ffi.copy(temp, source)

	src = ffi.new("const char*[1]")
	src[0] = temp

	gl.glShaderSource(self.id, 1, src, nil)
end

function Shader:compile()
	gl.glCompileShader(self.id)

	status = ffi.new("GLint[1]")
	gl.glGetShaderiv( self.id, gl.GL_COMPILE_STATUS, status)
	if status[0] ~= gl.GL_TRUE then
		log = ffi.new("char[1024]")
		len = ffi.new("unsigned int[1]")

		gl.glGetShaderInfoLog(self.id, 1024, len, log)
		print(ffi.string(log))
	end
end