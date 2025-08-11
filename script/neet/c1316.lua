--时间潜行者 监察者(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon procedure
	Link.AddProcedure(c,nil,2,2,s.lcheck)	
	--Multi Attacks
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1,{id,0})
	e0:SetTarget(s.target)
	e0:SetOperation(s.operation)
	c:RegisterEffect(e0)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,{id,1})
	e1:SetCondition(s.discon)
	e1:SetCost(s.discost)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
end
s.listed_series={0x126}
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,1,nil,0x126,lc,sumtype,tp)
end
function s.filter(c,lg)
	return c:IsType(TYPE_XYZ) and lg and lg:IsContains(c)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc,lg) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil,lg)
		and Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_GRAVE,nil)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,lg)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,1-tp,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_GRAVE,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
		local og=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_GRAVE,1,1,nil)
		if #og>0 then
			Duel.Overlay(tc,og)
		end
	end
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Group.CreateGroup()
	local mg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(mg) do
		g:Merge(tc:GetOverlayGroup())
	end
	local g2=g:Filter(function(c,tp) return c:GetOwner()==1-tp end,nil,tp)
	if chk==0 then return #g2>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sg=g2:Select(tp,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end 