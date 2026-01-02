Balala = SMODS.current_mod
SMODS.load_file("src/atlases.lua")()
SMODS.load_file("src/jokers.lua")()
Balala.rainbow_gradient = SMODS.Gradient {
    key = "rainbow_gradient",
    colours = {
        HEX("ff4d4d"),
        HEX("ffa64d"),
        HEX("ffff4d"),
        HEX("4dff4d"),
        HEX("4dffff"),
        HEX("4d4dff"),
        HEX("a64dff"),
        HEX("ff4dff"),
    },
    cycle = 10
}

Balala.badge_colour = SMODS.Gradients["bgb_rainbow_gradient"]
