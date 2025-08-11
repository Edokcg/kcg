--奥利哈刚 恶魔化蕾欧丝(ZCG)
function c77239204.initial_effect(c)
    c:EnableReviveLimit()   
 
    --效果免疫
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(c77239204.tg)
    e1:SetValue(c77239204.efilter)
    c:RegisterEffect(e1)
 
    --特殊召唤
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c77239204.sprcon)
    e2:SetOperation(c77239204.sprop)
    c:RegisterEffect(e2)
    
    --攻击力
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(c77239204.atkval)
    c:RegisterEffect(e3)    
    
	--复制效果
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,77239204)
    e4:SetCost(c77239204.cost)
    e4:SetOperation(c77239204.spop)
    c:RegisterEffect(e4)    

    --token
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCondition(c77239204.condition)	
    e5:SetTarget(c77239204.sptg2)
    e5:SetOperation(c77239204.spop2)
    c:RegisterEffect(e5)
	
    --战斗伤害为0
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e6:SetValue(1)
    c:RegisterEffect(e6)	
end
-------------------------------------------------------------------------
function c77239204.tg(e,c)
    return (c:IsSetCard(0xa50) or (c:IsCode(170000166) or c:IsCode(170000167) or c:IsCode(170000168) or c:IsCode(170000169) 
	or c:IsCode(170000170) or c:IsCode(170000171) or c:IsCode(170000172) or c:IsCode(170000174)))
end
------------------------------------------------------------------
function c77239204.efilter(e,te)
    return te:GetHandler():GetControler()~=e:GetHandlerPlayer()
end
------------------------------------------------------------------
function c77239204.spfilter(c)
    return (c:IsSetCard(0xa50) or (c:IsCode(170000166) or c:IsCode(170000167) or c:IsCode(170000168) or c:IsCode(170000169) 
	or c:IsCode(170000170) or c:IsCode(170000171) or c:IsCode(170000172) or c:IsCode(170000174))) and c:IsAbleToGraveAsCost()
end
function c77239204.sprcon(e,c)
    if c==nil then return true end 
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
        and Duel.IsExistingMatchingCard(c77239204.spfilter,tp,LOCATION_MZONE,0,3,nil)
end
function c77239204.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c77239204.spfilter,tp,LOCATION_MZONE,0,3,3,nil)
    local tc=g:GetFirst()
    while tc do
        if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
        tc=g:GetNext()
    end
    Duel.SendtoGrave(g,nil,3,REASON_COST)
end
------------------------------------------------------------------
function c77239204.vfilter(c)
    return (c:IsSetCard(0xa50) or (c:IsCode(170000166) or c:IsCode(170000167) or c:IsCode(170000168) or c:IsCode(170000169) or c:IsCode(170000170) or c:IsCode(170000171) or c:IsCode(170000172) or c:IsCode(170000174))) and c:IsFaceup()
end
function c77239204.atkval(e,c)
    return Duel.GetMatchingGroupCount(c77239204.vfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*500
end
------------------------------------------------------------------
function c77239204.filter(c)
    return c:IsSetCard(0xa50) and not c:IsPublic() and c:IsType(TYPE_EFFECT)
end
function c77239204.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239204.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,c77239204.filter,tp,LOCATION_DECK,0,1,1,nil)
    Duel.ConfirmCards(1-tp,g)
    e:SetLabel(g:GetFirst():GetCode())
end
function c77239204.spop(e,tp,eg,ep,ev,re,r,rp)
    local code=e:GetLabel()
    e:GetHandler():CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)		
end
------------------------------------------------------------------
function c77239204.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c77239204.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,77239205,0xa50,0,0,2500,4,RACE_DEVINE,ATTRIBUTE_DARK) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function c77239204.spop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
    if not Duel.IsPlayerCanSpecialSummonMonster(tp,77239205,0xa50,0,0,2500,4,RACE_DEVINE,ATTRIBUTE_DARK) then return end
    local token=Duel.CreateToken(tp,77239205)
    Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(token)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetRange(LOCATION_MZONE)
        e1:SetTargetRange(0,LOCATION_MZONE)
        e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
        e1:SetValue(c77239204.atlimit)
        token:RegisterEffect(e1)
    Duel.SpecialSummonComplete()
end
function c77239204.atlimit(e,c)
    return c~=e:GetHandler()
end



