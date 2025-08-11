--女子佣兵 小魔牙(ZCG)
function c77239520.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetOperation(c77239520.spop)
    c:RegisterEffect(e1)
	
    --Activate
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)	
    e2:SetTarget(c77239520.target)
    e2:SetOperation(c77239520.activate)
    c:RegisterEffect(e2)	
end
----------------------------------------------------------------------
function c77239520.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    c:RegisterEffect(e1)	
end
----------------------------------------------------------------------
function c77239520.filter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c77239520.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c77239520.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c77239520.filter,tp,0,LOCATION_SZONE,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c77239520.filter,tp,0,LOCATION_SZONE,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77239520.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetReset(RESET_EVENT+0x1ff0000)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(-700)
    c:RegisterEffect(e1)	
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and tc:IsType(TYPE_TRAP) then 	    
		Duel.Damage(1-tp,1000,REASON_EFFECT)              
    end
end
