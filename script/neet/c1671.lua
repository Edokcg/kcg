--星尘辉巧群（neet）
local s,id=GetID()
function s.initial_effect(c)
	 --Ritual Summon
	Ritual.AddProcGreater({handler=c,filter=s.ritualfil,lv=Card.GetAttack,matfilter=s.filter,location=LOCATION_HAND|LOCATION_GRAVE,requirementfunc=Card.GetAttack,desc=aux.Stringid(id,0)})
 --Add itself to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_ATKCHANGE+CATEGORY_SEARCH+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
s.listed_series={0x151}
function s.ritualfil(c)
	return c:GetAttack()>0 and c:IsRitualMonster() and c:IsRace(RACE_MACHINE)
end
function s.filter(c)
	return c:IsRace(RACE_MACHINE) and c:GetAttack()>0
end
function s.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:GetAttack()>=2000
end
function s.thfilter(c)
	return c:IsSetCard(0x151) and c:IsAbleToHand() and not c:IsType(TYPE_RITUAL)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.atkfilter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsExistingTarget(s.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:UpdateAttack(-2000,RESET_EVENT+RESETS_STANDARD,c)==-2000
		and c:IsRelateToEffect(e) then
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		 local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		 if #g>0 then
			 Duel.SendtoHand(g,nil,REASON_EFFECT)
			 Duel.ConfirmCards(1-tp,g)
		 Duel.BreakEffect()
		 Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
		 end
	end
end