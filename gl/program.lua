Program = Object()

function Program:Program(vert, frag)
	if frag then
		self.id = gl.glCreateProgram()
		self:attach(vert)
		self:attach(frag)
	end
end

function Program:attach(shader)
	gl.glAttachShader(self.id, shader.id)
end

function Program:link()
	gl.glLinkProgram(self.id)
end

function Program:use()
	gl.glUseProgram(self.id)
end

function Program:attribute(name)
	if type(name) == "number" then
		return Attribute(name)
	end

	return Attribute(gl.glGetAttribLocation(self.id, name))
end

function Program:uniform(name)
	return Uniform:new(gl.glGetUniformLocation(self.id, name))
end

function Program:bindAttribLocation(index, name)
	gl.glBindAttribLocation(self.id, index, name)
end

function Program:bindFragDataLocation(num, name)
	gl.glBindFragDataLocation(self.id, num, name)
end