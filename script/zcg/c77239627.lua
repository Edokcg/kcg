--植物的愤怒 蓝花炮
function c77239627.initial_effect(c)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)	
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetRange(LOCATION_MZONE)	
    e1:SetCountLimit(1)
    e1:SetCondition(c77239627.con)
    e1:SetTarget(c77239627.target)
    e1:SetOperation(c77239627.activate)
    c:RegisterEffect(e1)
end
------------------------------------------------------------------
function c77239627.con(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer()
end
function c77239627.filter(c)
    return c:IsFaceup() and c:GetAttack()~=4000
end
function c77239627.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(c77239627.filter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c77239627.filter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end
function c77239627.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local atk=tc:GetAttack()	
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        if atk<4000 then
		    local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            e1:SetValue(atk/2)
            tc:RegisterEffect(e1)
		else		
		    local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            e1:SetValue(1800)
            tc:RegisterEffect(e1) 
		end
    end
end


