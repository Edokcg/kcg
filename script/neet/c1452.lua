--枪管改造(neet)
local s,id=GetID()
function s.initial_effect(c)
	--search and ritual
	local rparams={handler=c,lvtype=RITPROC_GREATER,filter=s.ritualfil,matfilter=s.matfilter,extrafil=s.extrafil,extraop=s.extraop}
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop(Ritual.Target(rparams),Ritual.Operation(rparams)))
	c:RegisterEffect(e1)	
end
s.listed_series={0x102}
function s.ritualfil(c)
	return c:IsRace(RACE_DRAGON) and c:IsRitualMonster()
end
function s.matfilter(c,e,tp)
	return c:IsLocation(LOCATION_MZONE|LOCATION_HAND) and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsDestructable(e) 
end
function s.extraop(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	return Duel.Destroy(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
end
function s.desfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x102) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function s.thfilter(c,code)
	return c:IsSetCard(0x102) and c:IsMonster() and not c:IsCode(code) and c:IsAbleToHand()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and s.desfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.desfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.desfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.desop(rittg,ritop)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
			if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and rittg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
				Duel.ConfirmCards(1-tp,g)
				ritop(e,tp,eg,ep,ev,re,r,rp,0)	  
			end
		end
	end
end