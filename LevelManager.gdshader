shader_type canvas_item;

uniform float factor: hint_range(0,1) = 1;

void vertex() {
	// Called for every vertex the material is visible on.
}

float length_squared(vec2 v) {
	return v.x*v.x + v.y*v.y;
}
void fragment() {
	vec2 v = SCREEN_UV - vec2(0.5,0.5);
	float screen_ratio = (SCREEN_PIXEL_SIZE.x/SCREEN_PIXEL_SIZE.y);
	//v.x /= screen_ratio;
	v.y *= screen_ratio;
	if (length(v) < factor){
		COLOR=vec4(0,0,0,0);
	}
}
