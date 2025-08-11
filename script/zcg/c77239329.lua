--殉道者 火炎焱君
function c77239329.initial_effect(c)
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c77239329.val)
    c:RegisterEffect(e1)

    --copy
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239329,0))
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c77239329.cost)
    e2:SetTarget(c77239329.target)
    e2:SetOperation(c77239329.operation)
    c:RegisterEffect(e2)	
	
	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239329.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239329.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239329.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77239329.disop)
    c:RegisterEffect(e13)
end
---------------------------------------------------------------------
function c77239329.val(e,c)
    return Duel.GetMatchingGroupCount(c77239329.filter,c:GetControler(),LOCATION_GRAVE,0,nil)*500
end
function c77239329.filter(c)
    return c:IsSetCard(0xa60) and c:IsType(TYPE_MONSTER)
end
---------------------------------------------------------------------
function c77239329.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetFlagEffect(77239329)==0 end
    e:GetHandler():RegisterFlagEffect(77239329,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c77239329.filter(c)
    return c:IsType(TYPE_EFFECT) and c:IsSetCard(0xa60) and c:IsLevelBelow(7) and c:IsAbleToRemove()
end
function c77239329.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c77239329.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c77239329.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,c77239329.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c77239329.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
        if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=1 then return end
        local code=tc:GetOriginalCode()
        local ba=tc:GetBaseAttack()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        e1:SetCode(EFFECT_CHANGE_CODE)
        e1:SetValue(code)
        c:RegisterEffect(e1)
        local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
        local e3=Effect.CreateEffect(c)
        e3:SetDescription(aux.Stringid(77239329,1))
        e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e3:SetCode(EVENT_PHASE+PHASE_END)
        e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e3:SetCountLimit(1)
        e3:SetRange(LOCATION_MZONE)
        e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        e3:SetLabel(cid)
        e3:SetLabelObject(e2)
        e3:SetOperation(c77239329.rstop)
        c:RegisterEffect(e3)
    end
end
function c77239329.rstop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local cid=e:GetLabel()
    c:ResetEffect(cid,RESET_COPY)
    local e2=e:GetLabelObject()
    --e2:Reset()
    Duel.HintSelection(Group.FromCards(c))
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
---------------------------------------------------------------------------------
function c77239329.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239329.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239329.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end
