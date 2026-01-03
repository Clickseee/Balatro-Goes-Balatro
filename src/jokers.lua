SMODS.Joker {
    key = "jellymod",
    blueprint_compat = false,
    rarity = 1,
    cost = 3,
    atlas = "placeholders",
    pos = { x = 0, y = 0 },

    update = function(self, card, dt)
        if not G.jokers then return end

        for i = 1, #G.jokers.cards do
            local j = G.jokers.cards[i]
            if j.ability.right_debuff then
                j.debuff = false
                j.ability.right_debuff = false
            end
        end

        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then
                local target = G.jokers.cards[i + 1]
                if target then
                    target.debuff = true
                    target.ability.right_debuff = true
                end
                break
            end
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if not G.jokers then return end
        for i = 1, #G.jokers.cards do
            local j = G.jokers.cards[i]
            if j.ability.right_debuff then
                j.debuff = false
                j.ability.right_debuff = false
            end
        end
    end
}

SMODS.Joker {
    key = "lust",

    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    atlas = "placeholders",
    pos = { x = 1, y = 0 },

    config = { extra = { screenshake_mod = 10 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.screenshake_mod }
        }
    end,

    calculate = function(self, card, context)
        if context.first_hand_drawn then
            local _card = SMODS.create_card { set = "Enhanced", suit = "Hearts", area = G.discard }
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            _card.playing_card = G.playing_card
            table.insert(G.playing_cards, _card)

            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand:emplace(_card)
                    _card:start_materialize()
                    G.GAME.blind:debuff_card(_card)
                    G.hand:sort()
                    if context.blueprint_card then
                        context.blueprint_card:juice_up()
                    else
                        card:juice_up()
                    end
                    SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
                    save_run()
                    return true
                end
            }))

            return nil, true -- This is for Joker retrigger purposes
        end
    end,
}

SMODS.Joker {
    key = "malverk",

    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    atlas = "placeholders",
    pos = { x = 1, y = 0 },

    config = {
        extra = {
            per_atlas = 1.25,
            unique_atlas = 0,
            current_xmult = 1
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.per_atlas,
                card.ability.extra.unique_atlas,
                card.ability.extra.current_xmult
            }
        }
    end,

    update = function(self, card, dt)
        if not G.jokers then return end

        local seen = {}
        local count = 0

        for _, j in ipairs(G.jokers.cards) do
            if j.config and j.config.center and j.config.center.atlas then
                local atlas = j.config.center.atlas
                if not seen[atlas] then
                    seen[atlas] = true
                    count = count + 1
                end
            end
        end

        card.ability.extra.unique_atlas = count
        card.ability.extra.current_xmult = math.pow(
            card.ability.extra.per_atlas,
            count
        )
    end,

    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.unique_atlas > 0 then
            return {
                x_mult = card.ability.extra.current_xmult,
                card = card,
                colour = G.C.ORANGE
            }
        end
    end
}

SMODS.Joker {
    key = "extracredit",

    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    atlas = "placeholders",
    pos = { x = 1, y = 0 },

    config = { extra = { hsize = 1, jkrreq = 3, bonus = 0 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.hsize, card.ability.extra.jkrreq, card.ability.extra.bonus }
        }
    end,
    add_to_deck = function(self, card)
        local count = #G.jokers.cards
        local bonus = math.floor(count / 3)
        card.ability.extra.bonus = bonus
        G.hand.size = G.hand.size + bonus
    end,
    remove_from_deck = function(self, card)
        G.hand.size = G.hand.size - (card.ability.extra.bonus or 0)
        card.ability.extra.bonus = 0
    end,
    calculate = function(self, card, context)
        if context.joker_added or context.joker_removed then
            G.hand.size = G.hand.size - (card.ability.extra.bonus or 0)
            local count = #G.jokers.cards
            local bonus = math.floor(count / 3)
            card.ability.extra.bonus = bonus
            G.hand.size = G.hand.size + bonus
        end
    end
}

