--Guardian Dreadscythe
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    --Ssummon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(0)
    c:RegisterEffect(e1)

    --Special Summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(1995985,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_HAND+LOCATION_DECK)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetCondition(s.spcon)
    e2:SetTarget(s.sptg)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)

    --Destroy replace
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e9:SetCode(EFFECT_DESTROY_REPLACE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetTarget(s.desreptg)
    e9:SetOperation(s.repop)
    c:RegisterEffect(e9)

    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_CHANGE_POS)
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetCondition(s.descon)
    e4:SetOperation(s.desop)
    c:RegisterEffect(e4)

      --Cannot Normal Summon or Special Summon
      local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,0)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e7)
end
s.listed_names={34022290,81954378}
function s.cfilter(c,tp)
	return c:IsControler(tp) and c:IsCode(34022290) 
--and c:IsRelateToBattle()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,e:GetHandler():GetControler())
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
     local c=e:GetHandler()
     if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP_DEFENSE)<1 then return end
	 c:CompleteProcedure()
	 Duel.BreakEffect()
	 if Duel.SelectYesNo(tp,aux.Stringid(14745409,0)) 
        and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil) then
     local g=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
     if g:GetCount()>0 then Duel.Equip(tp,g:GetFirst(),c) end
     end
end

function s.eqfilter(c)
	return c:IsCode(81954378) 
end

function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return not c:IsReason(REASON_REPLACE) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
    return true
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
     return e:GetHandler():GetPosition()==POS_FACEUP_ATTACK
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
     local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,e:GetHandler())
     if g~=nil then Duel.Destroy(g,REASON_EFFECT) end
end
