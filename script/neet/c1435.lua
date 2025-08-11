--冰结界之龙 圣枪龙(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro Summon procedure
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	--sp sum
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) end)
	e2:SetCountLimit(1,{id,0})
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_SINGLE)
	e2a:SetCode(EFFECT_MATERIAL_CHECK)
	e2a:SetValue(s.valcheck)
	e2a:SetLabelObject(e2)
	c:RegisterEffect(e2a) 
end
function s.valcheck(e,c)
	local ct=ct=c:GetMaterialCount()-1
	e:GetLabelObject():SetLabel(ct)
end
function s.costfilter(c)
	return c:IsAbleToGraveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rt=Duel.GetTargetCount(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	rt=math.min(rt,e:GetLabel())
	if chk==0 then return aux.IceBarrierDiscardCost(s.costfilter,true,1,rt)(e,tp,eg,ep,ev,re,r,rp,0) end
	local cg=aux.IceBarrierDiscardCost(s.costfilter,true,1,rt)(e,tp,eg,ep,ev,re,r,rp,1)
	e:SetLabel(cg)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local eg=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,ct,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if #rg>0 then 
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
	local c=e:GetHandler()
	local g=Duel.GetOperatedGroup()
	if #g>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(#g*300)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
	end
end