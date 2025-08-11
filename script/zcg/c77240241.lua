--奥西里斯之雷斧战士 （ZCG）
function c77240241.initial_effect(c)
	 --summon & set with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77240241,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c77240241.ntcon)
	e1:SetOperation(c77240241.ntop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
---
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98710336,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c77240241.tg)
	e3:SetOperation(c77240241.op)
	c:RegisterEffect(e3)

	--抗性
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCode(EFFECT_IMMUNE_EFFECT)
    e11:SetValue(c77240241.efilter11)
    c:RegisterEffect(e11)
    --disable effect
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e12:SetCode(EVENT_CHAIN_SOLVING)
    e12:SetRange(LOCATION_MZONE)
    e12:SetOperation(c77240241.disop12)
    c:RegisterEffect(e12)
    --disable
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD)
    e13:SetCode(EFFECT_DISABLE)
    e13:SetRange(LOCATION_MZONE)
    e13:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e13:SetTarget(c77240241.distg12)
    c:RegisterEffect(e13)
    --self destroy
    local e14=Effect.CreateEffect(c)
    e14:SetType(EFFECT_TYPE_FIELD)
    e14:SetCode(EFFECT_SELF_DESTROY)
    e14:SetRange(LOCATION_MZONE)
    e14:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e14:SetTarget(c77240241.distg12)
    c:RegisterEffect(e14)
end
function c77240241.cofilter(c)
return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c77240241.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chkc then return  c77240241.cofilter(chkc) and chkc:GetLocation()==LOCATION_GRAVE end
if chk==0 then return Duel.IsExistingTarget(c77240241.cofilter,tp,LOCATION_GRAVE,0,1,nil) end 
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectTarget(tp,c77240241.cofilter,tp,LOCATION_GRAVE,0,1,1,nil)
Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,LOCATION_GRAVE)
end
function c77240241.op(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local tc=Duel.GetFirstTarget()
if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then 
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=1 then return end
		   local atk=tc:GetAttack()
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(atk/2)
			c:RegisterEffect(e2)
end
end
function c77240241.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c77240241.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	--change base attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(1700)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(1600)
	c:RegisterEffect(e2)
end

function c77240241.efilter11(e,te)
    return te:GetHandler():IsSetCard(0xa60)
end
function c77240241.disop12(e,tp,eg,ep,ev,re,r,rp)
    if (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70)) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77240241.distg12(e,c)
    return c:GetCardTargetCount()>0 and (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70))
        and c:GetCardTarget():IsContains(e:GetHandler())
end