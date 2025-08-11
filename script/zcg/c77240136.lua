--邪神·神化身亚瓦塔
function c77240136.initial_effect(c)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77240136.spcon)
    e1:SetOperation(c77240136.spop)
    c:RegisterEffect(e1)
	
    --battle indestructable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetValue(1)
    c:RegisterEffect(e2)

    --immune effect
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetValue(c77240136.efilter)
    c:RegisterEffect(e3)
	
    --atkup
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_ATKCHANGE)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCost(c77240136.atkcost)
    e4:SetOperation(c77240136.atkop)
    c:RegisterEffect(e4)

    --win
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_ADJUST)
    e5:SetRange(LOCATION_MZONE)
    e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e5:SetOperation(c77240136.winop)
    c:RegisterEffect(e5)
end
---------------------------------------------------------------------
function c77240136.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c77240136.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
---------------------------------------------------------------------
function c77240136.efilter(e,te)
    return te:IsActiveType(TYPE_MONSTER) and not e:GetHandler()
end
---------------------------------------------------------------------
function c77240136.val(e,c)
    local tp=c:GetControler()
    return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)*500
end
---------------------------------------------------------------------
function c77240136.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(3206)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c77240136.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(10000)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        c:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        c:RegisterEffect(e2)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_UPDATE_ATTACK)
        e3:SetValue(g*500)
        e3:SetReset(RESET_EVENT+0x1ff0000)
        c:RegisterEffect(e3)
        local e4=e3:Clone()
        e4:SetCode(EFFECT_UPDATE_DEFENSE)
        c:RegisterEffect(e4)
    end
end
---------------------------------------------------------------------
function c77240136.winop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLP(tp)<Duel.GetLP(1-tp) then
        Duel.Win(tp,100)
    end
end