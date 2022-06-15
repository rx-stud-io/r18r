library(hexSticker)

library(showtext)
font_add_google('Fredericka the Great', 'penny')
showtext_auto()

sticker(
    '~/projects/r18r/world-map-pen-drawn.png',
    package = 'r18r',
    p_size = 26, p_y = 1.5, p_color = '#3764FC', p_family = 'penny',
    s_x = 1, s_y = .85, s_width = 0.8,
    # https://www.vecteezy.com/vector-art/3001221-freehand-world-map-sketch-on-white-background
    filename = '~/projects/r18r/logo.png',
    h_fill = '#F5F5F5', h_color = '#1C2D52',
    url = 'https://github.com/rx-stud-io/r18r',
    u_size = 4.6, u_family = 'penny', u_color = '#1C2D52', u_x = 1.03, u_y=0.10)
