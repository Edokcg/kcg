--魔導の師弟倍返し
function c77239980.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c77239980.target)
	e1:SetOperation(c77239980.activate)
	c:RegisterEffect(e1)
	--give effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77239980,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c77239980.target1)
	e2:SetOperation(c77239980.operation)
	c:RegisterEffect(e2)
end
c77239980.card_code_list={38033121}
function c77239980.filter(c,e,tp)
	return ( c:IsCode(38033121) or c:IsSetCard(0x10a2)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c77239980.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77239980.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c77239980.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(c77239980.filter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
	if ft<=0 or tg:GetCount()==0 then return end
	
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(77239980,0)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:Select(tp,ft,ft,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		c:SetCardTarget(tc)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end
end
function c77239980.filter2(c)
	return c:IsSetCard(0x10a2) and c:IsFaceup()
end
function c77239980.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c77239980.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c77239980.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c77239980.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		--atk up
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(77239980,1))
		e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)		
		e1:SetCondition(c77239980.retcon)
		e1:SetOperation(c77239980.atkop)
		tc:RegisterEffect(e1)
		--indes
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e3)
	end
end
function c77239980.retcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c77239980.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
