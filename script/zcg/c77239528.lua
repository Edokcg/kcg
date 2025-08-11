--女子佣兵 樱刃(ZCG)
function c77239528.initial_effect(c)
    --battle target
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(aux.imval1)
    e1:SetCondition(c77239528.con)	
    c:RegisterEffect(e1)

    --battle
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetCondition(c77239528.indescon)
    e2:SetOperation(c77239528.indesop)
    c:RegisterEffect(e2)	
end
------------------------------------------------------------------
function c77239528.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xa80) and c:GetCode()~=77239528
end
function c77239528.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c77239528.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
------------------------------------------------------------------
function c77239528.indescon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c77239528.indesop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetAttacker()==e:GetHandler() then
        local bc=e:GetHandler():GetBattleTarget()
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e1:SetValue(1)
        e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
        bc:RegisterEffect(e1,true)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_UPDATE_ATTACK)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        e2:SetValue(c77239528.atkval)
        bc:RegisterEffect(e2)
    end	
	if Duel.GetAttackTarget()==e:GetHandler() then
	    local tc=Duel.GetAttacker()
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e3:SetValue(1)
        e3:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
        tc:RegisterEffect(e3,true)
        local e4=Effect.CreateEffect(e:GetHandler())
        e4:SetType(EFFECT_TYPE_SINGLE)
        e4:SetCode(EFFECT_UPDATE_ATTACK)
        e4:SetReset(RESET_EVENT+0x1fe0000)
        e4:SetValue(c77239528.atkval)
        tc:RegisterEffect(e4)				
	end
end
function c77239528.atkval(e,c)
    return c:GetAttack()/-2
end

