--奥利哈刚 阿拉克涅
function c77239212.initial_effect(c)
    --[[
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239212,0))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_CHANGE_POS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetOperation(c77239212.operation)
    c:RegisterEffect(e1)]]
	
	--转移控制
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCategory(CATEGORY_CONTROL)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c77239212.ctltg)
    e1:SetOperation(c77239212.ctlop)
    c:RegisterEffect(e1)
	
    --damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetDescription(aux.Stringid(77239212,1))
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c77239212.damcon)
    --e2:SetTarget(c77239212.damtg)
    e2:SetOperation(c77239212.damop)
    c:RegisterEffect(e2)
end

function c77239212.ctltg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsControlerCanBeChanged() end
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function c77239212.ctlop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.GetControl(c,1-tp) then
		local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
    c:RegisterEffect(e2)	
    local e3=e2:Clone()
    e3:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EFFECT_UNRELEASABLE_SUM)
    c:RegisterEffect(e6)
    end
end

function c77239212.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
    c:RegisterEffect(e2)	
    local e3=e2:Clone()
    e3:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EFFECT_UNRELEASABLE_SUM)
    c:RegisterEffect(e6)	
end

function c77239212.damcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
--[[function c77239212.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1000)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,1000)
end]]
function c77239212.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Damage(tp,1000,REASON_EFFECT)
    Duel.Recover(1-tp,1000,REASON_EFFECT)	
end
