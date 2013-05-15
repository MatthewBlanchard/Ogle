require "framework"

do
	assert(glfw.glfwInit() == 1)

	glfw.glfwWindowHint(glfw.GLFW_CONTEXT_VERSION_MAJOR, 3)
	glfw.glfwWindowHint(glfw.GLFW_CONTEXT_VERSION_MINOR, 2)
	glfw.glfwWindowHint(glfw.GLFW_OPENGL_FORWARD_COMPAT, gl.GL_TRUE)
	glfw.glfwWindowHint(glfw.GLFW_OPENGL_PROFILE, glfw.GLFW_OPENGL_CORE_PROFILE)

	window = assert(glfw.glfwCreateWindow(640, 480, "MattRB", nil, nil))
	glfw.glfwMakeContextCurrent(window)
	glfw.glfwSwapInterval(0)

	gl.glEnable(gl.GL_CULL_FACE)
	gl.glEnable(gl.GL_DEPTH_TEST)

	print(arg[1])
	require(arg[1])

	local lt = 0
	while glfw.glfwWindowShouldClose(window) ~= 1 do
		if glfw.glfwGetKey(window, glfw.GLFW_KEY_ESC) == glfw.GLFW_PRESS then
			break
    	end
    	
    	local nt = glfw.glfwGetTime()
    	local dt = nt - lt
    	lt = nt

    	state:update(dt)

    	gl.glClear(bit.bor(gl.GL_COLOR_BUFFER_BIT, gl.GL_DEPTH_BUFFER_BIT))
    	state:draw()
		glfw.glfwSwapBuffers(window)
		glfw.glfwPollEvents()
	end
end