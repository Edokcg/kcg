--朱罗纪马普龙（neet）
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,s.matfilter,2,2)
--add type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(30765615)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.indtg)
	c:RegisterEffect(e2)
--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(s.aclimit)
	e3:SetCondition(s.actcon)
	c:RegisterEffect(e3)
 --Special summon
	local e30=Effect.CreateEffect(c)
	e30:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e30:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e30:SetCode(EVENT_TO_GRAVE)
	e30:SetProperty(EFFECT_FLAG_DELAY)
	e30:SetCountLimit(1,{id,1})
	e30:SetCondition(s.spcon)
	e30:SetTarget(s.sptg)
	e30:SetOperation(s.spop)
	c:RegisterEffect(e30)
end
s.listed_series={0x22}
function s.matfilter(c,scard,sumtype,tp)
	return c:IsRace(RACE_DINOSAUR,scard,sumtype,tp) and c:IsAttribute(ATTRIBUTE_FIRE,scard,sumtype,tp)
end
function s.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function s.aclimit(e,re,tp)
	return  re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end
function s.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	return a and a:IsRace(RACE_DINOSAUR) and a:IsControler(tp)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and rp==1-tp))
		and c:IsPreviousControler(tp)
end
function s.spfilter(c,e,tp)
	local pg=aux.GetMustBeMaterialGroup(tp,Group.CreateGroup(),tp,c,nil,REASON_SYNCHRO)
	return #pg<=0 and c:IsSetCard(0x22) and c:IsType(TYPE_SYNCHRO) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
		tc:CompleteProcedure()
	end
end