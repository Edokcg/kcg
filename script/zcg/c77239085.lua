--黑魔导·蓝将
function c77239085.initial_effect(c)
	--特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c77239085.spcon)
	e1:SetOperation(c77239085.spop)
	c:RegisterEffect(e1)
	
	--控制
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_CONTROL)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)	
    e2:SetTarget(c77239085.target)
    e2:SetOperation(c77239085.activate)
    c:RegisterEffect(e2)
end
--------------------------------------------------------------------------
function c77239085.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0		
end
function c77239085.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(-500)
    e1:SetReset(RESET_EVENT+0xff0000)
    c:RegisterEffect(e1)
end
--------------------------------------------------------------------------
function c77239085.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c77239085.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp,PHASE_END,1) then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DIRECT_ATTACK)
        e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
    end
end