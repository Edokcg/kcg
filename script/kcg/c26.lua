--クロス·ソウル
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(18235309,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(function()return Duel.IsMainPhase() end)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)  
	c:RegisterEffect(e1)
end

function s.filter(c)
	return not (c:IsHasEffect(EFFECT_UNRELEASABLE_SUM) or c:IsHasEffect(EFFECT_UNRELEASABLE_NONSUM)) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.filter1(c)
	return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	  local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	  if chk==0 then return g:GetCount()>0 end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    if g:GetCount()==0 then return end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_EXTRA_RELEASE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e1:SetReset(RESET_PHASE|PHASE_END)
    Duel.RegisterEffect(e1,tp)
	if Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,1) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
        local tc=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
        if tc then
            local s1=tc:IsSummonable(true,nil,1)
            local s2=tc:IsMSetable(true,nil,1)
            if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
                Duel.Summon(tp,tc,true,nil,1)
            else
                Duel.MSet(tp,tc,true,nil,1)
            end
        end
    end
end
