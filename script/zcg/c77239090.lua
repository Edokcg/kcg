--黑魔导女贤者(ZCG)
function c77239090.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND+LOCATION_DECK)
    e1:SetCondition(c77239090.otcon)
    e1:SetOperation(c77239090.otop)
    c:RegisterEffect(e1)
	
    --spsummon
    local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetTarget(c77239090.target)
    e2:SetOperation(c77239090.activate)
    c:RegisterEffect(e2)
end
---------------------------------------------------------------------------------
function c77239090.otfilter(c,tp)
    return c:IsRace(RACE_SPELLCASTER) and (c:IsControler(tp) or c:IsFaceup())
end
function c77239090.otcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c77239090.otfilter,tp,LOCATION_MZONE,0,nil,tp)
    return mg:GetCount()>0
end
function c77239090.otop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c77239090.otfilter,tp,LOCATION_MZONE,0,nil,tp)
    local sg=Duel.SelectTribute(tp,c,1,1,mg)
    Duel.Release(sg,REASON_COST)
end
---------------------------------------------------------------------------------
function c77239090.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,4,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,4,tp,LOCATION_DECK)
end
function c77239090.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77239090,0))
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_DECK,0,4,4,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
