--迅捷兽人
function c77238993.initial_effect(c)
    --damage
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(35809262,0))
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EVENT_BATTLE_DESTROYING)
    e2:SetCondition(c77238993.damcon)
    e2:SetTarget(c77238993.damtg)
    e2:SetOperation(c77238993.damop)
    c:RegisterEffect(e2)
	
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetValue(c77238993.afilter)
    c:RegisterEffect(e3)
end
----------------------------------------------------------------------
function c77238993.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c77238993.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local bc=e:GetHandler():GetBattleTarget()
    Duel.SetTargetCard(bc)
    local dam=bc:GetAttack()
    if dam<0 then dam=0 end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(dam)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c77238993.damop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
        local dam=tc:GetAttack()
        if dam<0 then dam=0 end
        Duel.Damage(p,dam,REASON_EFFECT)
    end
end
----------------------------------------------------------------------
function c77238993.afilter(e,re)
    return re:GetHandler():IsType(TYPE_QUICKPLAY)
end
