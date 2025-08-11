--冥界勇士
function c77239050.initial_effect(c)
	--特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c77239050.sptg)
	e1:SetOperation(c77239050.spop)
	c:RegisterEffect(e1)
	
	--战斗伤害送去墓地
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76039636,0))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c77239050.condition)
	e2:SetTarget(c77239050.target)
	e2:SetOperation(c77239050.operation)
	c:RegisterEffect(e2)	
end
---------------------------------------------------------------------
function c77239050.filter(c,e,tp)
    return c:IsCode(77239047) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239050.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239050.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c77239050.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239050.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
---------------------------------------------------------------------
function c77239050.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c77239050.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,1-tp,1)
end
function c77239050.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,1,REASON_EFFECT)
end

