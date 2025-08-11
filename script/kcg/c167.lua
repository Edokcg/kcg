--Barian's Chaos Draw
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)	
end
s.listed_series={0x48,0x1048}

function s.filter1(c,e,tp)
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	return (#pg<=0 or (#pg==1 and pg:IsContains(c))) and c:IsFaceup() 
	and c:IsCode(787)
	and (c:GetRank()>0 or c:IsStatus(STATUS_NO_LEVEL))
	and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+1,pg)
end
function s.filter2(c,e,tp,mc,rk,pg)
	return mc:IsType(TYPE_XYZ,c,SUMMON_TYPE_XYZ,tp) and c:IsRank(rk)
	and not c:IsSetCard(0x48) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
	and mc:IsCanBeXyzMaterial(c,tp) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function s.xyzfilter(c,tp,sg,g)
	return ((c:IsSetCard(0x48) and c.xyz_number and c.xyz_number>=101 and c.xyz_number<=107) or not c:IsSetCard(0x48))
	and c:IsXyzSummonable(sg,sg+g) and Duel.GetLocationCountFromEx(tp,tp,sg+g,c)>0
end
function s.rescon(sg,e,tp,mg)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,tp,sg,g)
end
function s.copfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x95) and c:GetType()==TYPE_SPELL
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,LOCATION_DECK,0,nil,e,0,tp,false,false)
	local b1=Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(s.copfilter,tp,LOCATION_DECK,0,1,nil)
	local ft=math.min(3,Duel.GetLocationCount(tp,LOCATION_MZONE))
	if ft>0 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	local b2=Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and ft>0 and #mg>0 and aux.SelectUnselectGroup(mg,e,tp,1,ft,s.rescon,0)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter1(chkc,e,tp) end	
	if chk==0 then
		local res=b1 or b2
		return res
	end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,1)},
		{b2,aux.Stringid(id,2)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local ga=Duel.SelectMatchingCard(tp,s.copfilter,tp,LOCATION_DECK,0,1,1,nil)
		if not Duel.SendtoGrave(ga,REASON_COST) then return end
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	else
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
	e:SetLabel(op)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		local tc=Duel.GetFirstTarget()
		local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(tc),tp,nil,nil,REASON_XYZ)
		if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) or #pg>1 or (#pg==1 and not pg:IsContains(tc)) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1,pg)
		local sc=g:GetFirst()
		if sc then
			sc:SetMaterial(tc)
			Duel.Overlay(sc,tc)
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	elseif op==2 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
		local mg=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,LOCATION_DECK,0,nil,e,0,tp,false,false)
		if #mg==0 then return end
		local ft=math.min(3,Duel.GetLocationCount(tp,LOCATION_MZONE))
		if ft>0 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
		local sg=aux.SelectUnselectGroup(mg,e,tp,1,ft,s.rescon,1,tp,HINTMSG_SPSUMMON,s.rescon)
		if #sg==0 then return end
		for tc in aux.Next(sg) do
			if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
				--Negate their effects
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				tc:RegisterEffect(e2)
			end
		end
		Duel.SpecialSummonComplete()
		local fg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyzg=Duel.SelectMatchingCard(tp,s.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp,sg,fg)
		if #xyzg>0 then
			Duel.XyzSummon(tp,xyzg:GetFirst(),sg)
		end
	end
end

function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function s.thfilter(c)
	return c:IsDestructable()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
end