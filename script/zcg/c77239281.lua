--奥利哈刚 死之计数器(ZCG)
function c77239281.initial_effect(c)
    c:EnableCounterPermit(0xa11)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	
    --damage
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_RECOVER)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_BATTLE_DESTROYED)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCondition(c77239281.ccon)
    e2:SetTarget(c77239281.addtg)
    e2:SetOperation(c77239281.addop)
    c:RegisterEffect(e2)

    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(77239281,2))
    e4:SetCategory(CATEGORY_REMOVE)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCost(c77239281.cost)
    e4:SetOperation(c77239281.operation)
    c:RegisterEffect(e4)
end
-----------------------------------------------------------------------------------
function c77239281.ccon(e,tp,eg,ep,ev,re,r,rp)
    local des=eg:GetFirst()
    local rc=des:GetReasonCard()
    return des:IsType(TYPE_MONSTER) and rc:IsRelateToBattle() and rc:IsSetCard(0xa50) and rc:GetControler()==tp
end
function c77239281.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xa11)
end
function c77239281.addop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0xa11,1)
    end
end
-----------------------------------------------------------------------------------
function c77239281.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xa11,1,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0xa11,1,REASON_COST)
end
function c77239281.operation(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
    local g2=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
    local opt=0
    if g1:GetCount()>0 and g2:GetCount()>0 then
        opt=Duel.SelectOption(tp,aux.Stringid(77239281,0),aux.Stringid(77239281,1))
    elseif g1:GetCount()>0 then
        opt=Duel.SelectOption(tp,aux.Stringid(77239281,0))
    elseif g2:GetCount()>0 then
        opt=Duel.SelectOption(tp,aux.Stringid(77239281,0))+1
    else return end
    if opt==0 then	
	    local dg=g1:RandomSelect(tp,1)
        Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
    else
        local dg=g2:RandomSelect(tp,1)
        Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)		
    end
end
