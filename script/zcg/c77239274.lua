--暗黑奥利哈刚之魂(ZCG)
function c77239274.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_CONTROL)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)	
    e1:SetTarget(c77239274.target)
    e1:SetOperation(c77239274.activate)
    c:RegisterEffect(e1)
end
function c77239274.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and chkc:IsControlerCanBeChanged() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,3,nil)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function c77239274.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local tc=g:GetFirst()
    while tc do
        Duel.GetControl(tc,tp)
        tc=g:GetNext()
    end	
    local atk=0
    local def=0		   
    local tc2=g:GetFirst()
    while tc2 do
        local tatk=tc2:GetAttack()
        local tdef=tc2:GetDefense()			
        if (tatk>0 or tdef>0) then
			atk=atk+tatk
			def=def+tdef
		end
        tc2=g:GetNext()
    end
    Duel.Recover(tp,atk+def,REASON_EFFECT)                 
end
