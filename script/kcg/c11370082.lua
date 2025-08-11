--Seventh Around
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_series={0x48}

function s.cfilter(c)
	if not c:IsType(TYPE_XYZ) then return false end
	local no=c.xyz_number
	return (c:IsSetCard(0x48) and no and no>=101 and no<=107)
		or c:GetOverlayGroup():IsExists(s.cfilter,1,nil)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetBattleMonster(tp)
	return tc and s.cfilter(tc)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetBattleMonster(tp)
	local g=tc:GetOverlayGroup()
	if chk==0 then return tc:IsAbleToRemove() and (#g==0 or #g==g:FilterCount(Card.IsAbleToRemove,nil)) end
	g:AddCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	Duel.ChangeBattleDamage(ep,0)
	local tc=Duel.GetBattleMonster(tp)
	local og=tc:GetOverlayGroup()
	og:AddCard(tc)
	if Duel.Remove(og,POS_FACEUP,REASON_EFFECT)>0 then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
        if g:GetCount()>0 then
            local g1=g:GetFirst()
            Duel.SpecialSummon(g1,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
            g1:CompleteProcedure()
            local e1=Effect.CreateEffect(c)
            e1:SetCategory(CATEGORY_DAMAGE)
            e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e1:SetCountLimit(1)
            e1:SetLabel(g1:GetBaseAttack())
            e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
            e1:SetOperation(s.desop)
            e1:SetReset(RESET_PHASE+PHASE_END) 
            Duel.RegisterEffect(e1,tp) 
        end 
    end
end
function s.filter(c,e,tp)
	return c:IsRankBelow(3) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false,POS_FACEUP,tp)
	and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,e:GetLabel(),REASON_EFFECT)
end