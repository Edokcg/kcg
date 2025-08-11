--源數增幅 (KA)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.atkvalue)
	e2:SetValue(s.atk)
	c:RegisterEffect(e2)
end
s.listed_series={0x14b}

function s.atkvalue(e,c)
	return c:IsSetCard(0x14b)
end
function s.atk(e,c)
	local g=Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_DECK,0)
	return g*30
end
