--Indiora Doom Volt the Cubic Emperor (Movie)
local s, id = GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(s.damtg)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)

	--atk update
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)

	--return instead
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.destg)
	e4:SetOperation(s.desop)
	c:RegisterEffect(e4)
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
	e6:SetDescription(aux.Stringid(id,2))
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
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe3) and c:IsFaceup()
end
function s.target(e,tp,eg,ev,ep,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,3,nil,e:GetHandler()) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local tg=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,3,3,nil,e:GetHandler())
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

function s.damtg(e,tp,eg,ev,ep,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function s.damop(e,tp,eg,ev,ep,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

function s.atkval(e)
	return e:GetHandler():GetOverlayGroup():FilterCount(Card.IsType,nil,TYPE_MONSTER)*800
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():IsPreviousControler(tp)
end
function s.destg(e,tp,eg,ev,ep,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function s.desop(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
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