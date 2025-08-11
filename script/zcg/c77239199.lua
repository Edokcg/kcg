--苏生的石板
function c77239199.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77239199,EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c77239199.sptg)
	e1:SetOperation(c77239199.spop)
	c:RegisterEffect(e1)
	aux.GlobalCheck(c77239199,function()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_DESTROYED)
		e1:SetOperation(c77239199.regop)
		Duel.RegisterEffect(e1,0)
	end)
end
--[[function c77239199.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=eg:GetFirst()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:GetCount()==1 and tc:GetPreviousControler()==tp
        and tc:IsLocation(LOCATION_GRAVE) and tc:IsReason(REASON_BATTLE)
        and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,tc:GetPreviousPosition(),tc:GetPreviousControler()) end
    tc:CreateEffectRelation(e)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,eg,1,0,0)
end
function c77239199.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end]]

function c77239199.regfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-c:GetControler())
end
function c77239199.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c77239199.regfilter,nil)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(77239199,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	end
end
function c77239199.spfilter(c,e,tp)
	return c:GetFlagEffect(77239199)~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239199.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77239199.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c77239199.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(c77239199.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if ft<=0 or #tg==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:Select(tp,ft,ft,nil)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end