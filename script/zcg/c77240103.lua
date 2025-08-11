--神的余晖
function c77240103.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)

    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_CHANGE_RECOVER)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(1,1)
    e3:SetValue(c77240103.damval)
    c:RegisterEffect(e3)

    --[[damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_REVERSE_RECOVER)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(1,0)
    e2:SetValue(1)
    c:RegisterEffect(e2)

    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_CHANGE_DAMAGE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(1,0)
    e3:SetValue(c77240103.damval)
    c:RegisterEffect(e3)

    local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DAMAGE)
    e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c77240103.activate)
	c:RegisterEffect(e4)
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_RECOVER)
	e2:SetCondition(c77240103.damcon1)
	e2:SetTarget(c77240103.damtg1)
	e2:SetOperation(c77240103.damop1)
	c:RegisterEffect(e2)

    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_RECOVER)
	e3:SetCondition(c77240103.damcon2)
	e3:SetTarget(c77240103.damtg2)
	e3:SetOperation(c77240103.damop2)
	c:RegisterEffect(e3)]]
end

function c77240103.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return (r&REASON_EFFECT)~=0 and re and re:GetHandler():GetCode()~=77240103 and re:GetTarget(tp)
end

function c77240103.damtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(ev)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,ev)
end

function c77240103.damop1(c,e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end

function c77240103.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return (r&REASON_EFFECT)~=0 and re and re:GetHandler():GetCode()~=77240103 and not re:GetTarget(tp)
end

function c77240103.damtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(ev)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,ev)
end

function c77240103.damop2(c,e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end

function c77240103.damval(e,re,val,r,rp,rc)
    return val*2
end