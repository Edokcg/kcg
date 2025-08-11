--Sin スターダスト·ドラゴン
function c91.initial_effect(c)
		c:EnableReviveLimit()

		--special summon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_HAND)
		e1:SetCondition(c91.spcon)
		e1:SetOperation(c91.spop)
		c:RegisterEffect(e1) 

		--selfdes
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e7:SetRange(LOCATION_MZONE)
		e7:SetCode(EFFECT_SELF_DESTROY)
		e7:SetCondition(c91.descon)
		c:RegisterEffect(e7)

		--indes
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_FIELD)
		e9:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e9:SetRange(LOCATION_MZONE)
		e9:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
		e9:SetTarget(c91.indes)
		e9:SetValue(1)
		c:RegisterEffect(e9)

		--spson
		local ea=Effect.CreateEffect(c)
		ea:SetType(EFFECT_TYPE_SINGLE)
		ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		ea:SetCode(EFFECT_SPSUMMON_CONDITION)
		ea:SetValue(aux.FALSE)
		c:RegisterEffect(ea)
end
c91.listed_names={27564031,44508094}

function c91.sumlimit(e,c)
		return c:IsSetCard(0x23)
end
function c91.indes(e,c)
		return c:IsFaceup() and c:GetSequence()==5
end

function c91.spfilter(c)
		return c:IsCode(44508094) and c:IsAbleToGraveAsCost()
end
function c91.spcon(e,c)
		if c==nil then return true end
		return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
			   and Duel.IsExistingMatchingCard(c91.spfilter,c:GetControler(),LOCATION_EXTRA,0,1,nil)
end
function c91.spop(e,tp,eg,ep,ev,re,r,rp,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,c91.spfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		if #tg<1 then return end
		Duel.SendtoGrave(tg,REASON_COST)
end

function c91.descon(e)
	return not (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,27564031),e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsEnvironment(27564031))
end