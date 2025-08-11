--黑魔导·黑将
function c77239082.initial_effect(c)
	--特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c77239082.spcon)
	e1:SetOperation(c77239082.spop)
	c:RegisterEffect(e1)
	
    --不能发动怪兽效果
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,1)
    e2:SetValue(c77239082.aclimit)
    c:RegisterEffect(e2)	
	
    --token
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetTarget(c77239082.target)
    e3:SetOperation(c77239082.operation)
    c:RegisterEffect(e3)
end
--------------------------------------------------------------------------
function c77239082.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0		
end
function c77239082.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(-500)
    e1:SetReset(RESET_EVENT+0xff0000)
    c:RegisterEffect(e1)
end
--------------------------------------------------------------------------
function c77239082.aclimit(e,re,tp)
    return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
--------------------------------------------------------------------------
function c77239082.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c77239082.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
    if not Duel.IsPlayerCanSpecialSummonMonster(tp,77239083,0,0x4011,1800,1400,5,RACE_SPELLCASTER,ATTRIBUTE_DARK) then return end
    local token=Duel.CreateToken(tp,77239083)
    if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e1:SetValue(1)
        token:RegisterEffect(e1,true)
        if not Duel.IsPlayerCanSpecialSummonMonster(tp,77239084,0,0x4011,700,700,2,RACE_SPELLCASTER,ATTRIBUTE_DARK) then return end
        local token2=Duel.CreateToken(tp,77239084)
        if Duel.SpecialSummonStep(token2,0,tp,tp,false,false,POS_FACEUP) then
            local e2=Effect.CreateEffect(e:GetHandler())
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
            e2:SetValue(1)
            token2:RegisterEffect(e2,true) 
		end
    end    
    Duel.SpecialSummonComplete()
end