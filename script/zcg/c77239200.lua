--奥利哈刚 达姿前世(ZCG)
function c77239200.initial_effect(c)  
    --攻击力
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c77239200.adval)
    c:RegisterEffect(e1)
    --守备力
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c77239200.adval)
    c:RegisterEffect(e2)
    
    --代替破坏
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetTarget(c77239200.desreptg)
    c:RegisterEffect(e3)
	
	--战斗伤害为0
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
end
---------------------------------------------------------------------------
function c77239200.filter(c)
    return c:IsFaceup() and c:GetCode()~=77239200
end
function c77239200.adval(e,c)
    local g=Duel.GetMatchingGroup(c77239200.filter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
    if g:GetCount()==0 then
        return 0
    else
      local tc=g:GetMaxGroup(Card.GetAttack):GetFirst()
        if tc:GetAttack()<=0 then return 0
        else return tc:GetAttack()*2 end
    end
end
---------------------------------------------------------------------------
function c77239200.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return not c:IsReason(REASON_REPLACE)
        and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
    if Duel.SelectYesNo(tp,aux.Stringid(77239200,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
        local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
        Duel.SendtoGrave(g,REASON_EFFECT+REASON_REPLACE)
        return true
    else return false end
end

