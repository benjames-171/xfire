components {
  id: "player"
  component: "/game/player/player.script"
  position {
    x: 0.0
    y: 0.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"cursor\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "blend_mode: BLEND_MODE_ALPHA\n"
  "slice9 {\n"
  "  x: 4.0\n"
  "  y: 4.0\n"
  "  z: 4.0\n"
  "  w: 4.0\n"
  "}\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/game/core/16.tilesource\"\n"
  "}\n"
  ""
  position {
    x: 8.0
    y: 8.0
    z: 1.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
