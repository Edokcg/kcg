--奥利哈刚 光之创造神
function c77239290.initial_effect(c)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239290.spcon)
    e1:SetOperation(c77239290.spop)
    c:RegisterEffect(e1)
	
    --summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e2)
	
	--
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetValue(c77239290.efilter)
    c:RegisterEffect(e3)

    --destroy
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(77239290,0))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetTarget(c77239290.destg)
    e4:SetOperation(c77239290.desop)
    c:RegisterEffect(e4)
	
	--[[
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_CHANGE_DAMAGE)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(1,0)
    e5:SetValue(c77239290.damval)
    c:RegisterEffect(e5)	
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e6:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e6:SetOperation(c77239290.op)
    c:RegisterEffect(e6)]]
	
	--玩家不会受到战斗伤害
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(1,0)
    e5:SetValue(0)
    c:RegisterEffect(e5)

    --玩家不会受到效果伤害
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_CHANGE_DAMAGE)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(1,0)
    e6:SetValue(c77239290.damval)
    c:RegisterEffect(e6)
	
    --Cost Change
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetCode(EFFECT_LPCOST_CHANGE)
    e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e7:SetRange(LOCATION_MZONE)
    e7:SetTargetRange(1,0)
    e7:SetValue(c77239290.costchange)
    c:RegisterEffect(e7)

    --destroy
    local e8=Effect.CreateEffect(c)
    e8:SetCategory(CATEGORY_DESTROY)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e8:SetCode(EVENT_BATTLE_START)
    e8:SetTarget(c77239290.destg1)
    e8:SetOperation(c77239290.desop1)
    c:RegisterEffect(e8)

	--
    local e9=Effect.CreateEffect(c)
    e9:SetCategory(CATEGORY_REMOVE)
    e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e9:SetCode(EVENT_TO_GRAVE)
    e9:SetTarget(c77239290.target)
    e9:SetOperation(c77239290.operation)
    c:RegisterEffect(e9)	
end
-----------------------------------------------------------------
function c77239290.cfilter(c,code)
    return c:IsCode(code) and c:IsAbleToRemoveAsCost()
end
function c77239290.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
        and Duel.IsExistingMatchingCard(c77239290.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,77239231)
        and Duel.IsExistingMatchingCard(c77239290.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,77239232)
        and Duel.IsExistingMatchingCard(c77239290.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,77239233)
end
function c77239290.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g1=Duel.SelectMatchingCard(tp,c77239290.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,77239231)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g2=Duel.SelectMatchingCard(tp,c77239290.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,77239232)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g3=Duel.SelectMatchingCard(tp,c77239290.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,77239233)
    g1:Merge(g2)
    g1:Merge(g3)
    Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
-----------------------------------------------------------------
function c77239290.efilter(e,re,rp)
    return re:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
-----------------------------------------------------------------
function c77239290.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_SZONE,1,nil) or Duel.GetLP(tp)<8000 end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77239290.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,nil)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_RULE)
    end
	if Duel.GetLP(tp)<8000 then
	    Duel.SetLP(tp,8000)
	end
end
-----------------------------------------------------------------

function c77239290.damval(e,re,val,r,rp,rc)
    if bit.band(r,REASON_EFFECT)~=0 then return 0 end
    return val
end

--[[function c77239290.damval(e,re,val,r,rp,rc)
    if bit.band(r,REASON_EFFECT)~=0 then return 0 end
    return val
end
function c77239290.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(ep,0)
end]]
-----------------------------------------------------------------
function c77239290.costchange(e,re,rp,val)
    if re and re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and not re:GetHandler():IsCode(9236985) then
        return 0
    else
        return val
    end
end
-----------------------------------------------------------------
function c77239290.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tc=Duel.GetAttacker()
    if tc==c then tc=Duel.GetAttackTarget() end
    if chk==0 then return tc and tc:IsFaceup() and tc:IsAttribute(ATTRIBUTE_DARK) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c77239290.desop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttacker()
    if tc==c then tc=Duel.GetAttackTarget() end
    if tc:IsRelateToBattle() then
        Duel.Destroy(tc,REASON_RULE,LOCATION_REMOVED)
    end
end
-----------------------------------------------------------------
function c77239290.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,nil) end
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c77239290.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
    Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end

