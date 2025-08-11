-- 真祖 欧贝利斯克之巨神兵
local s, id = GetID()
function s.initial_effect(c)
    aux.god(c,3,id,1)
	aux.obelisk(c,3)

    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(805)
    e1:SetValue(3)
    c:RegisterEffect(e1)
end