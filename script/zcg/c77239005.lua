--バスター・ブレイダー
function c77239005.initial_effect(c)
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c77239005.val)
    c:RegisterEffect(e1)
	
    --add code
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetCode(EFFECT_ADD_CODE)
    e2:SetValue(78193831)
    c:RegisterEffect(e2)	
end
function c77239005.val(e,c)
    return Duel.GetMatchingGroupCount(c77239005.filter,c:GetControler(),0,LOCATION_GRAVE+LOCATION_MZONE,nil)*500
end
function c77239005.filter(c)
    return c:IsRace(RACE_DRAGON) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
