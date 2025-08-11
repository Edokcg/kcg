--机甲精英骨架(neet)
local s,id=GetID()
function s.initial_effect(c)
	aux.AddUnionProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),false)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(2,id)
	e1:SetTarget(s.stg)
	e1:SetOperation(s.sop)
	c:RegisterEffect(e1)  
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_CUSTOM+id)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e3)
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_EQUIP)
		ge1:SetCondition(s.checkcon)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
s.listed_series={0x36}
s.listed_names={id}
function s.sfilter(c)
	return c:IsSetCard(0x36) and c:GetCode()~=id and c:IsMonster() and c:IsAbleToHand()
end
function s.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.sop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.checkcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst():GetEquipTarget()
	return eg:IsExists(Card.IsCode,1,nil,id) and tc:IsRace(RACE_MACHINE)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(re:GetHandler(),EVENT_CUSTOM+id,re,r,rp,ep,ev)
end