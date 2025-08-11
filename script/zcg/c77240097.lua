--深山食人虫
function c77240097.initial_effect(c)
    --flip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(16226786,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
    e1:SetTarget(c77240097.target)
    e1:SetOperation(c77240097.operation)
    c:RegisterEffect(e1)
end
function c77240097.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,2,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77240097.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    local ct=Duel.Destroy(g,REASON_EFFECT)
    if ct>0 then
	    Duel.Damage(1-tp,ct*500,REASON_EFFECT)	
	end
end