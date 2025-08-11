--RUM－レイド・フォース
local s, id = GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(39015,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(94220427,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
s.listed_series = {0x48, 0x14b}

function s.filter1(c,e,tp,mc)
	if c.rum_limit and not c.rum_limit(mc,e) then return false end
	return c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c,tp)
	and c:GetRank()==mc:GetRank()+10 and c:IsSetCard(0x48) and c:IsSetCard(0x14b)
	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)  
	and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function s.filter2(c,e,tp)
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	return (#pg<=0 or (#pg==1 and pg:IsContains(c))) 
	    and c:GetRank()==1 and c:IsType(TYPE_XYZ) 
		and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=(Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp))
	if chk==0 then return res end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil,e,tp)
	if g:GetCount()<1 then return end
	Duel.SpecialSummon(g,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	g:GetFirst():CompleteProcedure()
	local g2=Duel.GetOperatedGroup()
	local sc=g2:GetFirst()
	if not sc then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local xc=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sc):GetFirst()
	if not xc then return end
	xc:SetMaterial(g2)
	Duel.Overlay(xc,g2)
	Duel.SpecialSummon(xc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	xc:CompleteProcedure()  
	local g3=Duel.GetOperatedGroup()
	if g3:GetCount()<1 then return end
	local de=Effect.CreateEffect(c)
	de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	de:SetCode(EVENT_PHASE+PHASE_END)
	de:SetRange(LOCATION_MZONE)
	de:SetCountLimit(1)
	de:SetTarget(s.rmtg)
	de:SetOperation(s.rmop)
	de:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	xc:RegisterEffect(de)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tatk=c:GetAttack()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		local g2=Duel.GetOperatedGroup()
		if g2:GetCount()<1 then return end
		local tc=g2:GetFirst() 
		local tatk=0
		while tc do
			local atk=tc:GetPreviousAttackOnField() 
			if atk<0 then atk=0 end 
			tatk=tatk+atk 
			tc=g2:GetNext() 
		end
		g2:KeepAlive()
		--spsummon
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e4:SetCountLimit(1)
		e4:SetLabelObject(g2)
		e4:SetLabel(tatk)
		e4:SetCondition(s.spcon)
		e4:SetTarget(s.sptg)
		e4:SetOperation(s.spop)
		if Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.GetTurnPlayer()==tp then
			e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
		else
			e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e4,tp)
	end
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject()
	if chk==0 then return g and #g>0 and g:FilterCount(Card.IsCanBeSpecialSummoned, nil, e,0,tp,false,false)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g and #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local g2=g:Filter(Card.IsCanBeSpecialSummoned, nil, e,0, tp, false, false)
		g:DeleteGroup()
		if #g2<1 then return end
		Duel.SpecialSummon(g2, 0, tp, tp, false, false, POS_FACEUP)
		Duel.BreakEffect()
		local val=e:GetLabel()
		if val and val>0 then
			Duel.Damage(1-tp, val, REASON_EFFECT)
		end
	end
end

function s.cfilter(c,tp)
	return c:IsRankBelow(2) and c:IsSetCard(0x14b) and c:IsControler(tp) and c:IsType(TYPE_XYZ)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
