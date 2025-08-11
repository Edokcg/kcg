--Sin 青眼の白龍
function c90.initial_effect(c)
		c:EnableReviveLimit()

		--special summon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_HAND)
		e1:SetCondition(c90.spcon)
		e1:SetOperation(c90.spop)
		c:RegisterEffect(e1)

		--selfdes
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e7:SetRange(LOCATION_MZONE)
		e7:SetCode(EFFECT_SELF_DESTROY)
		e7:SetCondition(c90.descon)
		c:RegisterEffect(e7)
end
c90.listed_names={27564031,89631139}

function c90.sumlimit(e,c)
		return c:IsSetCard(0x23)
end
function c90.exfilter(c)
		return c:IsFaceup() and c:IsSetCard(0x23)
end
function c90.excon(e)
		return Duel.IsExistingMatchingCard(c90.exfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c90.spfilter(c)
		return c:IsCode(89631139) and c:IsAbleToGraveAsCost()
end
function c90.spcon(e,c)
		if c==nil then return true end
		return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
			   and Duel.IsExistingMatchingCard(c90.spfilter,c:GetControler(),LOCATION_HAND+LOCATION_DECK,0,1,nil)
end
function c90.spop(e,tp,eg,ep,ev,re,r,rp,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,c90.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
		if #tg<1 then return end
		Duel.SendtoGrave(tg,REASON_COST)
end

function c90.descon(e)
	return not (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,27564031),e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsEnvironment(27564031))
end
