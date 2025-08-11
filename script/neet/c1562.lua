--铠装合体 阿修罗霍普雷(neet)
Duel.LoadCardScript("c56840427.lua")
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,5,3)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(Cost.DetachFromSelf(1))
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1,false,EFFECT_MARKER_DETACH_XMAT) 
	--Negate Spell/Trap Card or effect
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.negcon)
	e5:SetTarget(s.negtg)
	e5:SetOperation(s.negop)
	c:RegisterEffect(e5)   
end
s.xyz_number=39
s.listed_series={0x107e}
function s.filter(c,sc,tp)
	return c:IsSetCard(0x107e) and c:IsMonster() and c:IsCanBeXyzMaterial(sc,tp,REASON_EFFECT)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0x13,0,1,nil,e:GetHandler(),tp) end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil,e:GetHandler(),rp)
	if #g>0 then
		Duel.PossibleOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
	local og=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.ovfilter),tp,0x13,0,nil,c,tp)
	if #og>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=og:Select(tp,1,2,nil)
		if #g>0 then
			Duel.Overlay(c,g,true)
		end
	end
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		 and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function s.ovfilter(c)
	return c:IsSetCard(0x107e) and c:IsAbleToGrave()
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup():Filter(s.ovfilter,nil)
	if chk==0 then return #og>0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup():Filter(s.ovfilter,nil)
	if c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) and #og>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=og:Select(tp,1,1,nil):GetFirst()
		if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
			if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
				Duel.Destroy(eg,REASON_EFFECT)
			end
			local eff=tc:GetCardEffect(75402014)
			if c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and eff and eff:GetValue()(c,tc,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				eff:GetOperation()(tc,eff:GetLabelObject(),tp,c)
			end
		end
	end
end