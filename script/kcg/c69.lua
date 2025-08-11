--流星方界器デューザ
local s,id=GetID()
function s.initial_effect(c)
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(s.condition)
	e0:SetTarget(s.target)
	e0:SetOperation(s.operation)
	c:RegisterEffect(e0)

	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)
	
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetOperation(s.spsop)
	c:RegisterEffect(e7)
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetOperation(s.op)
	e5:SetLabelObject(e7)
	c:RegisterEffect(e5)
	
	--Remove
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,3))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCost(Cost.SelfBanish)
	e6:SetTarget(s.target1)
	e6:SetOperation(s.operation1)
	c:RegisterEffect(e6)
end
s.listed_series={0xe3}

function s.condition(e,tp,eg,ev,ep,re,r,rp)
	return Duel.GetTurnPlayer()==tp and not Duel.CheckEvent(EVENT_CHAINING)
end
function s.filter(c,sc)
	return c:IsFaceup() and c:IsSetCard(0xe3)
end
function s.target(e,tp,eg,ev,ep,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler()) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local tg=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,3,nil,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.operation(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetTargetCards(e)
	if c:IsCanBeSpecialSummoned(e,0,tp,false,false) and tg and tg:GetCount()>0 then
		local mg=tg:Clone()
		local tc=tg:GetFirst()
		while tc do
			if tc:GetOverlayCount()~=0 then Duel.Overlay(c,tc:GetOverlayGroup()) end
			tc=tg:GetNext()
		end
		Duel.Overlay(c,mg)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function s.tgfilter(c)
	return c:IsSetCard(0xe3) and c:IsMonster()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.Overlay(e:GetHandler(),g)
	end
end

function s.atkval(e)
	return Duel.GetOverlayGroup(0,1,1):FilterCount(Card.IsType,nil,TYPE_MONSTER)*200
end

function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe3)
end
function s.spsop(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	local mg=e:GetLabelObject()
	if not mg or mg:FilterCount(s.spfilter,nil,e,tp)<1 or Duel.GetLocationCount(tp,LOCATION_MZONE)<mg:GetCount() 
	   or (Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and mg:GetCount()>1) then return end
	Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
	mg:DeleteGroup()
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup()
	if g:GetCount()>0 then
	local mg=g:Filter(s.spfilter,nil,e,tp)
	mg:KeepAlive()
	e:GetLabelObject():SetLabelObject(mg) end
end

function s.filter1(c)
	return c:IsSetCard(0xe3) and c:IsAbleToHand()
end
function s.target1(e,tp,eg,ev,ep,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter1),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_GRAVE)
end
function s.operation1(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,c)
	if #tg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		tg=tg:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end