shader_type canvas_item;

void fragment() {
	vec2 center = vec2(0.5); // center of the image
	float radius = 0.5;      // size of the circle
	
	vec2 uv = UV;
	float dist = distance(uv, center);
	
	if (dist > radius) {
		discard; // make transparent outside the circle
	}
	
	COLOR = texture(TEXTURE, uv);
}
