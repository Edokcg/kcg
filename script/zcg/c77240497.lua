--机械昆虫 零之毁灭(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	 --Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	   --
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetRange(LOCATION_SZONE)
	e11:SetCode(EFFECT_IMMUNE_EFFECT)
	e11:SetValue(s.efilter)
	c:RegisterEffect(e11)
end
function s.efilter(e,te)
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if ec:IsHasCardTarget(c) then return true end
	return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te) and ec:GetControler()~=c:GetControler()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_HAND,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_HAND,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,#g,PLAYER_ALL,LOCATION_ONFIELD+LOCATION_HAND)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
 local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_HAND,nil)
  if #g>0 then
   Duel.Destroy(g,REASON_EFFECT)
end
end