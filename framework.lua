ffi = require "ffi"
glfw = require "glfw"
require "opengl"

require "object"
require "util"

require "math/vector"
require "math/quaternion"

require "gl/attribute"
require "gl/elementbuffer"
require "gl/program"
require "gl/shader"
require "gl/uniform"
require "gl/vertexarray"
require "gl/vertexbuffer"	

require "engine/entity"
require "engine/mesh"
require "engine/chunk"
framework = {}

function framework.setState(o)
	state = o
end

function framework.key(glfwkeycode)
	return glfw.glfwGetKey(window, glfwkeycode) == 1
end

local mx, my = ffi.new("double[1]"), ffi.new("double[1]")
function framework.mouse(x, y)
	if not x then
		glfw.glfwGetCursorPos(window, mx, my)
		return mx[0], my[0]
	else
		glfw.glfwSetCursorPos(window, x, y)
	end	
end