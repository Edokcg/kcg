--邪心教义-疑
function c77239015.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetTarget(c77239015.target)
    e1:SetOperation(c77239015.operation)
    c:RegisterEffect(e1)
    --Equip limit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_EQUIP_LIMIT)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetValue(c77239015.eqlimit)
    c:RegisterEffect(e3)

	--丢硬币
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239015,0))
    e2:SetCategory(CATEGORY_COIN)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)	
    e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)	
	e2:SetCondition(c77239015.condition)	
    e2:SetTarget(c77239015.target2)
    e2:SetOperation(c77239015.activate)
    c:RegisterEffect(e2)
	
	--除外
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c77239015.bantg)
	e4:SetOperation(c77239015.banop)
	c:RegisterEffect(e4)	
end
-------------------------------------------------------------------
function c77239015.filter(c)
    return c:IsFaceup()
end
function c77239015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c77239015.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c77239015.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c77239015.filter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c77239015.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp,e:GetHandler(),tc)
    end
end
function c77239015.eqlimit(e,c)
	return e:GetHandlerPlayer()==c:GetControler()
end
-------------------------------------------------------------------
function c77239015.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c77239015.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c77239015.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local coin=Duel.SelectOption(tp,60,61)
    local res=Duel.TossCoin(tp,1)	
    if coin~=res then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_EQUIP)
        e1:SetCode(EFFECT_DIRECT_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    else 
        local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,e:GetHandler():GetEquipTarget())
        Duel.Destroy(g,REASON_EFFECT)
    end
end
---------------------------------------------------------------------
function c77239015.filter1(c)
	return c:IsCode(77239015) and c:IsAbleToRemove()
end
function c77239015.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c77239015.filter1,tp,LOCATION_GRAVE,0,e:GetHandler(),e:GetHandler():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c77239015.banop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77239015.filter1,tp,LOCATION_GRAVE,0,e:GetHandler(),e:GetHandler():GetCode())
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end