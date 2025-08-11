--BT黑羽 暗羽魔灵(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	if aux.IsKCGScript then
		Fusion.AddProcMixN(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,0xa33),2)
	else
		aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xa33),2,true)
	end
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
  --destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.descost)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(s.target)
	e4:SetOperation(s.activate)
	c:RegisterEffect(e4)
end
function s.filter(c)
	return c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,2,nil) end
end
function s.cfilter(c,e,tp)
	return c:IsSetCard(0x33) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil)
	if #g>1 then
		local hg=g:RandomSelect(tp,2)
		Duel.SendtoHand(hg,nil,REASON_EFFECT)
		local gg=Duel.GetOperatedGroup()
		Duel.ConfirmCards(1-tp,gg)
		local sg=gg:Filter(s.cfilter,nil,e,tp)
		if sg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
			if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then ft=1 end
			local sdg=sg:Select(tp,ft,ft,nil)
			Duel.SpecialSummon(sdg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function s.filter2(c)
	return c:IsAbleToGraveAsCost()
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_HAND,0,1,nil) end
	local sg=Duel.GetTargetCount(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local hg=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_HAND,0,1,sg,nil)
	local ct=Duel.SendtoGrave(hg,REASON_COST)
	e:SetLabel(ct) 
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local number=e:GetLabel()
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,number,number,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g then return end
	local dg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(dg,REASON_EFFECT)
end