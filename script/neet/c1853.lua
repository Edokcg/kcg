--永火再燃(neet)
local s,id=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)	

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(s.tgcon)
	e3:SetCost(Cost.SelfBanish)
	e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)
end
s.listed_series={0xb}
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if e:GetHandler():IsLocation(LOCATION_HAND) then h1=h1-1 end
	if chk==0 then return h1>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,tp,LOCATION_HAND)
end
function s.filter(c)
	return c:IsSetCard(0xb) and c:IsMonster()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SendtoGrave(hg,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(s.filter,nil)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(ct)
	e2:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
	Duel.RegisterEffect(e2,tp)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 and aux.exccon(e)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	--Send 1 card your opponent controls to the GY
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g,true)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end