--CF-M-60STD 狙击枪(ZCG)
function c77238705.initial_effect(c)
    --disable spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    c:RegisterEffect(e1)
	
    --battle destroyed
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_BATTLE_DESTROYED)
    e2:SetTarget(c77238705.target)
    e2:SetOperation(c77238705.operation)
    c:RegisterEffect(e2)	
end

function c77238705.filter(c)
    return c:IsDestructable()
end
function c77238705.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c77238705.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c77238705.filter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c77238705.filter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end
function c77238705.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        local atk=tc:GetAttack()
        if atk<0 then atk=0 end
        local val=Duel.Damage(tp,atk,REASON_EFFECT)
        if val>0 and Duel.GetLP(tp)>0 then
            Duel.BreakEffect()
            Duel.Damage(1-tp,val,REASON_EFFECT)
        end
    end
end