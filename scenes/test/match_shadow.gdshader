shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
		COLOR = vec4(1.0,1.0,1.0,1.0);
}

void fragment() {
		COLOR = vec4(0.1,0.1,0.1,1)*texture(TEXTURE,UV);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
