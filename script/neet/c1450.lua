--魔道龙-诅咒之龙(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Fusion summon procedure
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_DARK),s.matfilter)	
	--material check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(s.valcheck)
	c:RegisterEffect(e0) 
	--gaia
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(CARD_GAIA_CHAMPION)
	e1:SetCondition(s.con)
	c:RegisterEffect(e1)
	--cannot be targeted
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.con)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--change damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(s.rdcon)
	e3:SetOperation(s.rdop)
	c:RegisterEffect(e3)
	--Register when destroying a monster
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetOperation(s.regop)
	c:RegisterEffect(e4)
	--Special Summon monsters destroyed by battle
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(function(e) return e:GetHandler():HasFlagEffect(id+1) end)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
end
s.listed_series={0xbd}
s.listed_names={CARD_GAIA_CHAMPION}
function s.matfilter(c,fc,sumtype,tp)
	return c:IsRace(RACE_DRAGON,fc,sumtype,tp) and c:IsLevel(5)
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	local mg=g:Filter(Card.IsRace,nil,RACE_WARRIOR)
	if #g>0 and #mg>0 then
		c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD&~(RESET_TOFIELD|RESET_LEAVE|RESET_TEMP_REMOVE),EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
	end
end
function s.con(e)
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and ev<2600 and Duel.GetAttacker()==e:GetHandler()
end
function s.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,2600)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id+1,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_BATTLE,0,1)
end
function s.spfilter(c,e,tp,rc,tid)
	return c:IsReason(REASON_BATTLE) and c:GetReasonCard()==rc and c:GetTurnID()==tid
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp,e:GetHandler(),Duel.GetTurnCount()) end
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp,e:GetHandler(),Duel.GetTurnCount())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	local g=nil
	local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp,c,Duel.GetTurnCount())
	if #tg>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=tg:Select(tp,ft,ft,nil)
	else
		g=tg
	end
	if #g>0 then
		for tc in aux.Next(g) do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_SET_ATTACK)
			e0:SetValue(2300)
			e0:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e0)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(6368038)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		Duel.SpecialSummonComplete()
	end
end