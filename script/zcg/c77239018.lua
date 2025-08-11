--邪心教义-怒
function c77239018.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetTarget(c77239018.target)
    e1:SetOperation(c77239018.operation)
    c:RegisterEffect(e1)
    --Equip limit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_EQUIP_LIMIT)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetValue(c77239018.eqlimit)
    c:RegisterEffect(e4)

	--破坏
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c77239018.target2)
	e2:SetOperation(c77239018.operation2)
	c:RegisterEffect(e2)
	
	--除外
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c77239018.bantg)
	e3:SetOperation(c77239018.banop)
	c:RegisterEffect(e3)	
end
-------------------------------------------------------------------
function c77239018.filter(c)
    return c:IsFaceup()
end
function c77239018.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c77239018.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c77239018.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c77239018.filter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c77239018.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp,e:GetHandler(),tc)
    end
end
function c77239018.eqlimit(e,c)
	return e:GetHandlerPlayer()==c:GetControler()
end
-------------------------------------------------------------------
function c77239018.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,e:GetHandler():GetEquipTarget()) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,e:GetHandler():GetEquipTarget())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239018.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,e:GetHandler():GetEquipTarget())
	Duel.Destroy(sg,REASON_EFFECT)
	local ct=Duel.GetOperatedGroup()
    local sum=0
    local tc=ct:GetFirst()
    while tc do
        local lv=tc:GetTextAttack()
        sum=sum+lv
        tc=ct:GetNext()
    end	
    if sum>0 and e:GetHandler():GetEquipTarget():IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_EQUIP)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(sum)
        c:RegisterEffect(e1)
    end
end
----------------------------------------------------------------------
function c77239018.filter2(c)
	return c:IsCode(77239018) and c:IsAbleToRemove()
end
function c77239018.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c77239018.filter2,tp,LOCATION_GRAVE,0,e:GetHandler(),e:GetHandler():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c77239018.banop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77239018.filter2,tp,LOCATION_GRAVE,0,e:GetHandler(),e:GetHandler():GetCode())
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end