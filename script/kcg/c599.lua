--インフェルニティ・ビショップ
local s, id = GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x14b}

function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)==1 and c:IsLocation(LOCATION_HAND)
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

function s.filter(c)
	return c:IsSetCard(0x14b) and c:IsAbleToDeck() 
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,e:GetHandler():GetControler(),LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
