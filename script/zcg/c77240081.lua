--命悬一线
function c77240081.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(37209439,1))
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)	
    e2:SetCondition(c77240081.condition)
    e2:SetTarget(c77240081.target)
    e2:SetOperation(c77240081.activate)
    c:RegisterEffect(e2)	
end
function c77240081.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetBattleDamage(tp)>=1000
end
function c77240081.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end
function c77240081.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Damage(1-tp,1000,REASON_EFFECT)
end
