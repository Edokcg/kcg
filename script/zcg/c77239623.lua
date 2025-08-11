--植物的愤怒 三齿花
function c77239623.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_CONTROL)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)	
    e1:SetCondition(c77239623.con)
    e1:SetTarget(c77239623.target)
    e1:SetOperation(c77239623.activate)
    c:RegisterEffect(e1)	
end
-------------------------------------------------------------------
function c77239623.con(e,c)
    if c==nil then return true end
    return Duel.GetMatchingGroupCount(Card.IsSetCard,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil,0xa90)==1
end
function c77239623.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and chkc:IsControlerCanBeChanged() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,3,nil)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function c77239623.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local tc=g:GetFirst()
    while tc do
        Duel.GetControl(tc,tp)
	    local e1=Effect.CreateEffect(tc)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)	
        tc=g:GetNext()
    end	              
end



