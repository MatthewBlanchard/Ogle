require "cameracontroller"

Game = Object()

local vertshader = [[
	#version 150

	uniform mat4 proj;
	uniform mat4 view;
	uniform mat4 model;

	in vec3 vertexPosition;
	in vec3 vertexNormal;

	out vec3 fragPosition;
	out vec3 fragNormal;

	void main() {
		fragNormal = vertexNormal;
		fragPosition = vertexPosition;

	    gl_Position = proj * view * model * vec4( vertexPosition, 1.0 );
	}
]]

local fragshader = [[
	#version 150

	uniform mat4 view;
	uniform mat4 model;

	in vec3 fragPosition;
	in vec3 fragNormal;

	out vec4 outColor;

	void main()
	{
		mat3 normalMatrix = transpose(inverse(mat3(model)));
		vec3 normal = normalize(normalMatrix * fragNormal);

		vec3 worldPosition = vec3(model * vec4(fragPosition, 1));

		vec3 lightVector = vec3(0, 500, 500) - worldPosition;

		float brightness = dot(normal, lightVector) / (length(lightVector) * length(normal));
    	brightness = clamp(brightness, 0, 1);

	    outColor = brightness * vec4(1, 1, 1, 1);
	}
]]

function Game:Game()
	camera = Entity()
	camera:position(0, 0, 0)
	camcontroller = CameraController(camera)
	
	chunk = Chunk(Vector(128, 8, 128))
	chunk:random()
	chunk:position(-64, 4, -64)

	local vshader = Shader(gl.GL_VERTEX_SHADER, vertshader)
	local fshader = Shader(gl.GL_FRAGMENT_SHADER, fragshader)

	program = Program(vshader, fshader)
	program:bindAttribLocation(0, "vertexPosition")
	program:bindAttribLocation(1, "vertexNormal")
	program:link()
	program:use()

	local projUni = program:uniform("proj")
	projUni:matrix4fv(util.projectionmatrix(74, 800/600, 1, 1000))

	viewUni = program:uniform("view")
	viewUni:matrix4fv(camera:matrix())

	chunkang = 0
end

function Game:update(dt)
	camcontroller:update(dt)
	viewUni:matrix4fv(camera:cameramatrix())


	chunkang = chunkang + 10*dt
	rotation = Quaternion.fromAxisAngle(Vector.up, chunkang)
	chunk:rotation(rotation)
end

function Game:draw()
	chunk:draw(program)
end

framework.setState(Game())