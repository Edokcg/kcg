--女子佣兵 灭灵者(ZCG)
function c77239538.initial_effect(c)
    --[[
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239538,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetRange(LOCATION_HAND+LOCATION_DECK)
    e1:SetCondition(c77239538.condition)
    e1:SetTarget(c77239538.sptg)
    e1:SetOperation(c77239538.spop)
    c:RegisterEffect(e1)]]

  --
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCountLimit(1)
	e1:SetCondition(c77239538.condition1)
	e1:SetOperation(c77239538.operation1)
	c:RegisterEffect(e1)

    --damage
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239538,0))
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetTarget(c77239538.tg)
    e2:SetOperation(c77239538.op)
    c:RegisterEffect(e2)
	
end

function c77239538.filter(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND+LOCATION_DECK) and c:GetControler()==tp and c:IsLocation(LOCATION_GRAVE)
end
function c77239538.condition1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77239538.filter,1,nil,tp)
end
function c77239538.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end

--[[function c77239538.filter(c,tp)
    return (c:IsPreviousLocation(LOCATION_HAND) or c:IsPreviousLocation(LOCATION_DECK))
	and c:GetControler()==tp and c:GetPreviousControler()==tp      
end
function c77239538.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c77239538.filter,1,nil,tp)
end
function c77239538.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77239538.spop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
    end
end]]
-------------------------------------------------------------------------------------
function c77239538.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(2000)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2000)
end
function c77239538.op(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end

