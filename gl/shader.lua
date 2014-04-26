Shader = Object()

function Shader:Shader(stype, source)
	self.id = gl.CreateShader(stype)

	if source then
		self:source(source)
		self:compile()
	end
end

function Shader:source(source)
	local temp = ffi.new("char[?]", #source+1)
	ffi.copy(temp, source)

	local src = ffi.new("const char*[1]")
	src[0] = temp

	gl.ShaderSource(self.id, 1, src, nil)
end

function Shader:compile()
	gl.CompileShader(self.id)

	local status = ffi.new("GLint[1]")
	gl.GetShaderiv( self.id, gl.GL_COMPILE_STATUS, status)
	if status[0] ~= gl.GL_TRUE then
		local log = ffi.new("char[1024]")
		local len = ffi.new("unsigned int[1]")

		gl.GetShaderInfoLog(self.id, 1024, len, log)
		print(ffi.string(log))
	end
end