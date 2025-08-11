--黑魔導女孩 红将(ZCG)
function c77239954.initial_effect(c)
    --battle indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e1:SetCountLimit(1)
    e1:SetValue(c77239954.valcon)
    c:RegisterEffect(e1)

	--to defense
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239954,0))
    e2:SetCategory(CATEGORY_POSITION)
    e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetTarget(c77239954.postg)
    e2:SetOperation(c77239954.posop)
    c:RegisterEffect(e2)
	
    --atkup
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(c77239954.val)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e4)	
	
	--[[
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_ONLY_BE_ATTACKED)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(0,LOCATION_MZONE)
    e5:SetCondition(c77239954.con)
    c:RegisterEffect(e5)]]

    --cannot be battle target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetValue(c77239954.tg)
	c:RegisterEffect(e5)
end
-----------------------------------------------------------------
function c77239954.valcon(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0
end
-----------------------------------------------------------------
function c77239954.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return e:GetHandler():IsAttackPos() end
    Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c77239954.posop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsAttackPos() and c:IsRelateToEffect(e) then
        Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
    end
end
-----------------------------------------------------------------
function c77239954.val(e,c)
    return Duel.GetMatchingGroupCount(Card.IsRace,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil,RACE_SPELLCASTER)*300
end
-----------------------------------------------------------------
--[[function c77239954.spfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end]]
function c77239954.tg(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end