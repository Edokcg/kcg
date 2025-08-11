--黑暗套索
function c77239024.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c77239024.target)
	e1:SetOperation(c77239024.activate)
	c:RegisterEffect(e1)
end
--[[function c77239024.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end]]
function c77239024.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c77239024.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c77239024.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c77239024.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77239024.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	    --e1:SetCondition(c77239024.condition)		
        e1:SetCountLimit(1)
        e1:SetOperation(c77239024.atkop)
		tc:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
function c77239024.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(300)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        c:RegisterEffect(e1)
	    local e2=e1:Clone()
	    e2:SetCode(EFFECT_UPDATE_DEFENSE)
	    e2:SetValue(300)
	    c:RegisterEffect(e2)		
    end
end