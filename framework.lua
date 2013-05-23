ffi = require "ffi"
glfw = require "glfw"
gl = require "opengl"

require "object"
print "???"
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

local mx, my = ffi.new("double[1]"), ffi.new("double[1]")
function framework.mouse(x, y)
	if not y then
		glfw.glfwGetCursorPos(window, mx, my)
		return mx[0], my[0]
	else
		glfw.glfwSetCursorPos(window, x, y)
	end	
end