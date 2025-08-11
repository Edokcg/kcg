--植物的愤怒 青棉宝宝(ZCG)
function c77239637.initial_effect(c)
    --no damage
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239637,0))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_HAND)
    e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e1:SetCondition(c77239637.con)
    e1:SetCost(c77239637.cost)
    e1:SetOperation(c77239637.op)
    c:RegisterEffect(e1)
	
    --disable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_DISABLE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,LOCATION_SZONE)
    e2:SetTarget(c77239637.distarget)
    c:RegisterEffect(e2)
	
    --destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239637,1))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(c77239637.destg)
    e3:SetOperation(c77239637.desop)
    c:RegisterEffect(e3)	
end
----------------------------------------------------------------------------------
function c77239637.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp and Duel.GetBattleDamage(tp)>0
end
function c77239637.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c77239637.op(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e1:SetOperation(c77239637.damop)
    e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetReset(RESET_PHASE+PHASE_DAMAGE)	
    e2:SetValue(1)
    e2:SetTarget(c77239637.target)		
    Duel.RegisterEffect(e2,tp)
end
function c77239637.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(tp,0)
end
function c77239637.target(e,c)
    return c:IsSetCard(0xa90)
end
----------------------------------------------------------------------------------
function c77239637.distarget(e,c)
    return c~=e:GetHandler() and c:IsType(TYPE_SPELL)
end
----------------------------------------------------------------------------------
function c77239637.filter(c)
    return c:IsAttackAbove(500)
end
function c77239637.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(c77239637.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c77239637.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77239637.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end

