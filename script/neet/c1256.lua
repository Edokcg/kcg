--闪刀术式-跃迁引擎
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)   
end
function s.cfilter(c)
	return c:GetSequence()<5
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.xyzfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x1115)
end
function s.xyzfilter2(c)
	return c:IsFaceup() and c:IsAbleToChangeControler()
		and not c:IsType(TYPE_TOKEN) 
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.xyzfilter1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(s.xyzfilter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local g1=Duel.SelectTarget(tp,s.xyzfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local g2=Duel.SelectTarget(tp,s.xyzfilter2,tp,0,LOCATION_MZONE,1,1,g1:GetFirst())
	if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 then
		e:SetCategory(CATEGORY_CONTROL+CATEGORY_REMOVE)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=2 then return end
	local tc=g:GetFirst()
	local xc=g:GetNext()
	if xc==e:GetLabelObject() then tc,xc=xc,tc end
	if not tc:IsImmuneToEffect(e) and not xc:IsImmuneToEffect(e) then
		local og=xc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc,xc)
	end
	if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 and Duel.SelectYesNo(tp,aux.Stringid(id,0))
	then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
		if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
