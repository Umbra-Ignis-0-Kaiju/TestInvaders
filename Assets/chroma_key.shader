shader_type canvas_item;

uniform sampler2D sprite_texture;
uniform vec4 chroma_key : hint_color;

void fragment(){
    COLOR = texture(sprite_texture, UV);

    if (COLOR == chroma_key)
    {
        COLOR.a = 0.0;
    }
}