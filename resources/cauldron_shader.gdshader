shader_type canvas_item;

uniform vec3 some_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//COLOR = vec4(1.0,1.0,1.0,1.0);// Called for every pixel the material is visible on.
	COLOR *= texture(TEXTURE,UV);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
