--女子佣兵 封魂兔(ZCG)
function c77239516.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetCode(EVENT_BATTLE_DAMAGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c77239516.skipcon)	
    e1:SetTarget(c77239516.rectg)
    e1:SetOperation(c77239516.recop)
    c:RegisterEffect(e1)
end
function c77239516.skipcon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp
end
function c77239516.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,ev/100)
end
function c77239516.recop(e,tp,eg,ep,ev,re,r,rp)
    Duel.DiscardDeck(1-tp,ev/100,REASON_EFFECT)
end
