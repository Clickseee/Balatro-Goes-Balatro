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
            local pool = {}
            for k, v in pairs(SMODS.Jokers) do
                if type(k) == "string" and k:sub(1, 6) == "j_bgb_" then
                    table.insert(pool, k)
                end
            end
            if #pool > 0 and #G.jokers.cards < G.jokers.config.card_limit then
                local key = pseudorandom_element(pool, pseudoseed("bgb_joker"))
                SMODS.add_card{
                    key = key,
                    area = G.jokers
                }
            end
        end
    end
}

SMODS.Joker{
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
                local joker = pseudorandom_element(pool, pseudoseed("bgb_mimic"))
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