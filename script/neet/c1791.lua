--变形斗士·扫地机(neet)
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetLabel(4)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.dseop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetLabel(8)
	c:RegisterEffect(e2)
end
s.listed_series={0x26}
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct==4 then
		return not e:GetHandler():IsDisabled() and e:GetHandler():IsAttackPos()
	elseif ct==8 then
		return not e:GetHandler():IsDisabled() and e:GetHandler():IsDefensePos()
	end
	return false
end
function s.filter(c,tp,loc)
	local g=c:GetColumnGroup()
	return c:IsSetCard(0x26) and Duel.IsExistingMatchingCard(s.cfilter,tp,0,loc,1,nil,g)
end
function s.cfilter(c,g)
	return g:IsContains(c)
end
function s.desfilter(c,tp,loc)
	return c:IsControler(1-tp) and c:IsLocation(loc)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local loc=e:GetLabel()
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil,tp,loc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,99,nil,tp,loc)
	local g=Group.CreateGroup()
	for tc in aux.Next(sg) do
		local dg=tc:GetColumnGroup():Filter(s.desfilter,nil,tp,loc)
		g:Merge(dg)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.dseop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetTargetCards(e)
	local g=Group.CreateGroup()
	for tc in aux.Next(sg) do
		local dg=tc:GetColumnGroup():Filter(s.desfilter,nil,tp,e:GetLabel())
		g:Merge(dg)
	end
	Duel.Destroy(g,REASON_EFFECT)
end