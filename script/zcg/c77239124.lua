--地狱之青眼白龙(ZCG)
function c77239124.initial_effect(c)
    --不能特殊召唤
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)
	
	--破坏
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c77239124.destg)
	e2:SetOperation(c77239124.desop)
	c:RegisterEffect(e2)
	
    --造成战斗伤害
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetCode(EVENT_BATTLE_DAMAGE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCondition(c77239124.spcon)
    e3:SetOperation(c77239124.spop)
    c:RegisterEffect(e3)
	
    --送墓时
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCondition(c77239124.condition)
    e4:SetTarget(c77239124.target)
    e4:SetOperation(c77239124.operation)
    c:RegisterEffect(e4)	
end
------------------------------------------------------------------
function c77239124.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77239124.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
------------------------------------------------------------------
function c77239124.spcon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp
end
function c77239124.spop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetCode(EFFECT_SKIP_BP)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,3)
    Duel.RegisterEffect(e1,tp)
    Duel.Draw(tp,2,REASON_EFFECT)	
end
------------------------------------------------------------------
function c77239124.condition(e,tp,eg,ep,ev,re,r,rp)
    local pl=e:GetHandler():GetPreviousLocation()
    return bit.band(r,REASON_DESTROY)~=0 and bit.band(pl,LOCATION_ONFIELD)~=0
end
function c77239124.filter(c,e,sp)
    return c:IsCode(89631139) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c77239124.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239124.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c77239124.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239124.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,3,3,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end

