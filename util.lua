util = {}

-- based off some code I found on the internet
function util.projectionmatrix(fov, aspect, znear, zfar)
	ymax = znear * math.tan(fov * math.pi/360)
	xmax = ymax * aspect

	width = xmax * 2
	height = ymax * 2
	depth = zfar - znear

	q = -(zfar + znear) / depth
	qn =  -2 * (zfar * znear) / depth
	w = 2 * znear / width
	w = w / aspect
 	h = 2 * znear / height

 	return {
 		w, 0, 0, 0,
 		0, h, 0, 0,
 		0, 0, q, -1,
 		0, 0, qn, 0
 	}
end

function util.transformationmatrix(vec)
	return {
		1, 0, 0, 0,
		0, 1, 0, 0,
		0, 0, 1, 0,
		vec.x, vec.y, vec.z, 1		
	}
end

function util.identitymatrix()
	return {
		1, 0, 0, 0,
		0, 1, 0, 0,
		0, 0, 1, 0,
		0, 0, 0, 1		
	}
end

function util.multiplymatrix(ma, mb)
	result = {}
	for i = 0, 3 do
		for j = 0, 3 do
			for k = 0, 3 do
				result[i*4+j+1] = (result[i*4+j+1] or 0) + ma[i*4+k+1] * mb[k*4+j+1]
			end
		end
	end

	return result
end

function util.loadfile(file)
	local f = io.open(file, "r")
    local str = f:read("*all")
    f:close()
    return str
end

function util.writefile(file, str)
	local f = io.open(file, "wb")
    f:write(str)
    f:close()
end