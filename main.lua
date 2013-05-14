require "cameracontroller"

Game = Object()

local vertices = {
	0.0,  0.5,
    0.5, -0.5,
    -0.5, -0.5
}

local elements = {
	0, 1, 2
}

local vertshader = [[
	#version 150

	in vec3 position;
	in vec3 normal;

	out vec3 Normal;
	out vec3 Pos;

	uniform mat4 proj;
	uniform mat4 view;
	uniform mat4 model;

	void main() {
		Normal = mat3(model) * normal;
		Pos = vec3(model * vec4(position, 1.0));
	    gl_Position = proj * view * model * vec4( position, 1.0 );
	}
]]

local fragshader = [[
	#version 150

	in vec3 Normal;
	in vec3 Pos;
	out vec4 outColor;

	void main()
	{
		vec3 s = normalize(vec3(0, 50, 0) - Pos);
	    outColor = vec4( vec3(.7, .7, .7) * max(0.0, dot(Normal, s.xyz)), 1.0 ) + vec4(.1, .1, .1, 1);
	}
]]

function Game:Game()
	camera = Entity()
	camera:position(0, 0, 0)
	camcontroller = CameraController(camera)

	sponza = Mesh.OBJ("sponza.obj")
	sponza:position(0, -5, 0)

	vshader = Shader(gl.GL_VERTEX_SHADER, vertshader)
	fshader = Shader(gl.GL_FRAGMENT_SHADER, fragshader)

	program = Program(vshader, fshader)
	program:bindAttribLocation(0, "position")
	program:bindAttribLocation(1, "normal")
	program:link()
	program:use()

	projUni = program:uniform("proj")
	projUni:matrix4fv(util.projectionmatrix(74, 640/480, 1, 10000))

	viewUni = program:uniform("view")
	viewUni:matrix4fv(camera:matrix())
end

function Game:update(dt)
	camcontroller:update(dt)
	viewUni:matrix4fv(camera:cameramatrix())
end

function Game:draw()
	sponza:draw(program)
end

framework.setState(Game())