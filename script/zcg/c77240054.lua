--黑暗兽的红火焰
function c77240054.initial_effect(c)
    --破坏
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c77240054.target)
    e1:SetOperation(c77240054.activate)
    c:RegisterEffect(e1)

    --atk
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(2000)
    e2:SetCondition(c77240054.con)
    c:RegisterEffect(e2)

    --extra att
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_EXTRA_ATTACK)
    e3:SetValue(1)
    c:RegisterEffect(e3)

    --damage
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetCode(EVENT_CHAINING)
    e4:SetRange(LOCATION_MZONE)
    e4:SetOperation(aux.chainreg)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e5:SetCode(EVENT_CHAIN_SOLVED)
    e5:SetRange(LOCATION_MZONE)
    e5:SetOperation(c77240054.damop)
    c:RegisterEffect(e5)
	
    --destroy
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_RELEASE+CATEGORY_DESTROY)
	e6:SetDescription(aux.Stringid(77240054,0))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetCondition(c77240054.descon)
	e6:SetTarget(c77240054.destg)
	e6:SetOperation(c77240054.desop)
	c:RegisterEffect(e6)
end
---------------------------------------------------------------------
function c77240054.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77240054.activate(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    Duel.Destroy(sg,REASON_EFFECT)
end
---------------------------------------------------------------------
function c77240054.spfilter(c)
    return c:IsAttribute(ATTRIBUTE_DARK)
end
function c77240054.con(e,c)
    if c==nil then return true end
    local g=Duel.GetMatchingGroup(c77240054.spfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
    local ct=g:GetClassCount(Card.GetCode)
    return ct>6
end
---------------------------------------------------------------------
function c77240054.damop(e,tp,eg,ep,ev,re,r,rp)
    local c=re:GetHandler()
    if re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp~=tp and e:GetHandler():GetFlagEffect(1)>0 then
        Duel.Damage(rp,1000,REASON_EFFECT)
    end
end
---------------------------------------------------------------------
function c77240054.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetOperation(c77240054.cost)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
end
function c77240054.thfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end

function c77240054.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c77240054.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsLocation(LOCATION_DECK) end
	if not Duel.CheckReleaseGroup(tp,nil,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	end
end
function c77240054.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if Duel.IsExistingMatchingCard(c77240054.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(77240054,0)) then
		local g=Duel.SelectMatchingCard(tp,c77240054.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	else Duel.Destroy(c,REASON_EFFECT) end
end