--奥西里斯之伤害爆破器 （ZCG）
function c77240254.initial_effect(c)
	  c:EnableCounterPermit(0xa11)
		  --activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--add
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c77240254.adcon)
	e3:SetOperation(c77240254.adop)
	c:RegisterEffect(e3)
  --destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77240254,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c77240254.descost)
	e2:SetTarget(c77240254.destg)
	e2:SetOperation(c77240254.desop)
	c:RegisterEffect(e2)
--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77240254,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c77240254.descost2)
	e4:SetTarget(c77240254.destg2)
	e4:SetOperation(c77240254.desop2)
	c:RegisterEffect(e4)
--Remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77240254,2))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c77240254.descost3)
	e4:SetTarget(c77240254.destg3)
	e4:SetOperation(c77240254.desop3)
	c:RegisterEffect(e4)
--Remove
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77240254,3))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCost(c77240254.descost4)
	e5:SetOperation(c77240254.desop4)
	c:RegisterEffect(e5)

	--抗性
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCode(EFFECT_IMMUNE_EFFECT)
    e11:SetValue(c77240254.efilter11)
    c:RegisterEffect(e11)
    --disable effect
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e12:SetCode(EVENT_CHAIN_SOLVING)
    e12:SetRange(LOCATION_MZONE)
    e12:SetOperation(c77240254.disop12)
    c:RegisterEffect(e12)
    --disable
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD)
    e13:SetCode(EFFECT_DISABLE)
    e13:SetRange(LOCATION_MZONE)
    e13:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e13:SetTarget(c77240254.distg12)
    c:RegisterEffect(e13)
    --self destroy
    local e14=Effect.CreateEffect(c)
    e14:SetType(EFFECT_TYPE_FIELD)
    e14:SetCode(EFFECT_SELF_DESTROY)
    e14:SetRange(LOCATION_MZONE)
    e14:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e14:SetTarget(c77240254.distg12)
    c:RegisterEffect(e14)
end
function c77240254.descost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xa11,15,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xa11,15,REASON_COST)
end
function c77240254.desop4(e,tp,eg,ep,ev,re,r,rp)
	 Duel.Win(tp,0x17)
end
function c77240254.cfilter2(c,tp,rp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(1-tp) and ((c:IsReason(REASON_BATTLE) and Duel.GetAttacker():IsControler(tp))
	or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==tp))
end
function c77240254.adcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77240254.cfilter2,1,nil,tp,rp)
end
function c77240254.adop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xa11,1)
end
function c77240254.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xa11,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xa11,3,REASON_COST)
end
function c77240254.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c77240254.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c77240254.filter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c77240254.filter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77240254.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c77240254.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c77240254.descost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xa11,5,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xa11,5,REASON_COST)
end
function c77240254.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77240254.desop2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT) 
end
function c77240254.descost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xa11,8,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xa11,8,REASON_COST)
end
function c77240254.destg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
function c77240254.desop3(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end

function c77240254.efilter11(e,te)
    return te:GetHandler():IsSetCard(0xa60)
end
function c77240254.disop12(e,tp,eg,ep,ev,re,r,rp)
    if (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70)) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77240254.distg12(e,c)
    return c:GetCardTargetCount()>0 and (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70))
        and c:GetCardTarget():IsContains(e:GetHandler())
end