SMODS.Joker {
    key = "imm",

    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    atlas = "placeholders",
    pos = { x = 1, y = 0 },

    calculate = function(self, card, context)
        if context.setting_blind then
            local jokers = {}
            for k, v in pairs(get_current_pool('Joker')) do
                if G.P_CENTERS[v] then
                    if G.P_CENTERS[v].set == 'Joker' and G.P_CENTERS[v].original_mod and G.P_CENTERS[v].original_mod.id == 'balatrogoesbalatro' then
                        table.insert(jokers, G.P_CENTERS[v].key)
                    end
                end
            end
            if #pool > 0 and #G.jokers.cards < G.jokers.config.card_limit then
                local key = pseudorandom_element(pool, pseudoseed("bgb_joker"))
                SMODS.add_card{
                    key = key,
                    area = G.jokers
                }
SMODS.Joker {
    key = "jokerdisplay",

    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    atlas = "placeholders",
    pos = { x = 1, y = 0 },

    config = {
        extra = {
            mult_per_letter = 1,
            current_mult = 0
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult_per_letter,
                card.ability.extra.current_mult
            }
        }
    end,

    update = function(self, card, dt)
        if not G.jokers then return end

        local total_letters = 0

        for _, j in ipairs(G.jokers.cards) do
            if j ~= card and j.config and j.config.center and j.config.center.loc_txt then
                local text = j.config.center.loc_txt.text
                if type(text) == "table" then
                    text = table.concat(text, " ")
                end
                if type(text) == "string" then
                    local _, count = string.gsub(text, "[A-Za-z]", "")
                    total_letters = total_letters + count
                end
            end
        end

        card.ability.extra.current_mult = total_letters * card.ability.extra.mult_per_letter
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.current_mult,
                card = card,
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker {
    key = "superrogue",

    blueprint_compat = false,
    rarity = 3,
    cost = 6,
    atlas = "placeholders",
    pos = { x = 2, y = 0 },

    config = { extra = { copied = nil } },
    calculate = function(self, card, context)
        if context.setting_blind then
            local pool = {}
            for k, v in pairs(SMODS.Jokers) do
                if type(k) == "string" and k:sub(1, 6) == "j_bgb_" then
                    table.insert(pool, v)
                end
            end
            if #pool > 0 then
                local joker = pseudorandom_element(pool, pseudoseed("fuhh"))
                card.ability.extra.copied = joker
            end
        end

        if card.ability.extra.copied
            and card.ability.extra.copied.calculate
            and not context.blueprint then
            return card.ability.extra.copied.calculate(
                card.ability.extra.copied,
                card,
                context
            )
        end
    end
}

SMODS.Joker {
    key = "talisman",

    blueprint_compat = false,
    rarity = 3,
    cost = 6,
    atlas = "placeholders",
    pos = { x = 2, y = 0 },

    config = { extra = { talismanmult = 1.75, talismanrep = 1, chance = 0, last_ante = 0 } },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.chance, 10, 'bryh')
        return { vars = { numerator, denominator, card.ability.extra.talismanmult, card.ability.extra.talismanrep } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and G.GAME.blind.boss then
            card.ability.extra.chance = math.min(10, card.ability.extra.chance + 1)
        end

        if context.joker_main then
            if SMODS.pseudorandom_probability(card, 'bruh', card.ability.extra.chance, 10) then
                error("attempt to compar- did y'all see that?")
            end
        end

        if context.cardarea == G.play and context.individual and not context.blueprint then
            return {
                xmult = card.ability.extra.talismanmult
            }
        end

        if context.cardarea == G.play and context.repetition and not context.blueprint then
            return {
                repetitions = 1
            }
        end
    end,

    update = function(self, card, dt)
        if G.GAME and G.GAME.round_resets then
            if card.ability.extra.last_ante ~= G.GAME.round_resets.ante then
                card.ability.extra.last_ante = G.GAME.round_resets.ante
                card.ability.extra.chance = math.min(10, card.ability.extra.chance + 1)
            end
        end
    end
}
