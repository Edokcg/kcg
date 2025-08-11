--繭狀體·小雛鳥(KCG)
--C・チッキー
local s,id=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
s.listed_names={54959865,42015635}

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(42015635)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsEnvironment(42015635) then return end
	e:GetHandler():SetEntityCode(54959865, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true)
    aux.CopyCardTable(54959865,e:GetHandler())
end