--抒情歌鸲-闪烁椋鸟（neet）
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xf7),1)
--atklimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
--reflect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e2:SetTarget(s.reftg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
--special summon
	local e10=Effect.CreateEffect(c)
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e10:SetCode(EVENT_ATTACK_ANNOUNCE)
	e10:SetRange(LOCATION_GRAVE)
	e10:SetCountLimit(1,id)
	e10:SetCondition(s.spcon)
	e10:SetTarget(s.sptg)
	e10:SetOperation(s.spop)
	c:RegisterEffect(e10)
end
s.listed_series={0xf7}
function s.atkval(e,c)
	return Duel.GetOverlayCount(c:GetControler(),1,0)*200
end
function s.reftg(e,c)
	return c:IsSetCard(0xf7)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at and at:IsControler(1-tp)
end
function s.spfilter(c,e,tp,mc,pg)
	return c:IsFacedown() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xf7)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and mc:IsCanBeXyzMaterial(c,tp) and not c:IsCode(id)
		and (not pg or #pg<=0 or pg:IsContains(mc))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c,pg)
	local sc=g:GetFirst()
	if sc then
		Duel.BreakEffect()
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,c)
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end