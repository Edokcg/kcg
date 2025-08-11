--地狱战场
function c77240047.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)

    --atkup
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c77240047.atkcon)
    e2:SetTarget(c77240047.target)
    e2:SetOperation(c77240047.atkop)
    c:RegisterEffect(e2)
	
    --场上存在时不能发动场地魔法卡
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,1)
	e3:SetValue(c77240047.distg)
	c:RegisterEffect(e3)
	
	--场上存在时不能放置场地魔法卡
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SSET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetTargetRange(1,1)
	e4:SetTarget(c77240047.sfilter)
	c:RegisterEffect(e4)
end
---------------------------------------------------------------------
function c77240047.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer()
end
function c77240047.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER) end
    local sg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_MONSTER)
    Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,sg,sg:GetCount(),0,0)
end
function c77240047.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    local sg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_MONSTER)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(sg:GetCount()*100)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
end
---------------------------------------------------------------------
function c77240047.distg(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:IsActiveType(TYPE_FIELD)
	and not te:GetOwner():IsSetCard(0x900)
end

function c77240047.sfilter(e,c,tp)
	return c:IsType(TYPE_FIELD) and Duel.GetFieldCard(c:GetControler(),LOCATION_SZONE,5)~=nil and c~=e:GetHandler()
end