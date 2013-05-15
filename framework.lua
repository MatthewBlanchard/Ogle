ffi = require "ffi"
glfw = require "glfw"
gl = require "opengl"

require "object"
require "util"

require "math/vector"
require "math/quaternion"

require "gl/vertexarrayobject"
require "gl/elementbufferobject"
require "gl/vertexbufferobject"
require "gl/shader"
require "gl/program"
require "gl/attribute"
require "gl/uniform"

require "engine/entity"
require "engine/mesh"

framework = {}

function framework.setState(o)
	state = o
end

function framework.key(glfwkeycode)
	return glfw.glfwGetKey(window, glfwkeycode) == 1
end

function framework.mouse(x, y)
	if not y then
		local x, y = ffi.new("int[1]"), ffi.new("int[1]")
		glfw.glfwGetCursorPos(window, x, y)
		return x[0], y[0]
	else
		glfw.glfwSetCursorPos(window, x, y)
	end	
end