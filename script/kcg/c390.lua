--Rank Gazer
Duel.LoadScript("c420.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.rectg)
	e1:SetOperation(s.recop)
	c:RegisterEffect(e1)
end

function s.filter12(c,tp)
	local g=c:GetMaterial()
	return c:IsType(TYPE_XYZ) and c:IsControler(tp) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
	  and g:IsExists(s.spfilter2,1,nil)
end
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) 
end
function s.spfilter2(c)
	return c:IsAstral() and c:IsType(TYPE_MONSTER) 
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(s.filter12,1,nil,tp) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	  and Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>0 then
	  local cg=eg:Filter(s.filter12,nil,tp)
	  local pg=aux.GetMustBeMaterialGroup(tp,Group.CreateGroup(),tp,nil,nil,REASON_XYZ)
	  if #pg>0 then return end
	  local cgc=cg:GetFirst()
	  while cgc do
	  local cg2=cgc:GetOverlayGroup()
	  if cg2:GetCount()>0 then
	  Duel.SendtoGrave(cg2,REASON_RULE) end
	  cgc=cg:GetNext() end
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	  local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	  if tc then
		tc:SetMaterial(cg)
		--Duel.Overlay(tc,cg)
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		Duel.Overlay(tc,cg)
		tc:CompleteProcedure()
	end end
end

function s.filter11(c)
	local rk=c:GetRank()
	return rk and rk>0 and c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.filter11,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g:GetCount()>0 end
	local lp=g:GetSum(Card.GetRank)*300
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,lp)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(s.filter11,tp,LOCATION_MZONE,0,nil)
	local lp=g:GetSum(Card.GetRank)*300
	Duel.Recover(p,lp,REASON_EFFECT)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(s.checkop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
