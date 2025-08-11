--逆袭(neet)
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(Cost.SelfBanish)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)   
end
function s.filter(c)
	return not c:IsType(TYPE_LINK) and c:HasLevel() or (c:IsType(TYPE_XYZ) and c:IsRankAbove(0))
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil)
	if #g1<1 or #g2<1 then return false end
	local _,max=g1:GetMaxGroup(Card.GetLevelorRank)
	local _,min=g2:GetMinGroup(Card.GetLevelorRank)
	if chk==0 then return min>max end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil)
	if #g1<1 or #g2<1 then return false end
	local dg,_=g1:GetMaxGroup(Card.GetLevelorRank)
	local tc=dg:GetFirst()
	for tc in aux.Next(dg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function s.dfilter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(s.dfilter2,tp,0,LOCATION_MZONE,1,nil,Card.GetLevelorRankorLink(c))
end
function s.dfilter2(c,lrl)
	return c:IsFaceup() and (c:IsLevelAbove(lrl) or c:IsRankAbove(lrl) or c:IsLinkAbove(lrl))
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.dfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.dfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local dg=Duel.GetMatchingGroup(s.dfilter2,tp,0,LOCATION_MZONE,nil,Card.GetLevelorRankorLink(g:GetFirst()))
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local dg=Duel.GetMatchingGroup(s.dfilter2,tp,0,LOCATION_MZONE,nil,Card.GetLevelorRankorLink(tc))
		Duel.Destroy(dg,REASON_EFFECT)
	end
end

function Card.GetLevelorRank(c)
	if not c:HasLevel() and not (c:IsType(TYPE_XYZ) and c:IsRankAbove(0)) then return false end
	if c:HasLevel() then 
		return c:GetLevel()
	elseif c:IsType(TYPE_XYZ) then 
		return c:GetRank() 
	end
end
function Card.GetLevelorRankorLink(c)
	if not c:HasLevel() and not (c:IsType(TYPE_XYZ) and c:IsRankAbove(0)) and not (c:IsType(TYPE_LINK) and c:IsLinkAbove(0)) then return false end
	if c:HasLevel() then return c:GetLevel()
	elseif c:IsType(TYPE_XYZ) then return c:GetRank()
	elseif c:IsType(TYPE_LINK) then return c:GetLink() end
end