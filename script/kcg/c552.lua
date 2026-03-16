--ゲイザー・シャーク
--Gazer Shark
local s,id=GetID()
function s.initial_effect(c)
	--Banish itself, Special Summon 2 level 5 WATER monsters from your GY then Xyz Summon 1 WATER monster using those monsters as materials
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_XYZ_MAT_FROM_GRAVE)
	c:RegisterEffect(e3)
end

function s.filter(c)
	return c:IsLevel(5) and c:IsAttribute(ATTRIBUTE_WATER)
end
function s.xyzfilter(c,mg)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsXyzSummonable(nil,mg,2,2)
end
function s.rescon(exg)
	return function(sg)
		return #sg==2 and exg:IsExists(Card.IsXyzSummonable,1,nil,nil,sg,2,2)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter),tp,LOCATION_GRAVE,0,nil)
	local exg=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,c,mg,2,3)
	if chk==0 then return #exg>0
		and Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.filter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)<1 then return end
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter),tp,LOCATION_GRAVE,0,nil)
	local xyzg=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,c,mg,2,3)
	if #xyzg>0 then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_BE_MATERIAL)
		e4:SetCondition(s.regcon)
		e4:SetOperation(s.regop)
		e4:Reset(RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE)
		c:RegisterEffect(e4)
		--banish
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e2:SetCode(EVENT_TO_GRAVE)
		e2:SetOperation(s.rmop)
		e2:Reset(RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE)
		c:RegisterEffect(e2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,c,mg)
	end
end

function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(id+1)>0 then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
		c:ResetFlagEffect(id+1)
	end
end

function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id+1,RESET_EVENT+0x1fa0000,0,0)
end