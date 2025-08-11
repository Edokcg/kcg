--Cubic Defense
--fixed by MLD
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1218214,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(Cost.SelfBanish)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)  
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if d:IsControler(1-tp) then a,d=d,a end
	if not d or d:IsControler(1-tp) then return false end
	if d:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
		local tcind={d:GetCardEffect(EFFECT_INDESTRUCTABLE_BATTLE)}
		for i=1,#tcind do
			local te=tcind[i]
			local f=te:GetValue()
			if type(f)=='function' then
				if f(te,a) then return false end
			else return false end
		end
	end
	e:SetLabelObject(d)
	if a:IsPosition(POS_FACEUP_DEFENSE) then
		if not a:IsHasEffect(EFFECT_DEFENSE_ATTACK) or a==Duel.GetAttackTarget() then return false end
		if a:IsHasEffect(75372290) then
			if d:IsAttackPos() then
				return a:GetAttack()>0 and a:GetAttack()>=d:GetAttack()
			else
				return a:GetAttack()>d:GetDefense()
			end
		else
			if d:IsAttackPos() then
				return a:GetDefense()>0 and a:GetDefense()>=d:GetAttack()
			else
				return a:GetDefense()>d:GetDefense()
			end
		end
	else
		if d:IsAttackPos() then
			return a:GetAttack()>0 and a:GetAttack()>=d:GetAttack()
		else
			return a:GetAttack()>d:GetDefense()
		end
	end
end
function s.filter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return tc and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) 
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,2,nil,e,tp,tc:GetCode()) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		if tc:RegisterEffect(e1)>0 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
			local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp,tc:GetCode())
			if #g>1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,2,2,nil)
				Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
			end
		end
	end
end

function s.thfilter(c)
	return c:IsSetCard(0xe3) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,e:GetHandler())
	if #g>0 then
		--if g:FilterCount(Card.IsLocation, nil, LOCATION_DECK)>0 then
			--Duel.ShuffleDeck(tp)
		--end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end