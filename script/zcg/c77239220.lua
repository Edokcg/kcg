--奥利哈刚 殴墨尼得(ZCG)
function c77239220.initial_effect(c)
	--不会被战斗破坏
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c77239220.ebcon)
	c:RegisterEffect(e1)

    --战斗伤害为0
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
	
    --special summon
    local e3=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1)
    e3:SetCost(c77239220.cost)
    e3:SetTarget(c77239220.sptg)
    e3:SetOperation(c77239220.spop)
    c:RegisterEffect(e3)	
end
--------------------------------------------------------------------
function c77239220.ebcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
--------------------------------------------------------------------
function c77239220.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (c:IsSetCard(0xa50) or (c:IsCode(170000166) or c:IsCode(170000167) or c:IsCode(170000168) or c:IsCode(170000169) or c:IsCode(170000170) or c:IsCode(170000171) or c:IsCode(170000172) or c:IsCode(170000174)))
end
function c77239220.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239220.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c77239220.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
    Duel.SendtoGrave(g,REASON_COST)
end
function c77239220.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77239220.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end

