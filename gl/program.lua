Program = Object()

function Program:Program(vert, frag)
	self.id = gl.CreateProgram()

	if frag then
		self:attach(vert)
		self:attach(frag)
	end
end

function Program:attach(shader)
	gl.AttachShader(self.id, shader.id)
end

function Program:link()
	gl.LinkProgram(self.id)
end

function Program:use()
	gl.UseProgram(self.id)
end

function Program:attribute(name)
	if type(name) == "number" then
		return Attribute(name)
	end

	return Attribute(gl.GetAttribLocation(self.id, name))
end

function Program:uniform(name)
	return Uniform:new(gl.GetUniformLocation(self.id, name))
end

function Program:bindAttribLocation(index, name)
	gl.BindAttribLocation(self.id, index, name)
end

function Program:bindFragDataLocation(num, name)
	gl.BindFragDataLocation(self.id, num, name)
end