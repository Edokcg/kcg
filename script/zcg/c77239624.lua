--植物的愤怒 植物老守者
function c77239624.initial_effect(c)
    --cannot attack
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetCondition(c77239624.atkcon)
    e1:SetTarget(c77239624.atktg)
    c:RegisterEffect(e1)

	--check
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetOperation(c77239624.checkop)
    e3:SetLabelObject(e1)
    c:RegisterEffect(e3)
	
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e4:SetTarget(c77239624.atlimit)
    e4:SetValue(1)
    c:RegisterEffect(e4)
	
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    e2:SetValue(c77239624.value)
    c:RegisterEffect(e2)	
end
----------------------------------------------------------------
function c77239624.atkcon(e)
    return e:GetHandler():GetFlagEffect(77239624)~=0
end
function c77239624.atktg(e,c)
    return c:GetFieldID()~=e:GetLabel()
end
function c77239624.checkop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():GetFlagEffect(77239624)~=0 then return end
    local fid=eg:GetFirst():GetFieldID()
    e:GetHandler():RegisterFlagEffect(77239624,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
    e:GetLabelObject():SetLabel(fid)
end
----------------------------------------------------------------
function c77239624.value(e,c)
    return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_ONFIELD)*500
end

function c77239624.atlimit(e,c)
    return c~=e:GetHandler()
end
