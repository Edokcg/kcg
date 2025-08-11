--灵魂战魔
function c77239041.initial_effect(c)
    --每张卡提升攻击力
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c77239041.value)
	c:RegisterEffect(e1)
	
	--战斗破坏除外
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
    e2:SetValue(LOCATION_REMOVED)
    c:RegisterEffect(e2)	
end
----------------------------------------------------------------
function c77239041.value(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),LOCATION_GRAVE,0,nil,TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)*200
end
----------------------------------------------------------------
