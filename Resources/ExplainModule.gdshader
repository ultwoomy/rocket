shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    // Sample the color of the screen at the current UV coordinates
    vec4 screen_color = texture(screen_texture, SCREEN_UV);

    // Invert the RGB components
    vec3 inverted_rgb = vec3(1.0, 1.0, 1.0) - screen_color.rgb;

    // Set the final color, keeping the original alpha for transparency
    COLOR = vec4(inverted_rgb, screen_color.a);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
