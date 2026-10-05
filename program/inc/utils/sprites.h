#ifndef _SPRITES_H_
#define _SPRITES_H_

#ifdef __cplusplus
extern "C" {
#endif

#include "main.h"

typedef struct {
  uint8_t width;
  uint8_t height;
  const uint8_t *image;
} Sprite;

typedef struct {
  uint8_t firstChar;
  uint8_t lastChar;
  const Sprite *sprites;
} SpriteFont;

extern const Sprite sprite_background;
extern const Sprite sprite_title;
extern const Sprite sprite_ir;
extern const Sprite sprite_rf;
extern const Sprite sprite_lselector;
extern const Sprite sprite_rselector;
extern const Sprite sprite_record;
extern const Sprite sprite_play;
extern const Sprite sprite_delete;

extern const SpriteFont aseprite_font;
extern const SpriteFont aseprite_mini;

#ifdef __cplusplus
}
#endif

#endif /*_SPRITES_H_*/
