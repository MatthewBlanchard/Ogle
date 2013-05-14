Quaternion = Object()

function Quaternion:Quaternion(x, y, z, w)
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
	self.w = w or 1
end

-- Static methods

local sin, cos = math.sin, math.cos
function Quaternion.fromAxisAngle(axis, angle)
	local angle = math.rad(angle)
    local s = math.sin(angle/2)

    local x = s * axis.x
    local y = s * axis.y
    local z = s * axis.z
    local w = math.cos(angle/2)

    return Quaternion(x, y, z, w)
end

function Quaternion.axisAngle(axis, angle)
	return Quaternion.fromAxisAngle(axis, angle)
end

-- Metamethods
function Quaternion:__tostring()
	return self.x .. "\t" .. self.y .. "\t" .. self.z .. "\t" .. self.w
end

function Quaternion:__mul(quat)
	local x, y, z, w = self.x, self.y, self.z, self.w
	return Quaternion:new(
						w * quat.x + x * quat.w + y * quat.z - z * quat.y,
	                	w * quat.y + y * quat.w + z * quat.x - x * quat.z,
	                 	w * quat.z + z * quat.w + x * quat.y - y * quat.x,
	                 	w * quat.w - x * quat.x - y * quat.y - z * quat.z)
end

-- Methods
local sqrt = math.sqrt
function Quaternion:normalize()
	local mag = sqrt(self.w * self.w +
					self.x * self.x +
					self.y * self.y +
					self.z * self.z)

	self.w = self.w/mag
	self.x = self.x/mag
	self.y = self.y/mag
	self.z = self.z/mag
end

function Quaternion:forward()
	x, y, z, w = self.x, self.y, self.z, self.w
	return Vector:new( 	2 * (x * z + w * y), 
                    	2 * (y * x - w * x),
                    	1 - 2 * (x * x + y * y)
                    )
end

function Quaternion:conjugate()
	return Quaternion:new(-self.x, -self.y, -self.z, self.w)
end

function Quaternion:rotate(vec)
	local sx, sy, sw, sz = self.x, self.y, self.w, self.z
	local nx, ny, nz, mag = vec:inlinenormal()

	local cx, cy, cz, cw = -self.x, -self.y, -self.z, self.w
	local rx, ry, rz, rw = 
						nx * cw + ny * cz - nz * cy,
	                	ny * cw + nz * cx - nx * cz,
	                 	nz * cw + nx * cy - ny * cx,
	                 	0 - nx * cx - ny * cy - nz * cz
	rx, ry, rz = 
			(sw * rx + sx * rw + sy * rz - sz * ry)*mag,
	       	(sw * ry + sy * rw + sz * rx - sx * rz)*mag,
	        (sw * rz + sz * rw + sx * ry - sy * rx)*mag

	return Vector:new(rx*mag, ry*mag, rz*mag)
end

function Quaternion:matrix(vec)
	local vec = vec or {}
	local x2, y2, z2 = self.x * self.x, self.y * self.y, self.z * self.z
	local xy, xz, yz = self.x * self.y, self.x * self.z, self.y * self.z
	local wx, wy, wz = self.w * self.x, self.w * self.y, self.w * self.z

	return 	{
				1 - 2 * (y2 + z2), 2 * (xy + wz), 2 * (xz - wy), 0,
				2 * (xy - wz), 1 - 2 * (x2 + z2), 2 * (yz + wx), 0,
				2 * (xz + wy), 2 * (yz - wx), 1 - 2 * (x2 + y2), 0,
				vec.x or 0, vec.y or 0, vec.z or 0, 1
			}
end