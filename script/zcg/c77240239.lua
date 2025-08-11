--奥西里斯之孤城斗士 （ZCG）
function c77240239.initial_effect(c)
	 local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(c77240239.val)
			c:RegisterEffect(e1)
---
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77240239,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c77240239.tg)
	e2:SetOperation(c77240239.op)
	c:RegisterEffect(e2)

	--抗性
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCode(EFFECT_IMMUNE_EFFECT)
    e11:SetValue(c77240239.efilter11)
    c:RegisterEffect(e11)
    --disable effect
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e12:SetCode(EVENT_CHAIN_SOLVING)
    e12:SetRange(LOCATION_MZONE)
    e12:SetOperation(c77240239.disop12)
    c:RegisterEffect(e12)
    --disable
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD)
    e13:SetCode(EFFECT_DISABLE)
    e13:SetRange(LOCATION_MZONE)
    e13:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e13:SetTarget(c77240239.distg12)
    c:RegisterEffect(e13)
    --self destroy
    local e14=Effect.CreateEffect(c)
    e14:SetType(EFFECT_TYPE_FIELD)
    e14:SetCode(EFFECT_SELF_DESTROY)
    e14:SetRange(LOCATION_MZONE)
    e14:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e14:SetTarget(c77240239.distg12)
    c:RegisterEffect(e14)
end
function c77240239.valfilter(c)
return  c:IsSetCard(0xa100)
end
function c77240239.val(e,c)
return Duel.GetMatchingGroupCount(c77240239.valfilter,e:GetHandler():GetOwner(),LOCATION_GRAVE,0,nil)*700
end
function c77240239.cofilter(c)
return c:IsSetCard(0xa100) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(7) and c:IsAbleToRemove()
end
function c77240239.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chkc then return  c77240239.cofilter(chkc) and chkc:GetLocation()==LOCATION_GRAVE end
if chk==0 then return Duel.IsExistingTarget(c77240239.cofilter,tp,LOCATION_GRAVE,0,1,nil) end 
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectTarget(tp,c77240239.cofilter,tp,LOCATION_GRAVE,0,1,1,nil)
Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,LOCATION_GRAVE)
end
function c77240239.op(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local tc=Duel.GetFirstTarget()--diao yong g
if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then 
  if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=1 then return end
   local code=tc:GetCode()
		 c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
	 local e1=Effect.CreateEffect(c)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		   e1:SetCode(EFFECT_CHANGE_CODE)
		  e1:SetValue(code)
		  c:RegisterEffect(e1)
end
end

function c77240239.efilter11(e,te)
    return te:GetHandler():IsSetCard(0xa60)
end
function c77240239.disop12(e,tp,eg,ep,ev,re,r,rp)
    if (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70)) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77240239.distg12(e,c)
    return c:GetCardTargetCount()>0 and (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70))
        and c:GetCardTarget():IsContains(e:GetHandler())
end