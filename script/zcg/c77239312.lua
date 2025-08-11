--殉道者 狱炼魔王(ZCG)
function c77239312.initial_effect(c)
    --通常召唤
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e1:SetCondition(c77239312.ttcon)
    e1:SetOperation(c77239312.ttop)
    --e1:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_LIMIT_SET_PROC)
    e2:SetCondition(c77239312.setcon)
    c:RegisterEffect(e2)
    --祭品限制
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_TRIBUTE_LIMIT)
    e3:SetValue(c77239312.tlimit)
    c:RegisterEffect(e3)	
	
    --无效发动
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(77239312,2))
    e4:SetCategory(CATEGORY_NEGATE)
    e4:SetType(EFFECT_TYPE_QUICK_F)
    e4:SetCode(EVENT_CHAINING)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c77239312.codisable)
    e4:SetTarget(c77239312.tgdisable)
    e4:SetOperation(c77239312.opdisable)
    c:RegisterEffect(e4)	
	

	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239312.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239312.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239312.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77239312.disop)
    c:RegisterEffect(e13)
end
-----------------------------------------------------------------------------
function c77239312.ttcon(e,c,minc)
    if c==nil then return true end
    return minc<=3 and Duel.CheckTribute(c,3)
end
function c77239312.ttop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectTribute(tp,c,3,3)
    c:SetMaterial(g)
    Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
    local atk=g:GetSum(Card.GetAttack)
    local def=g:GetSum(Card.GetDefense)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_ATTACK)
    e1:SetValue(atk)
    e1:SetReset(RESET_EVENT+0xff0000)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SET_DEFENSE)
    e2:SetValue(def)
    c:RegisterEffect(e2)	
end
function c77239312.setcon(e,c,minc)
    if not c then return true end
    return false
end
function c77239312.tlimit(e,c)
    return not c:IsSetCard(0xa60)
end
-----------------------------------------------------------------------------
function c77239312.codisable(e,tp,eg,ep,ev,re,r,rp)
    return (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER))
        and Duel.IsChainNegatable(ev) and ep~=tp
end
function c77239312.tgdisable(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c77239312.opdisable(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsFaceup() or c:GetDefense()<500 or c:GetAttack()< 500 or not c:IsRelateToEffect(e) or Duel.GetCurrentChain()~=ev+1 or c:IsStatus(STATUS_BATTLE_DESTROYED) then
        return
    end
    if Duel.NegateActivation(ev) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-500)
        c:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetProperty(EFFECT_FLAG_COPY_INHERIT)
        e2:SetReset(RESET_EVENT+0x1ff0000)
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        e2:SetValue(-500)
        c:RegisterEffect(e2)
    end
end
-----------------------------------------------------------------------------
function c77239312.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239312.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239312.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end
