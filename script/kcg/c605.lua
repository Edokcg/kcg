--RR－シンギング・レイニアス
function c605.initial_effect(c)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c605.spcon)
	e1:SetOperation(c605.activate)
	c:RegisterEffect(e1)
end

function c605.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c605.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c605.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c605.activate(e,tp,eg,ep,ev,re,r,rp)
            Duel.Recover(e:GetHandler():GetControler(),1000,REASON_EFFECT)
end
