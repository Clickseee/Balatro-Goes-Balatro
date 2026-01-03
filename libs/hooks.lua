local LOLcurpress = Controller.L_cursor_press
function Controller:L_cursor_press(x, y)
    LOLcurpress(self, x, y)
    if G and G.jokers and G.jokers.cards and not G.SETTINGS.paused then
        SMODS.calculate_context({ bgb_press = true })
    end
end