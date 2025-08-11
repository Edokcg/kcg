--殉道者的吸泉
function c77240175.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetCondition(c77240175.condition)
    --e1:SetTarget(c77240175.target)
    e1:SetOperation(c77240175.activate)
    c:RegisterEffect(e1)
    --[[if not c77240175.global_check then
        c77240175.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_TO_GRAVE)
        ge1:SetOperation(c77240175.checkop)
        Duel.RegisterEffect(ge1,0)
    end]]

    --奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_SZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77240175.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_SZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77240175.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_SZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77240175.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_SZONE)
    e13:SetOperation(c77240175.disop)
    c:RegisterEffect(e13)
end
--[[function c77240175.cfilter(c,tp)
    return c:IsControler(tp) and c:GetPreviousControler()==tp
end]]
function c77240175.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:GetPreviousLocation()==LOCATION_MZONE
end
function c77240175.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77240175.cfilter,1,nil,tp)
end
--[[function c77240175.checkop(e,tp,eg,ep,ev,re,r,rp)
    for p=0,1 do
        if eg:IsExists(c77240175.cfilter,2,nil,p) then
            Duel.RegisterFlagEffect(p,85602018,RESET_PHASE+PHASE_END,0,1)
        end
    end
end
function c77240175.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    if Duel.GetFlagEffect(tp,85602018)~=0 then
        e:SetCategory(CATEGORY_HANDES)
		local sg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,sg,sg:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,sg:GetCount()*500)
        e:SetLabel(1)
    else
        e:SetCategory(0)
        e:SetLabel(0)
    end
end
function c77240175.activate(e,tp,eg,ep,ev,re,r,rp)
    if e:GetLabel()==1
        Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
        local sg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
        local ct=Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
        Duel.Recover(tp,ct*500,REASON_EFFECT)
    else
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_FREE_CHAIN)
        e1:SetCountLimit(1)
        e1:SetCondition(c77240175.recon)
        e1:SetOperation(c77240175.reop)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
    end
end
function c77240175.recon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFlagEffect(tp,85602018)~=0
        and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
end]]
function c77240175.activate(e,tp,eg,ep,ev,re,r,rp)
    --Duel.Hint(HINT_CARD,0,85602018)
    local sg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    local ct=Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
    Duel.Recover(tp,ct*500,REASON_EFFECT)
end

function c77240175.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77240175.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77240175.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end