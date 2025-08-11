--機皇城
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	--untargetable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3013))
	e2:SetValue(s.effval)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ADD_TYPE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_FUSION+TYPE_XYZ+TYPE_LINK))
	e3:SetValue(TYPE_SYNCHRO)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(s.efilterr)
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCondition(s.thcon)
	e5:SetTarget(s.thtg)
	e5:SetOperation(s.thop)
	c:RegisterEffect(e5)
end
s.listed_series={0x3013,0x525,0x507,0x557,0x50d}

function s.effval(e,re,rp)
	return re:GetHandler():IsType(TYPE_SYNCHRO)
end

function s.efilterr(e,te)
	return te:IsActiveType(TYPE_SYNCHRO)
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local atker=Duel.GetAttacker()
	return atker:IsControler(tp) and atker:IsSetCard(0x3013)
end
function s.filter(c)
	return (c:IsSetCard(0x3013) or c:IsSetCard(0x525) or c:IsSetCard(0x507) or c:IsSetCard(0x557) or c:IsSetCard(0x50d)) and c:IsAbleToGrave()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,nil)
	if chk==0 then return s.rescon(sg) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,5,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.rescon(sg,e,tp,mg)
	return sg:IsExists(Card.IsSetCard,1,nil,0x3013) and sg:IsExists(Card.IsSetCard,1,nil,0x525) and sg:IsExists(Card.IsSetCard,1,nil,0x507) and sg:IsExists(Card.IsSetCard,1,nil,0x557) and sg:IsExists(Card.IsSetCard,1,nil,0x50d)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,nil)
	if not s.rescon(sg) then return end
	local spg=aux.SelectUnselectGroup(sg,e,tp,5,5,s.rescon,1,tp,HINTMSG_TOGRAVE)
	if #spg==5 then
		Duel.SendtoGrave(spg,REASON_EFFECT)
	end
end