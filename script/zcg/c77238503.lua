--欧贝里斯克之铠甲-护臂
function c77238503.initial_effect(c)
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)
	
    --summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e2)

    --summon success
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetOperation(c77238503.sumsuc)
    c:RegisterEffect(e3)
	
    --destroy
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(77238503,0))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)	
    e4:SetTarget(c77238503.destg)
    e4:SetOperation(c77238503.desop)
    c:RegisterEffect(e4)	
end
-------------------------------------------------------------------------
function c77238503.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
-------------------------------------------------------------------------
function c77238503.dfilter(c,atk)
    return c:IsFaceup() and c:GetAttack()<atk
end
function c77238503.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local atk=e:GetHandler():GetAttack()
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c77238503.dfilter(chkc,atk) end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c77238503.dfilter,tp,0,LOCATION_MZONE,1,1,nil,atk)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77238503.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetAttack()<e:GetHandler():GetAttack() then
        Duel.SendtoGrave(tc,REASON_EFFECT)
		Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
    end
end
