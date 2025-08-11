--奥利哈刚混沌黄金之虹
function c77239268.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	
    --不能发动效果
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(0,1)
    e2:SetValue(c77239268.aclimit)
    c:RegisterEffect(e2)	

    --不会被破坏
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetRange(LOCATION_FZONE)
    e3:SetTargetRange(LOCATION_ONFIELD,0)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    c:RegisterEffect(e4)	
	
	--直接攻击
	local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_DIRECT_ATTACK)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetRange(LOCATION_FZONE)	
    c:RegisterEffect(e5)
	
    --2次攻击
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_EXTRA_ATTACK)
    e6:SetTargetRange(LOCATION_MZONE,0)
    e6:SetRange(LOCATION_FZONE)	
    e6:SetValue(1)
    c:RegisterEffect(e6)

    --不能攻击宣言
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e7:SetRange(LOCATION_FZONE)		
    e7:SetTargetRange(0,1)
    c:RegisterEffect(e7)	
end

function c77239268.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
