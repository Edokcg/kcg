--欧贝利斯克之致命毁灭(ZCG)
local s,id=GetID()
function s.initial_effect(c)
		--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
--cannot trigger
	local e101=Effect.CreateEffect(c)
	e101:SetType(EFFECT_TYPE_FIELD)
	e101:SetCode(EFFECT_CANNOT_TRIGGER)
	e101:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e101:SetRange(LOCATION_SZONE)
	e101:SetTargetRange(0,0xa)
	e101:SetTarget(s.distg99)
	c:RegisterEffect(e101)
	--disable
	local e102=Effect.CreateEffect(c)
	e102:SetType(EFFECT_TYPE_FIELD)
	e102:SetCode(EFFECT_DISABLE)
	e102:SetRange(LOCATION_SZONE)
	e102:SetTargetRange(0,LOCATION_ONFIELD)
	e102:SetTarget(s.distg99)
	c:RegisterEffect(e102)
	--disable effect
	local e103=Effect.CreateEffect(c)
	e103:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e103:SetCode(EVENT_CHAIN_SOLVING)
	e103:SetRange(LOCATION_SZONE)
	e103:SetOperation(s.disop99)
	c:RegisterEffect(e103)
	--
	local e104=Effect.CreateEffect(c)
	e104:SetType(EFFECT_TYPE_FIELD)
	e104:SetCode(EFFECT_SELF_DESTROY)
	e104:SetRange(LOCATION_SZONE)
	e104:SetTargetRange(0,LOCATION_ONFIELD)
	e104:SetTarget(s.distg99)
	c:RegisterEffect(e104)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,10,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,10,tp,LOCATION_DECK)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,10)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local g2=Duel.GetOperatedGroup()
	local tc=g2:GetFirst()
	local fid=77240560
	while tc do 
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		tc=g2:GetNext()
	end
	--g77240560:KeepAlive()
	
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid,Duel.GetTurnCount())
		e1:SetCondition(s.rmcon)
		e1:SetOperation(s.rmop2)
		if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,4)
		else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,3)
		end
		Duel.RegisterEffect(e1,tp)
end
function s.rmfilter(c,fid,e,tp)
	return c:GetFlagEffectLabel(id)==fid and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsType(TYPE_MONSTER)
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	--local g=e:GetLabelObject()
	local fid,count=e:GetLabel() 
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_REMOVED,0,nil)
	g=g:Filter(s.rmfilter,nil,fid,e,tp)
	if not g:IsExists(s.rmfilter,1,nil,fid,e,tp) then
		g:DeleteGroup()
		e:Reset()
		return false
	elseif Duel.GetTurnCount()~=count+3 then return false
	else return true end
end
function s.rmop2(e,tp,eg,ep,ev,re,r,rp)
	--local gg=e:GetLabelObject()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_REMOVED,0,nil)
	local fid,count=e:GetLabel() 
	g=g:Filter(s.rmfilter,nil,fid,e,tp)
	if g:GetCount()<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=g:Select(tp,ft,ft,nil)
	if g2:GetCount()<=0 then return end
	local tc=g2:GetFirst()  
	while tc do
	Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
	tc=g2:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function s.distg99(e,c)
	return c:IsSetCard(0xa90) or c:IsSetCard(0xa110)
end
function s.disop99(e,tp,eg,ep,ev,re,r,rp)
	if  (re:GetHandler():IsSetCard(0xa90) or re:GetHandler():IsSetCard(0xa110)) and re:GetHandler():IsControler(1-tp) then
		Duel.NegateEffect(ev)
	end
end