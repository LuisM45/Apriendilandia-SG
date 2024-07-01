extends Node

func lerp(color1:Color,color2:Color,weight:float):
	var _weight = clamp(weight,0.0,1.0)
	return color1*(1-_weight)+color2*_weight

func color_hsv_random_variation(color:Color,hsv_variation:Vector3):
	var h = color.h + randf_range(-hsv_variation.x,hsv_variation.x)
	var s = color.s + randf_range(-hsv_variation.y,hsv_variation.y)
	var v = color.v + randf_range(-hsv_variation.z,hsv_variation.z)
	if h<0: h += 1
	s = clamp(s,0,1)
	v = clamp(v,0,1)
	return Color.from_hsv(h,s,v)

func color_rgb_random_variation(color:Color,rgb_variation:Vector3):
	var r = color.r + randf_range(-rgb_variation.x,rgb_variation.x)
	var g = color.g + randf_range(-rgb_variation.y,rgb_variation.y)
	var b = color.b + randf_range(-rgb_variation.z,rgb_variation.z)
	r = clamp(r,.0,1.)
	g = clamp(g,.0,1.)
	b = clamp(b,.0,1.)
	return Color(r,g,b)

func combine_colors_no_weights(colors:Array[Color]):
	var weights:Array[float] = []
	weights.resize(colors.size())
	weights.fill(1)
	return combine_colors(colors,weights)

func combine_colors(colors:Array[Color],weights:Array[float]):
	var combined_weight = _sum(weights)
	var normalized_weights = weights.map(func(x):return x/combined_weight)
	var weighted_colors = []
	for i in range(colors.size()):
		weighted_colors.append(normalized_weights[i]*colors[i])
	
	return _sum(weighted_colors)

func combine_color_pair(color1:Color,color2:Color,weight):
	return combine_colors([color1,color2],[weight,1-weight])


func dirty_combine_colors_no_weights(colors:Array[Color]):
	var weights:Array[float] = []
	weights.resize(colors.size())
	weights.fill(1)
	return dirty_combine_colors(colors,weights)

func dirty_combine_colors(colors:Array[Color],weights:Array[float]):
	var combined_weight = _sum(weights)
	var normalized_weights = weights.map(func(x):return x/combined_weight)
	
	var hsv_rectVec3_colors = colors.map(color_to_hsv_rectVec3)	
	var weighted_hsv_colors:Array[Vector3] = []
	for i in range(colors.size()):
		weighted_hsv_colors.append(hsv_rectVec3_colors[i]*normalized_weights[i])
	
	var final_hsv_color = _sum(weighted_hsv_colors)
	return hsv_rectVec3_to_color(final_hsv_color)


func dirty_combine_color_pair(color1:Color,color2:Color,weight):
	return dirty_combine_colors([color1,color2],[weight,1-weight])

func color_to_hsv_rectVec3(color:Color)->Vector3:
	# let xy be hue/saturation plane and z be value
	# returns Vector(hs.x,hs.y,v)
	var hs_direction = Vector2.from_angle(color.h*2*PI)
	var hs_vector = hs_direction*color.s
	return Vector3(hs_vector.x,hs_vector.y,color.v)

func hsv_rectVec3_to_color(hsv:Vector3)->Color:
	var hs_vector = Vector2(hsv.x,hsv.y)
	var h = hs_vector.angle()/2/PI
	if(h<0): h+=1
	var s = hs_vector.length()
	var v = hsv.z
	
	return Color.from_hsv(h,s,v)

func _sum(array):
	var acc = array[0] * 0
	for i in array:
		acc += i
	return acc

func _dirty_combine_colors(color1:Color,color2:Color,weight):
	var rect_hs_1 = Vector2(color1.h,color1.h)*2*PI
	rect_hs_1.x = cos(rect_hs_1.x)
	rect_hs_1.y = sin(rect_hs_1.y)
	rect_hs_1 *= color1.s
	
	var rect_hs_2 = Vector2(color2.h,color2.h)*2*PI
	rect_hs_2.x = cos(rect_hs_2.x)
	rect_hs_2.y = sin(rect_hs_2.y)
	rect_hs_2 *= color2.s
	
	var rect_hs_x = rect_hs_1.lerp(rect_hs_2,weight)
	var v = weight*color1.v + (1-weight)*color2.v
	
	var h = rect_hs_x.angle()/(2*PI)
	h += 1 if h <=0 else 0
	var s = rect_hs_x.length()
	return Color.from_hsv(h,s,v)

