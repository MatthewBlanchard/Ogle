CameraController = Object()

function CameraController:CameraController(entity)
	self.controlled = entity
	self.pitch = 0
	self.yaw = 0
end

local lx, ly
local hw, hh =  640/2, 480/2
function CameraController:update(dt)
	if framework.key(glfw.GLFW_KEY_W) then  
		self.controlled:moveRelative(Vector.forward, 5 * dt)
	elseif framework.key(glfw.GLFW_KEY_S) then
		self.controlled:moveRelative(Vector.forward, -5 * dt)
	elseif framework.key(glfw.GLFW_KEY_A) then
		self.controlled:moveRelative(Vector.side, -5*dt)
	elseif framework.key(glfw.GLFW_KEY_D) then
		self.controlled:moveRelative(Vector.side, 5*dt)
	end

	local mx, my = framework.mouse()

	if not lx then
		if mx ~= 0 and my ~= 0 then
			lx = mx
			ly = my
		end
		return
	end

	local dx, dy = lx - mx, ly - my
	lx, ly = mx, my
	
	self.pitch = self.pitch + dy
	self.yaw = self.yaw + dx
	self.controlled.rot = Quaternion.axisAngle(Vector.side, self.pitch)*Quaternion.axisAngle(Vector.up, self.yaw)
end