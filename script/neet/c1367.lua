--混血种吸血鬼(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--2 monsters, including a "Vaalmonica" Link Monster
	Link.AddProcedure(c,nil,2,2,s.matcheck)	
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--cannot be target/indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
	--to GY
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(s.tgcon)
	e6:SetTarget(s.tgtg)
	e6:SetOperation(s.tgop)
	c:RegisterEffect(e6)
end
s.listed_series={0x8e}
function s.matfilter(c,lc,sumtype,tp)
	return c:IsSetCard(0x8e,lc,sumtype,tp)
end
function s.spfilter(c,e,tp,zone)
	return zone~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	local zone=c:GetFreeLinkedZone()&0x1f
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and s.spfilter(chkc,e,tp,zone) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingTarget(s.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetFreeLinkedZone()&0x1f
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and zone~=0 and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP,zone)~=0 then
		if tc:IsLinkMonster() and not tc:HasLevel() then
			local e0=Effect.CreateEffect(c)
			e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_LINK_LEVEL)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e0,true)  
		end
		if tc:IsType(TYPE_XYZ) and not tc:HasLevel() then
			local e0=Effect.CreateEffect(c)
			e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_RANK_LEVEL)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e0,true)  
		end
		local e2=Effect.CreateEffect(c)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(5)
		tc:RegisterEffect(e2,true)  
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CHANGE_RACE)
		e3:SetValue(RACE_ZOMBIE)
		tc:RegisterEffect(e3)
	end
end
function s.filter(c)
	return c:IsFaceup() and c:GetSequence()>=5 and c:IsRace(RACE_ZOMBIE)
end
function s.indcon(e)
	local tp=e:GetHandler():GetControler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	return #g>0
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousControler(tp) and not c:IsLocation(LOCATION_DECK) 
		and c:IsPreviousPosition(POS_FACEUP)
end
function s.tgfilter(c)
	return c:IsSetCard(0x8e) and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end