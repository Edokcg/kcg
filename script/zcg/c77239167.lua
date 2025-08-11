--黑暗大法师的链结
function c77239167.initial_effect(c)
    --unaffectable
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetValue(c77239167.efilter)
    c:RegisterEffect(e1)

    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e2:SetRange(LOCATION_MZONE)	
    c:RegisterEffect(e2)	

    --battle target
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(aux.imval1)
    c:RegisterEffect(e3)

    --equip
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetDescription(aux.Stringid(77239167,0))
    e4:SetCategory(CATEGORY_EQUIP)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(c77239167.eqtg)
    e4:SetOperation(c77239167.eqop)
    c:RegisterEffect(e4)

    --win
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_ADJUST)
    e5:SetRange(LOCATION_MZONE)
    e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e5:SetOperation(c77239167.winop)
    c:RegisterEffect(e5)
end
------------------------------------------------------------------
function c77239167.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
------------------------------------------------------------------
function c77239167.filter(c)
    return c:IsSetCard(0x40) and c:IsType(TYPE_MONSTER) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c77239167.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c77239167.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED)
end
function c77239167.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectMatchingCard(tp,c77239167.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        if not Duel.Equip(tp,tc,c,true) then return end
        local e1=Effect.CreateEffect(c)
        e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(c77239167.eqlimit)
        tc:RegisterEffect(e1)
    end
end
------------------------------------------------------------------
function c77239167.eqlimit(e,c)
    return e:GetOwner()==c
end
function c77239167.cfilter3(c)
    return c:IsFaceup() and c:IsSetCard(0x40)
end
function c77239167.winop(e,tp,eg,ep,ev,re,r,rp)
    local WIN_REASON_EXODIA = 0x10
    local g=Duel.GetMatchingGroup(c77239167.cfilter3,tp,LOCATION_SZONE,0,e:GetHandler())
    if g:GetClassCount(Card.GetCode)==5 then
        Duel.Win(tp,WIN_REASON_EXODIA)
    end
end


