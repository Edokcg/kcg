--三国传-赵云
function c77238660.initial_effect(c)
    --actlimit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_CANNOT_ACTIVATE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,1)
    e3:SetValue(c77238660.aclimit)
    e3:SetCondition(c77238660.actcon)
    c:RegisterEffect(e3)
	
	--damage
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_DAMAGE_STEP_END)
    e1:SetCondition(c77238660.damcon)
    e1:SetTarget(c77238660.damtg)
    e1:SetOperation(c77238660.damop)
    c:RegisterEffect(e1)
end
---------------------------------------------------------------------
function c77238660.aclimit(e,re,tp)
    return re:GetHandler():IsType(TYPE_MONSTER)
end
function c77238660.actcon(e)
    return Duel.GetAttacker()==e:GetHandler()
end
---------------------------------------------------------------------
function c77238660.damcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler()==Duel.GetAttacker()
end
function c77238660.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(e:GetHandler():GetAttack()/2)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,e:GetHandler():GetAttack()/2)
end
function c77238660.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end

