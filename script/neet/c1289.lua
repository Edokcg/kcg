--灵魂的觉醒(neet)
local s,id=GetID()
function s.initial_effect(c)
	local e1=Ritual.CreateProc({handler=c,lvtype=RITPROC_GREATER,extrafil=s.extrafil,extraop=s.extraop,matfilter=s.forcedgroup,forcedselection=function(e,tp,g,sc)return g:IsExists(s.matfilter,1,nil) end})
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(Cost.SelfBanish)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end
--s.listed_card_types={TYPE_SPIRIT}
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
end
function s.extraop(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	return Duel.SendtoHand(mat,nil,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
end
function s.forcedgroup(c,e,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsAbleToHand() and not c:IsType(TYPE_RITUAL)
end
function s.matfilter(c)
	return  c:IsLocation(LOCATION_MZONE) and c:IsAbleToHand() and c:IsType(TYPE_SPIRIT) and not c:IsType(TYPE_RITUAL)
end
function s.dfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPIRIT) and c:IsAbleToHand() 
end
function s.dfilter2(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.dfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.dfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.dfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(s.dfilter2,tp,LOCATION_DECK,0,nil)
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) 
	then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
