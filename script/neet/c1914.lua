--时间超越(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,{id,0})
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Ritual Summon 1 Ritual Monster from your hand, by Tributing "Blue-Eyes White Dragon(s)" from your hand or field
	local e2=Ritual.CreateProc({handler=c,filter=s.ritualfil,extrafil=s.extrafil,extraop=s.extraop,extratg=s.extratg,desc=aux.Stringid(id,1)})
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,{id,1})
	e2:SetHintTiming(0,TIMING_STANDBY_PHASE|TIMING_MAIN_END|TIMINGS_CHECK_MONSTER_E)
	e2:SetCost(Cost.SelfBanish)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsRace(RACE_DINOSAUR) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler()) and Duel.IsPlayerCanDraw(tp,2) end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,e:GetHandler())
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler())
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.BreakEffect()	  
		Duel.Draw(p,d,REASON_EFFECT)
	end
end

function s.ritualfil(c)
	return c:IsRitualMonster() and c:IsRace(RACE_DINOSAUR)
end
function s.mfilter(c)
	return c:HasLevel() and c:IsRace(RACE_DINOSAUR)
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
end
function s.extraop(mg,e,tp,eg,ep,ev,re,r,rp)
	if mg:IsExists(s.mfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)		
		local mat2=mg:FilterSelect(tp,s.mfilter,1,99,nil)
		mg:Sub(mat2)
		if #mg>0 then
			Duel.ReleaseRitualMaterial(mg)
		end
		Duel.Destroy(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
	else
		Duel.ReleaseRitualMaterial(mg)
	end
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,0)
end