--千年锡杖
function c77238294.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77238294.target)
    e1:SetOperation(c77238294.activate)
    c:RegisterEffect(e1)
	
    --battle indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCountLimit(2)
	e2:SetValue(c77238294.valcon)
	c:RegisterEffect(e2)

	--[[
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(c77238294.desreptg)
    e2:SetOperation(c77238294.desrepop)
    c:RegisterEffect(e2)]]

	--
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_PUBLIC)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,LOCATION_HAND)
    c:RegisterEffect(e3)
end
----------------------------------------------------------------------
function c77238294.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
        Duel.IsPlayerCanSpecialSummonMonster(tp,e:GetHandler():GetCode(),nil,0x11,0,0,0,0,0,POS_FACEUP) end
	e:GetHandler():SetTurnCounter(0)	
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77238294.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        or not Duel.IsPlayerCanSpecialSummonMonster(tp,e:GetHandler():GetCode(),nil,0x11,0,0,0,0,0,POS_FACEUP) then return end
    c:AddMonsterAttribute(TYPE_EFFECT+TYPE_SPELL)
    Duel.SpecialSummon(c,1,tp,tp,true,false,POS_FACEUP)
end
-------------------------------------------------------------------
--[[function c77238294.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReason(REASON_BATTLE) and c:IsOnField() and c:IsFaceup() end
    if c then
        return true
    else return false end		
end
function c77238294.desrepop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetTurnCounter()
    ct=ct+1
    c:SetTurnCounter(ct)
    if ct>1 then
        Duel.Destroy(c,REASON_RULE)
    end
end]]

function c77238294.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end