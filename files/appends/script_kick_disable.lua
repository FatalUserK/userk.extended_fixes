if kick then
    local old_kick = kick
    kick = function(entity_id)
        if ComponentGetIsEnabled(GetUpdatedComponentID()) then
            old_kick(entity_id)
        end
    end
end