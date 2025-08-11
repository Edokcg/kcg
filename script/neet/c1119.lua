--铁骑龙 阿普斯维奇(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)   
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
	--disable field
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DISABLE_FIELD)
	e4:SetProperty(EFFECT_FLAG_REPEAT)
	e4:SetOperation(s.disop)
	c:RegisterEffect(e4) 
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)>Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,1-tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,1-tp,true,true,POS_FACEUP)~=0 then
		c:CompleteProcedure()
	end
end
function s.filter(c,e)
	local seq=e:GetHandler():GetSequence()
	local sseq=c:GetSequence()
	return sseq<5 and ((seq==0 and sseq==3) or (seq==1 and (sseq==4 or sseq==2)) or (seq==2 and (sseq==3 or sseq==1)) or (seq==3 and (sseq==0 or sseq==2)) 
	or (seq==4 and sseq==1))
end
function s.desfilter(c,g)
	return g:IsContains(c)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lrg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0):Filter(s.filter,nil,e)
	local cg=e:GetHandler():GetColumnGroup()
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_ONFIELD,0,e:GetHandler(),cg)
	g:Merge(lrg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	local lrg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0):Filter(s.filter,nil,e)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_ONFIELD,0,c,cg)
		g:Merge(lrg)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function s.disop(e,tp)
	local c=e:GetHandler()
	local zone
	local zone2=c:GetColumnZone(LOCATION_SZONE)&0xffff
	if Duel.GetMasterRule()>=4 then
		if c:IsSequence(5,6) then 
			zone=c:GetColumnZone(LOCATION_MZONE)&0xffff 
		elseif c:IsSequence(0,1) then
			zone=(c:GetColumnZone(LOCATION_MZONE,1,1,tp)&0xffff)-0x20
		elseif c:IsSequence(3,4) then
			zone=(c:GetColumnZone(LOCATION_MZONE,1,1,tp)&0xffff)-0x40
		else
			zone=(c:GetColumnZone(LOCATION_MZONE,1,1,tp)&0xffff)-0x60
		end
		return zone+zone2
	else
		zone=c:GetColumnZone(LOCATION_MZONE,1,1,tp)&0xffff
		return zone+zone2
	end
end